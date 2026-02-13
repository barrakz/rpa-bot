*** Settings ***
Library    Collections
Library    OperatingSystem
Library    Process
Library    String
Resource   ../../config/variables.robot

*** Keywords ***
Resolve Sellasist API Account
    ${env_account}=    Get Environment Variable    SELLASIST_API_ACCOUNT    default=
    ${account}=        Set Variable If    '${env_account}'!=''    ${env_account}    ${SELLASIST_API_ACCOUNT}
    ${account}=        Strip String    ${account}
    Should Not Be Empty    ${account}    msg=SELLASIST_API_ACCOUNT is required.
    RETURN    ${account}

Resolve Sellasist API Key
    ${env_key}=    Get Environment Variable    SELLASIST_API_KEY    default=
    ${api_key}=    Set Variable If    '${env_key}'!=''    ${env_key}    ${SELLASIST_API_KEY}
    ${api_key}=    Strip String    ${api_key}
    RETURN    ${api_key}

Resolve Sellasist API Base URL
    ${override}=    Get Environment Variable    SELLASIST_API_BASE_URL    default=
    ${override}=    Strip String    ${override}
    IF    '${override}'!=''
        ${override}=      Replace String Using Regexp    ${override}    /+$    ${EMPTY}
        ${has_api_v1}=    Run Keyword And Return Status    Should End With    ${override}    /api/v1
        ${base}=          Set Variable If    ${has_api_v1}    ${override}    ${override}/api/v1
        RETURN    ${base}
    END

    ${account}=    Resolve Sellasist API Account
    ${base}=       Replace String    ${SELLASIST_API_URL_TEMPLATE}    {account}    ${account}
    RETURN    ${base}

Build Sellasist API Headers
    ${api_key}=    Resolve Sellasist API Key
    ${headers}=    Create Dictionary    accept=application/json
    Run Keyword If    '${api_key}'!=''    Set To Dictionary    ${headers}    apiKey=${api_key}
    RETURN    ${headers}

Sellasist API Init
    ${account}=    Resolve Sellasist API Account
    ${base_url}=   Resolve Sellasist API Base URL
    ${headers}=    Build Sellasist API Headers
    ${api_key}=    Resolve Sellasist API Key
    ${key_state}=  Set Variable If    '${api_key}'==''    missing    configured

    Set Suite Variable    ${SELLASIST_API_ACCOUNT_RESOLVED}    ${account}
    Set Suite Variable    ${SELLASIST_API_BASE_URL_RESOLVED}    ${base_url}
    Set Suite Variable    ${SELLASIST_API_HEADERS}              ${headers}

    Log To Console    [SELLASIST:API] account=${account} base=${base_url} apiKey=${key_state}

Sellasist API Build Endpoint URL
    [Arguments]    ${endpoint_path}
    ${base_url}=    Resolve Sellasist API Base URL

    ${path}=          Strip String    ${endpoint_path}
    ${path}=          Set Variable If    '${path}'==''    /    ${path}
    ${has_slash}=     Run Keyword And Return Status    Should Start With    ${path}    /
    ${path}=          Set Variable If    ${has_slash}    ${path}    /${path}
    ${endpoint_url}=  Catenate    SEPARATOR=    ${base_url}    ${path}
    RETURN    ${endpoint_url}

Sellasist API Prepare Request
    [Arguments]    ${method}    ${endpoint_path}    ${query}=${EMPTY}    ${payload}=${EMPTY}
    ${method}=     Convert To Upper Case    ${method}
    ${url}=        Sellasist API Build Endpoint URL    ${endpoint_path}
    ${headers}=    Build Sellasist API Headers

    ${request}=    Create Dictionary    method=${method}    url=${url}    headers=${headers}
    ${has_query}=      Run Keyword And Return Status    Should Not Be Empty    ${query}
    ${has_payload}=    Run Keyword And Return Status    Should Not Be Empty    ${payload}
    IF    ${has_query}
        Set To Dictionary    ${request}    query=${query}
    END
    IF    ${has_payload}
        Set To Dictionary    ${request}    payload=${payload}
    END
    RETURN    ${request}

