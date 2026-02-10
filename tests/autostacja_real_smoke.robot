*** Settings ***
Library    OperatingSystem
Resource   ../src/keywords/autostacja.robot

Test Setup     Set Environment Variable    DESKTOP_MODE    real
Test Teardown  Remove Environment Variable    DESKTOP_MODE

*** Test Cases ***
Autostacja Desktop Steps (Real Mode Smoke)
    # On non-Windows machines (or without AutoStacja installed), "real" mode
    # is expected to fail. This test is here to show what would happen and
    # keep the failure message visible in logs.
    ${err}=    Run Keyword And Expect Error    *    Autostacja Open
    Log To Console    [AUTOSTACJA:REAL] Expected failure: ${err}
    Should Contain    ${err}    AUTOSTACJA_EXE

