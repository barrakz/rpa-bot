*** Settings ***
Library    Collections
Resource   ./sellasist_api.robot

*** Keywords ***
Sellasist API Build Get Statuses Request
    ${request}=    Sellasist API Prepare Request    GET    /statuses
    RETURN    ${request}

Sellasist API Build Get Sources Request
    ${request}=    Sellasist API Prepare Request    GET    /sources
    RETURN    ${request}

Sellasist API Build Get Orders Queue Request
    [Arguments]    ${status_id}=${EMPTY}    ${sale_document}=${EMPTY}    ${source}=${EMPTY}    ${limit}=50    ${offset}=0
    ${query}=    Create Dictionary    limit=${limit}    offset=${offset}    sort=asc
    Run Keyword If    '${status_id}'!=''        Set To Dictionary    ${query}    status_id=${status_id}
    Run Keyword If    '${sale_document}'!=''    Set To Dictionary    ${query}    sale_document=${sale_document}
    Run Keyword If    '${source}'!=''           Set To Dictionary    ${query}    source=${source}

    ${request}=    Sellasist API Prepare Request    GET    /orders    ${query}
    RETURN    ${request}

Sellasist API Build Get Order Details Request
    [Arguments]    ${order_id}
    ${request}=    Sellasist API Prepare Request    GET    /orders/${order_id}
    RETURN    ${request}

Build Sellasist Order Update Payload
    [Arguments]    ${order_snapshot}=${EMPTY}
    ${payload}=    Create Dictionary
    ${has_snapshot}=    Run Keyword And Return Status    Should Not Be Empty    ${order_snapshot}
    IF    ${has_snapshot}
        ${payload}=    Copy Dictionary    ${order_snapshot}
    END
    RETURN    ${payload}

Sellasist API Build Update Order Document Number Request
    [Arguments]    ${order_id}    ${document_number}    ${order_snapshot}=${EMPTY}
    ${payload}=    Build Sellasist Order Update Payload    ${order_snapshot}
    Set To Dictionary    ${payload}    document_number=${document_number}
    ${request}=    Sellasist API Prepare Request    PUT    /orders/${order_id}    ${EMPTY}    ${payload}
    RETURN    ${request}

Sellasist API Build Update Order Status Request
    [Arguments]    ${order_id}    ${status_id}    ${order_snapshot}=${EMPTY}
    ${payload}=    Build Sellasist Order Update Payload    ${order_snapshot}
    Set To Dictionary    ${payload}    status=${status_id}
    ${request}=    Sellasist API Prepare Request    PUT    /orders/${order_id}    ${EMPTY}    ${payload}
    RETURN    ${request}

Sellasist API Build Add Order Note Request
    [Arguments]    ${order_id}    ${text}
    ${payload}=    Create Dictionary    order_id=${order_id}    text=${text}
    ${request}=    Sellasist API Prepare Request    POST    /notes    ${EMPTY}    ${payload}
    RETURN    ${request}

Sellasist Resolve Document Type
    [Arguments]    ${order_data}
    ${invoice}=    Evaluate    int($order_data.get('invoice', 0) or 0)
    ${document_type}=    Set Variable If    ${invoice}==1    invoice    receipt
    RETURN    ${document_type}

Sellasist Resolve Payment Type For Autostacja
    [Arguments]    ${order_data}
    ${paid}=    Evaluate    float($order_data.get('paid', $order_data.get('payment', {}).get('paid', 0) or 0))
    ${payment_type}=    Set Variable If    ${paid} > 0    PayU    Pobranie
    RETURN    ${payment_type}
