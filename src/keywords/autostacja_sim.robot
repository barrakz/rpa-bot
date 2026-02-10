*** Settings ***
Library    OperatingSystem
Library    Process
Library    String

*** Keywords ***
Autostacja Sim Init
    ${outdir}=    Set Variable    ${OUTPUT DIR}
    ${trace}=     Set Variable    ${outdir}${/}autostacja_sim_trace.txt
    Set Suite Variable    ${AUTOSTACJA_SIM_TRACE}    ${trace}
    Create File    ${trace}    [SIM] Autostacja trace start\n

Autostacja Sim Trace
    [Arguments]    ${msg}
    ${line}=    Replace String    ${msg}    \n    \\n
    Append To File    ${AUTOSTACJA_SIM_TRACE}    ${line}\n
    Log To Console    [AUTOSTACJA:SIM] ${msg}

Autostacja Sim Open
    Autostacja Sim Trace    open_app

Autostacja Sim Login
    [Arguments]    ${user}    ${password}
    Autostacja Sim Trace    login user=${user} pass=***

Autostacja Sim Close Buffer If Present
    Autostacja Sim Trace    close_buffer_if_present

Autostacja Sim Search Product And Read Stock D
    [Arguments]    ${signature}    ${qty}
    Autostacja Sim Trace    search_product signature=${signature} qty=${qty}
    # Deterministic fake result for tests; can be overridden later.
    ${stock_d}=    Set Variable    999
    Autostacja Sim Trace    read_stock_d value=${stock_d}
    RETURN    ${stock_d}

Autostacja Sim Create Receipt Draft
    [Arguments]    ${nick}    ${signature}    ${qty}    ${price}    ${payment_type}
    Autostacja Sim Trace    create_receipt_draft nick=${nick} signature=${signature} qty=${qty} price=${price} payment=${payment_type}

Autostacja Sim Approve Document
    Autostacja Sim Trace    approve_document
    ${doc_no}=    Set Variable    SIM-PAR-000001
    Autostacja Sim Trace    document_number ${doc_no}
    RETURN    ${doc_no}

Autostacja Sim Create Invoice Draft
    [Arguments]    ${nip}    ${nick}    ${signature}    ${qty}    ${price}    ${payment_type}
    Autostacja Sim Trace    create_invoice_draft nip=${nip} nick=${nick} signature=${signature} qty=${qty} price=${price} payment=${payment_type}

Autostacja Sim Print Invoice To PDF
    [Arguments]    ${pdf_path}
    Autostacja Sim Trace    print_to_pdf path=${pdf_path}
    ${py}=        Evaluate    sys.executable    modules=sys
    ${script}=    Normalize Path    ${CURDIR}${/}..${/}..${/}scripts${/}write_dummy_pdf.py
    # Avoid '=' in args: Robot may treat it as a named argument.
    Run Process    ${py}    ${script}    ${pdf_path}    SIMULATED INVOICE (DESKTOP_MODE sim)
