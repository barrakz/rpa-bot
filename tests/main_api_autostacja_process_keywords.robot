*** Settings ***
Library    Collections
Library    OperatingSystem
Resource   ../src/keywords/sellasist_api.robot
Resource   ../src/keywords/sellasist_api_orders.robot

Test Setup     Set Environment Variable    SELLASIST_API_MOCK_DIR    ${CURDIR}${/}fixtures${/}sellasist_api
Test Teardown  Remove Environment Variable    SELLASIST_API_MOCK_DIR

*** Test Cases ***
Main Flow Keywords Stop Before Autostacja When Missing EXE
    Set Environment Variable       SELLASIST_API_ACCOUNT    ggautolublin
    Remove Environment Variable    AUTOSTACJA_EXE

    Sellasist API Init
    ${statuses}=       Sellasist API Get Statuses
    ${status_no_lu}=   Sellasist API Find Status Id By Name    ${statuses}    NO-LU_AutohausOtto
    ${queue}=          Sellasist API Get Orders Queue    ${status_no_lu}    50    0
    ${selected}=       Sellasist API Select Order From Queue    ${queue}
    ${selected_id}=    Get From Dictionary    ${selected}    id
    ${order}=          Sellasist API Get Order Details    ${selected_id}
    ${handoff}=        Sellasist Build Autostacja Handoff    ${order}

    Dictionary Should Contain Key    ${handoff}    order_id
    Dictionary Should Contain Key    ${handoff}    signature
    Dictionary Should Contain Key    ${handoff}    document_type

    ${autostacja_exe}=    Get Environment Variable    AUTOSTACJA_EXE    default=
    Should Be Empty    ${autostacja_exe}
