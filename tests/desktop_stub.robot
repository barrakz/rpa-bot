*** Settings ***
Resource    ../src/keywords/desktop_stub.robot

Test Setup     Log To Console    [DESKTOP] Start test
Test Teardown  Log To Console    [DESKTOP] End test

*** Test Cases ***
Open Desktop Notepad Folder
    ${platform}=    Evaluate    str(sys.platform).lower()    modules=sys
    ${is_mac}=      Run Keyword And Return Status    Should Match Regexp    ${platform}    ^darwin
    ${is_win}=      Run Keyword And Return Status    Should Match Regexp    ${platform}    ^win
    Run Keyword If    not ${is_mac} and not ${is_win}    Skip    Desktop stub only on macOS/Windows
    Open Desktop Notepad Folder
