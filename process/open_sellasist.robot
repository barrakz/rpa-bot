*** Settings ***
Library      SeleniumLibrary
Resource     ../config/variables.robot
Resource     ../src/keywords/common.robot
Resource     ../src/keywords/sellasist.robot
Resource     ../src/keywords/desktop_stub.robot

Suite Setup     Open Browser To Blank
Suite Teardown  Close All Browsers

*** Test Cases ***
Open SellAsist Login Page (Test Login)
    Open SellAsist Login Page
    Login To SellAsist
    ${platform}=    Evaluate    sys.platform    modules=sys
    ${is_mac}=      Run Keyword And Return Status    Should Match Regexp    ${platform}    ^darwin
    Run Keyword If  ${is_mac}    Open Desktop Notepad Folder
    Run Keyword If  not ${is_mac}    Log To Console    [DESKTOP] Skip NOTEPAD open (non-macOS)
