*** Settings ***
Library    Collections
Library    OperatingSystem
Resource   ../src/keywords/sellasist_api.robot
Resource   ../src/keywords/sellasist_api_orders.robot

Test Setup     Set Environment Variable    SELLASIST_API_MOCK_DIR    ${CURDIR}${/}fixtures${/}sellasist_api
Test Teardown  Remove Environment Variable    SELLASIST_API_MOCK_DIR

*** Test Cases ***
Build Handoff From Mocked Sellasist Queue
    Set Environment Variable    SELLASIST_API_ACCOUNT    ggautolublin

    ${statuses}=    Sellasist API Get Statuses
    ${status_no_lu}=    Sellasist API Find Status Id By Name    ${statuses}    NO-LU_AutohausOtto
    Should Be Equal As Strings    ${status_no_lu}    38

    ${queue}=       Sellasist API Get Orders Queue    ${status_no_lu}    50    0
    ${selected}=    Sellasist API Select Order From Queue    ${queue}
    ${order_id}=    Get From Dictionary    ${selected}    id
    Should Be Equal As Strings    ${order_id}    94865

    ${order}=       Sellasist API Get Order Details    ${order_id}
    ${handoff}=     Sellasist Build Autostacja Handoff    ${order}

    ${doc_type}=    Get From Dictionary    ${handoff}    document_type
    ${pay_type}=    Get From Dictionary    ${handoff}    payment_type
    ${signature}=   Get From Dictionary    ${handoff}    signature
    ${qty}=         Get From Dictionary    ${handoff}    quantity
    ${price}=       Get From Dictionary    ${handoff}    price
    ${nip}=         Get From Dictionary    ${handoff}    nip

    Should Be Equal    ${doc_type}    invoice
    Should Be Equal    ${pay_type}    PayU
    Should Be Equal    ${signature}    GS55545M2EUR
    Should Be Equal As Integers    ${qty}    1
    Should Be Equal As Numbers    ${price}    53.99
    Should Be Equal As Strings    ${nip}    5321166474
