*** Settings ***
Resource    ../src/keywords/desktop_stub.robot

Test Setup     Log To Console    [DESKTOP] Start test
Test Teardown  Log To Console    [DESKTOP] End test

*** Test Cases ***
Open Desktop Notepad Folder
    ${platform}=    Evaluate    sys.platform    modules=sys
    ${is_mac}=      Run Keyword And Return Status    Should Match Regexp    ${platform}    ^darwin
    Run Keyword If    not ${is_mac}    Skip    Desktop stub only on macOS
    Open Desktop Notepad Folder
