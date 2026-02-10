*** Settings ***
Library    OperatingSystem
Resource   ./autostacja_sim.robot
Resource   ./autostacja_windows.robot

*** Keywords ***
Resolve Desktop Mode
    ${mode}=    Get Environment Variable    DESKTOP_MODE    default=auto
    ${mode}=    Convert To Lowercase    ${mode}
    IF    '${mode}'!='auto'
        RETURN    ${mode}
    END

    ${platform}=    Evaluate    str(sys.platform).lower()    modules=sys
    ${is_win}=      Run Keyword And Return Status    Should Match Regexp    ${platform}    ^win
    ${default}=     Set Variable If    ${is_win}    real    sim
    RETURN    ${default}

Autostacja Init
    ${existing}=    Get Variable Value    ${AUTOSTACJA_MODE}    __unset__
    IF    '${existing}'!='__unset__'
        RETURN
    END

    ${mode}=    Resolve Desktop Mode
    Set Suite Variable    ${AUTOSTACJA_MODE}    ${mode}
    Run Keyword If    '${mode}'=='sim'    Autostacja Sim Init
    Log To Console    [AUTOSTACJA] Desktop mode: ${mode}

Autostacja Open
    Autostacja Init
    ${mode}=    Resolve Desktop Mode
    IF    '${mode}'=='sim'
        Autostacja Sim Open
    ELSE
        Autostacja Windows Open
    END

Autostacja Login
    [Arguments]    ${user}    ${password}
    Autostacja Init
    ${mode}=    Resolve Desktop Mode
    IF    '${mode}'=='sim'
        Autostacja Sim Login    ${user}    ${password}
    ELSE
        Autostacja Windows Login    ${user}    ${password}
    END

Autostacja Close Buffer If Present
    Autostacja Init
    ${mode}=    Resolve Desktop Mode
    IF    '${mode}'=='sim'
        Autostacja Sim Close Buffer If Present
    ELSE
        Autostacja Windows Close Buffer If Present
    END

Autostacja Search Product And Read Stock D
    [Arguments]    ${signature}    ${qty}
    Autostacja Init
    ${mode}=    Resolve Desktop Mode
    IF    '${mode}'=='sim'
        ${val}=    Autostacja Sim Search Product And Read Stock D    ${signature}    ${qty}
    ELSE
        ${val}=    Autostacja Windows Search Product And Read Stock D    ${signature}    ${qty}
    END
    RETURN    ${val}

Autostacja Create Receipt Draft
    [Arguments]    ${nick}    ${signature}    ${qty}    ${price}    ${payment_type}
    Autostacja Init
    ${mode}=    Resolve Desktop Mode
    IF    '${mode}'=='sim'
        Autostacja Sim Create Receipt Draft    ${nick}    ${signature}    ${qty}    ${price}    ${payment_type}
    ELSE
        Autostacja Windows Create Receipt Draft    ${nick}    ${signature}    ${qty}    ${price}    ${payment_type}
    END

Autostacja Approve Document
    Autostacja Init
    ${mode}=    Resolve Desktop Mode
    IF    '${mode}'=='sim'
        ${doc}=    Autostacja Sim Approve Document
    ELSE
        ${doc}=    Autostacja Windows Approve Document
    END
    RETURN    ${doc}

Autostacja Create Invoice Draft
    [Arguments]    ${nip}    ${nick}    ${signature}    ${qty}    ${price}    ${payment_type}
    Autostacja Init
    ${mode}=    Resolve Desktop Mode
    IF    '${mode}'=='sim'
        Autostacja Sim Create Invoice Draft    ${nip}    ${nick}    ${signature}    ${qty}    ${price}    ${payment_type}
    ELSE
        Autostacja Windows Create Invoice Draft    ${nip}    ${nick}    ${signature}    ${qty}    ${price}    ${payment_type}
    END

Autostacja Print Invoice To PDF
    [Arguments]    ${pdf_path}
    Autostacja Init
    ${mode}=    Resolve Desktop Mode
    IF    '${mode}'=='sim'
        Autostacja Sim Print Invoice To PDF    ${pdf_path}
    ELSE
        Autostacja Windows Print Invoice To PDF    ${pdf_path}
    END
