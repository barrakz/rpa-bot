*** Settings ***
Library      Collections
Library      OperatingSystem
Resource     ../src/keywords/autostacja.robot
Resource     ../src/keywords/sellasist_api.robot
Resource     ../src/keywords/sellasist_api_orders.robot

Test Setup     Set Environment Variable    DESKTOP_MODE    sim
Test Teardown  Remove Environment Variable    DESKTOP_MODE

*** Test Cases ***
Hybrid Flow Skeleton (API -> Autostacja -> API)
    [Documentation]    Demonstration-only orchestration. Builds API request templates but does not execute HTTP calls.
    Sellasist API Init

    ${statuses_req}=    Sellasist API Build Get Statuses Request
    ${sources_req}=     Sellasist API Build Get Sources Request
    ${queue_req}=       Sellasist API Build Get Orders Queue Request    status_id=38    limit=20
    Log To Console      [FLOW] API templates ready: statuses/sources/orders

    # Mock order payload representing what /orders/{id} would return.
    ${payment}=      Create Dictionary    paid=120.00
    ${order}=        Create Dictionary    id=10001    invoice=1    status=1    document_number=    paid=120.00    payment=${payment}
    ${bill_address}=    Create Dictionary    nip=1234567890
    ${line}=            Create Dictionary    catalog_number=5Q0123456    quantity=1    price=10.00
    ${carts}=           Create List    ${line}
    Set To Dictionary    ${order}    bill_address=${bill_address}
    Set To Dictionary    ${order}    carts=${carts}

    ${document_type}=    Sellasist Resolve Document Type    ${order}
    ${payment_type}=     Sellasist Resolve Payment Type For Autostacja    ${order}
    ${carts}=            Get From Dictionary    ${order}    carts
    ${first}=            Get From List    ${carts}    0
    ${signature}=        Get From Dictionary    ${first}    catalog_number
    ${qty}=              Get From Dictionary    ${first}    quantity
    ${price}=            Get From Dictionary    ${first}    price

    Autostacja Open
    Autostacja Login    demo_user    demo_pass
    Autostacja Close Buffer If Present
    ${stock_d}=    Autostacja Search Product And Read Stock D    ${signature}    ${qty}
    Should Be True    ${stock_d} > 0

    IF    '${document_type}'=='invoice'
        ${bill}=    Get From Dictionary    ${order}    bill_address
        ${nip}=     Get From Dictionary    ${bill}    nip
        Autostacja Create Invoice Draft    ${nip}    nick123    ${signature}    ${qty}    ${price}    ${payment_type}
        ${pdf}=    Set Variable    ${OUTPUT DIR}${/}invoice_hybrid_sim.pdf
        Autostacja Print Invoice To PDF    ${pdf}
        File Should Exist    ${pdf}
    ELSE
        Autostacja Create Receipt Draft    nick123    ${signature}    ${qty}    ${price}    ${payment_type}
    END

    ${doc_no}=          Autostacja Approve Document
    ${order_id}=        Get From Dictionary    ${order}    id
    ${doc_update_req}=  Sellasist API Build Update Order Document Number Request    ${order_id}    ${doc_no}    ${order}
    ${status_update_req}=    Sellasist API Build Update Order Status Request    ${order_id}    2    ${order}
    ${note_req}=        Sellasist API Build Add Order Note Request    ${order_id}    Robot finished local skeleton flow.

    ${doc_req_url}=       Get From Dictionary    ${doc_update_req}    url
    ${status_req_url}=    Get From Dictionary    ${status_update_req}    url
    ${note_req_url}=      Get From Dictionary    ${note_req}    url
    Should Contain    ${doc_req_url}    /orders/
    Should Contain    ${status_req_url}    /orders/
    Should Contain    ${note_req_url}    /notes

    Log To Console    [FLOW] Built request templates only (no HTTP):
    Log To Console    [FLOW] ${doc_req_url}
    Log To Console    [FLOW] ${status_req_url}
    Log To Console    [FLOW] ${note_req_url}
