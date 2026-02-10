*** Settings ***
Library    OperatingSystem
Resource   ../../config/autostacja_locators.robot

*** Keywords ***
Autostacja Windows Init
    # Import at runtime so macOS dev can run tests without Windows-only deps.
    Import Library    RPA.Windows

Autostacja Windows Open
    ${exe}=    Get Environment Variable    AUTOSTACJA_EXE    default=
    Run Keyword If    '${exe}'==''    Fail    AUTOSTACJA_EXE is required for DESKTOP_MODE=real

    Autostacja Windows Init
    # Placeholder: real implementation will launch and wait for main window.
    Log To Console    [AUTOSTACJA:WIN] Open executable: ${exe}
    Fail    Not implemented yet (need AutoStacja + selectors)

Autostacja Windows Login
    [Arguments]    ${user}    ${password}
    Autostacja Windows Init
    Log To Console    [AUTOSTACJA:WIN] Login user=${user} pass=***
    Fail    Not implemented yet (need AutoStacja + selectors)

Autostacja Windows Close Buffer If Present
    Autostacja Windows Init
    Log To Console    [AUTOSTACJA:WIN] Close buffer if present
    Fail    Not implemented yet (need AutoStacja + selectors)

Autostacja Windows Search Product And Read Stock D
    [Arguments]    ${signature}    ${qty}
    Autostacja Windows Init
    Log To Console    [AUTOSTACJA:WIN] Search product signature=${signature} qty=${qty}
    Fail    Not implemented yet (need AutoStacja + selectors)

Autostacja Windows Create Receipt Draft
    [Arguments]    ${nick}    ${signature}    ${qty}    ${price}    ${payment_type}
    Autostacja Windows Init
    Log To Console    [AUTOSTACJA:WIN] Create receipt draft
    Fail    Not implemented yet (need AutoStacja + selectors)

Autostacja Windows Approve Document
    Autostacja Windows Init
    Log To Console    [AUTOSTACJA:WIN] Approve document
    Fail    Not implemented yet (need AutoStacja + selectors)

Autostacja Windows Create Invoice Draft
    [Arguments]    ${nip}    ${nick}    ${signature}    ${qty}    ${price}    ${payment_type}
    Autostacja Windows Init
    Log To Console    [AUTOSTACJA:WIN] Create invoice draft
    Fail    Not implemented yet (need AutoStacja + selectors)

Autostacja Windows Print Invoice To PDF
    [Arguments]    ${pdf_path}
    Autostacja Windows Init
    Log To Console    [AUTOSTACJA:WIN] Print invoice to PDF: ${pdf_path}
    Fail    Not implemented yet (need AutoStacja + selectors)

