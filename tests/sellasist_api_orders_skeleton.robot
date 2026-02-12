*** Settings ***
Library    Collections
Resource   ../src/keywords/sellasist_api.robot
Resource   ../src/keywords/sellasist_api_orders.robot

Test Setup     Log To Console    [SELLASIST:API:ORDERS] Start test
Test Teardown  Log To Console    [SELLASIST:API:ORDERS] End test

*** Test Cases ***
Build Orders Queue Request Template
    Set Environment Variable    SELLASIST_API_ACCOUNT    ggautolublin
    Sellasist API Init

    ${request}=    Sellasist API Build Get Orders Queue Request    status_id=1    sale_document=invoice    source=allegro    limit=10    offset=5
    ${method}=     Get From Dictionary    ${request}    method
    ${url}=        Get From Dictionary    ${request}    url
    ${query}=      Get From Dictionary    ${request}    query

    Should Be Equal    ${method}    GET
    Should Be Equal    ${url}    https://ggautolublin.sellasist.pl/api/v1/orders
    Dictionary Should Contain Item    ${query}    status_id    1
    Dictionary Should Contain Item    ${query}    sale_document    invoice
    Dictionary Should Contain Item    ${query}    source    allegro

Resolve Document And Payment Type For Autostacja
    ${payment}=    Create Dictionary    paid=0
    ${order}=      Create Dictionary    invoice=1    payment=${payment}

    ${document_type}=    Sellasist Resolve Document Type    ${order}
    ${payment_type}=     Sellasist Resolve Payment Type For Autostacja    ${order}

    Should Be Equal    ${document_type}    invoice
    Should Be Equal    ${payment_type}    Pobranie

Build Update Requests
    ${order}=    Create Dictionary    id=123    invoice=0    status=1    document_number=
    ${doc_req}=    Sellasist API Build Update Order Document Number Request    123    PAR/1/2026    ${order}
    ${status_req}=    Sellasist API Build Update Order Status Request    123    2    ${order}

    ${doc_payload}=    Get From Dictionary    ${doc_req}    payload
    ${status_payload}=    Get From Dictionary    ${status_req}    payload
    ${doc_url}=        Get From Dictionary    ${doc_req}    url
    ${status_url}=     Get From Dictionary    ${status_req}    url

    Should Contain    ${doc_url}    /orders/123
    Should Contain    ${status_url}    /orders/123
    Dictionary Should Contain Item    ${doc_payload}    document_number    PAR/1/2026
    Dictionary Should Contain Item    ${status_payload}    status    2
