*** Settings ***
Library    Collections
Library    String
Resource   ./sellasist_api.robot

*** Keywords ***
Sellasist API Get Statuses
    ${raw}=     Sellasist API Execute GET    /statuses
    ${data}=    Sellasist API Normalize Statuses Payload    ${raw}
    RETURN    ${data}

Sellasist API Find Status Id By Name
    [Arguments]    ${statuses}    ${name}
    FOR    ${row}    IN    @{statuses}
        ${row_name}=    Get From Dictionary    ${row}    name
        ${match}=       Run Keyword And Return Status    Should Be Equal As Strings    ${row_name}    ${name}
        IF    ${match}
            ${row_id}=    Get From Dictionary    ${row}    id
            RETURN    ${row_id}
        END
    END
    Fail    Could not find status '${name}' in statuses payload.

Sellasist API Get Orders Queue
    [Arguments]    ${status_id}    ${limit}=50    ${offset}=0
    ${query}=    Create Dictionary    status_id=${status_id}    limit=${limit}    offset=${offset}    sort=asc
    ${raw}=      Sellasist API Execute GET    /orders    ${query}
    ${data}=     Sellasist API Normalize Orders Payload    ${raw}
    RETURN    ${data}

Sellasist API Select Order From Queue
    [Arguments]    ${orders}
    ${count}=    Get Length    ${orders}
    Should Be True    ${count} > 0    msg=No orders found in queue.
    # In UI spec operator opens one order from current list; deterministic bot rule: first item in queue.
    ${order}=    Get From List    ${orders}    0
    RETURN    ${order}

Sellasist API Get Order Details
    [Arguments]    ${order_id}
    ${raw}=     Sellasist API Execute GET    /orders/${order_id}
    ${data}=    Sellasist API Normalize Order Details Payload    ${raw}
    RETURN    ${data}

Sellasist API Normalize Statuses Payload
    [Arguments]    ${payload}
    ${is_list}=    Evaluate    isinstance($payload, list)
    IF    ${is_list}
        RETURN    ${payload}
    END

    ${is_dict}=    Evaluate    isinstance($payload, dict)
    Should Be True    ${is_dict}    msg=Unsupported /statuses payload type: ${payload}

    ${has_statuses}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${payload}    statuses
    IF    ${has_statuses}
        ${statuses}=    Get From Dictionary    ${payload}    statuses
        RETURN    ${statuses}
    END

    ${has_data}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${payload}    data
    IF    ${has_data}
        ${statuses}=    Get From Dictionary    ${payload}    data
        RETURN    ${statuses}
    END

    Fail    Could not extract statuses list from payload.

Sellasist API Normalize Orders Payload
    [Arguments]    ${payload}
    ${is_list}=    Evaluate    isinstance($payload, list)
    IF    ${is_list}
        RETURN    ${payload}
    END

    ${is_dict}=    Evaluate    isinstance($payload, dict)
    Should Be True    ${is_dict}    msg=Unsupported /orders payload type: ${payload}

    ${has_orders}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${payload}    orders
    IF    ${has_orders}
        ${orders}=    Get From Dictionary    ${payload}    orders
        RETURN    ${orders}
    END

    ${has_data}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${payload}    data
    IF    ${has_data}
        ${orders}=    Get From Dictionary    ${payload}    data
        RETURN    ${orders}
    END

    Fail    Could not extract orders list from payload.

Sellasist API Normalize Order Details Payload
    [Arguments]    ${payload}
    ${is_dict}=    Evaluate    isinstance($payload, dict)
    Should Be True    ${is_dict}    msg=Unsupported /orders/{id} payload type: ${payload}

    ${has_id}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${payload}    id
    IF    ${has_id}
        RETURN    ${payload}
    END

    ${has_order}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${payload}    order
    IF    ${has_order}
        ${order}=    Get From Dictionary    ${payload}    order
        RETURN    ${order}
    END

    ${has_data}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${payload}    data
    IF    ${has_data}
        ${order}=    Get From Dictionary    ${payload}    data
        RETURN    ${order}
    END

    Fail    Could not extract order details object from payload.

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

Sellasist Build Autostacja Handoff
    [Arguments]    ${order_data}
    ${document_type}=    Sellasist Resolve Document Type For Autostacja    ${order_data}
    ${payment_type}=     Sellasist Resolve Payment Type For Autostacja    ${order_data}

    ${order_id}=         Get From Dictionary    ${order_data}    id
    ${external}=         Get From Dictionary    ${order_data}    external_data    default=${EMPTY}
    ${login}=            Set Variable    ${EMPTY}
    ${has_external}=     Run Keyword And Return Status    Should Not Be Empty    ${external}
    IF    ${has_external}
        ${login}=        Get From Dictionary    ${external}    external_login    default=${EMPTY}
    END

    ${bill}=             Get From Dictionary    ${order_data}    bill_address    default=${EMPTY}
    ${nip}=              Set Variable    ${EMPTY}
    ${has_bill}=         Run Keyword And Return Status    Should Not Be Empty    ${bill}
    IF    ${has_bill}
        ${nip}=          Get From Dictionary    ${bill}    company_nip    default=${EMPTY}
    END

    ${carts}=            Get From Dictionary    ${order_data}    carts
    ${cart_count}=       Get Length    ${carts}
    Should Be True       ${cart_count} > 0    msg=Order ${order_id} has no carts lines.
    ${first}=            Get From List    ${carts}    0

    ${signature}=        Get From Dictionary    ${first}    catalog_number    default=${EMPTY}
    ${has_signature}=    Run Keyword And Return Status    Should Not Be Empty    ${signature}
    IF    not ${has_signature}
        ${signature}=    Get From Dictionary    ${first}    signature    default=${EMPTY}
    END
    Should Not Be Empty    ${signature}    msg=Order ${order_id} has no product signature.

    ${qty_raw}=          Get From Dictionary    ${first}    quantity
    ${price_raw}=        Get From Dictionary    ${first}    price
    ${qty}=              Evaluate    int(float(str($qty_raw).replace(',', '.')))
    ${price}=            Evaluate    round(float(str($price_raw).replace(',', '.')), 2)

    ${handoff}=    Create Dictionary
    Set To Dictionary    ${handoff}
    ...    order_id=${order_id}
    ...    document_type=${document_type}
    ...    payment_type=${payment_type}
    ...    signature=${signature}
    ...    quantity=${qty}
    ...    price=${price}
    ...    nip=${nip}
    ...    customer_login=${login}
    ...    source_order=${order_data}
    RETURN    ${handoff}

Sellasist Resolve Document Type For Autostacja
    [Arguments]    ${order_data}
    ${type}=    Sellasist Resolve Document Type    ${order_data}
    RETURN    ${type}
