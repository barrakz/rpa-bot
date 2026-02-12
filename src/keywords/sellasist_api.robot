*** Settings ***
Library    Collections
Library    OperatingSystem
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
