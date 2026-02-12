*** Settings ***
Library      Collections
Resource     ../src/keywords/sellasist_api.robot

*** Test Cases ***
Prepare Sellasist API Context (No HTTP Calls)
    Sellasist API Init
    ${request}=    Sellasist API Prepare Request    GET    /attributes
    ${url}=        Get From Dictionary    ${request}    url
    Log To Console    [SELLASIST:API] Request template ready: GET ${url}