Sellasist API Resolve GET Mock Path
    [Arguments]    ${endpoint_path}
    ${mock_dir}=    Get Environment Variable    SELLASIST_API_MOCK_DIR    default=
    ${mock_dir}=    Strip String    ${mock_dir}
    IF    '${mock_dir}'==''
        RETURN    ${EMPTY}
    END

    ${path}=    Strip String    ${endpoint_path}
    ${path}=    Set Variable If    '${path}'==''    /    ${path}
    ${has_slash}=     Run Keyword And Return Status    Should Start With    ${path}    /
    ${path}=          Set Variable If    ${has_slash}    ${path}    /${path}

    IF    '${path}'=='/statuses'
        ${file}=    Set Variable    statuses.json
    ELSE IF    '${path}'=='/orders'
        ${file}=    Set Variable    orders.json
    ELSE IF    '${path}'=='/sources'
        ${file}=    Set Variable    sources.json
    ELSE
        ${is_order_details}=    Run Keyword And Return Status    Should Match Regexp    ${path}    ^/orders/[0-9]+$
        IF    ${is_order_details}
            ${order_id}=    Evaluate    $path.split('/')[-1]
            ${file}=    Set Variable    order_${order_id}.json
        ELSE
            RETURN    ${EMPTY}
        END
    END
    ${mock_path}=    Normalize Path    ${mock_dir}${/}${file}
    RETURN    ${mock_path}

Sellasist API Execute GET
    [Arguments]    ${endpoint_path}    ${query}=${EMPTY}
    ${mock_path}=    Sellasist API Resolve GET Mock Path    ${endpoint_path}
    ${has_mock}=     Run Keyword And Return Status    Should Not Be Empty    ${mock_path}
    IF    ${has_mock}
        ${mock_exists}=    Run Keyword And Return Status    File Should Exist    ${mock_path}
        IF    ${mock_exists}
            ${mock_json}=    Get File    ${mock_path}
            ${mock_data}=    Evaluate    json.loads($mock_json)    modules=json
            Log To Console    [SELLASIST:API] GET mock: ${endpoint_path} -> ${mock_path}
            RETURN    ${mock_data}
        END
    END

    ${request}=    Sellasist API Prepare Request    GET    ${endpoint_path}    ${query}
    ${url}=        Get From Dictionary    ${request}    url
    ${headers}=    Get From Dictionary    ${request}    headers
    ${api_key}=    Get From Dictionary    ${headers}    apiKey    default=${EMPTY}

    ${has_query}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${request}    query
    IF    ${has_query}
        ${q}=    Get From Dictionary    ${request}    query
        ${query_string}=    Evaluate    urllib.parse.urlencode($q, doseq=True)    modules=urllib.parse
        ${url}=    Catenate    SEPARATOR=    ${url}    ?    ${query_string}
    END

    ${curl_args}=    Create List    -sS    -L    -H    accept: application/json
    IF    '${api_key}'!=''
        Append To List    ${curl_args}    -H    apiKey: ${api_key}
    END
    Append To List    ${curl_args}    -w    \n%{http_code}    ${url}

    ${result}=    Run Process    curl    @{curl_args}    stdout=PIPE    stderr=PIPE
    Should Be Equal As Integers    ${result.rc}    0    msg=Sellasist GET failed at curl level: ${result.stderr}

    ${out}=      Set Variable    ${result.stdout}
    ${lines}=    Split To Lines    ${out}
    ${idx}=      Evaluate    len($lines) - 1
    ${code}=     Get From List    ${lines}    ${idx}
    ${body}=     Evaluate    '\\n'.join($lines[:-1])
    ${status}=   Convert To Integer    ${code}
    Should Be True    ${status} >= 200 and ${status} < 300    msg=Sellasist GET ${url} failed: HTTP ${status}; body=${body}

    ${data}=     Evaluate    json.loads($body)    modules=json
    RETURN    ${data}
