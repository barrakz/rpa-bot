*** Settings ***
Library    Collections
Library    OperatingSystem
Resource   ../src/keywords/sellasist_api.robot

Test Setup     Log To Console    [SELLASIST:API] Start test
Test Teardown  Log To Console    [SELLASIST:API] End test

*** Test Cases ***
Prepare Request Template (Account Subdomain)
    Set Environment Variable    SELLASIST_API_ACCOUNT    ggautolublin
    Remove Environment Variable    SELLASIST_API_BASE_URL

    Sellasist API Init
    ${request}=    Sellasist API Prepare Request    get    /attributes
    ${method}=     Get From Dictionary    ${request}    method
    ${url}=        Get From Dictionary    ${request}    url
    ${headers}=    Get From Dictionary    ${request}    headers

    Should Be Equal    ${method}    GET
    Should Be Equal    ${url}    https://ggautolublin.sellasist.pl/api/v1/attributes
    Dictionary Should Contain Key    ${headers}    accept

Prepare Request Template (Base URL Override)
    Set Environment Variable    SELLASIST_API_BASE_URL    https://api.sellasist.pl
    Remove Environment Variable    SELLASIST_API_ACCOUNT

    ${url}=    Sellasist API Build Endpoint URL    attributes
    Should Be Equal    ${url}    https://api.sellasist.pl/api/v1/attributes

    Remove Environment Variable    SELLASIST_API_BASE_URL
