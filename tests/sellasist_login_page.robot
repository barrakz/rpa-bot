*** Settings ***
Library      SeleniumLibrary
Resource     ../config/variables.robot
Resource     ../src/keywords/common.robot

Suite Setup     Open Browser To Blank
Suite Teardown  Close All Browsers
Test Setup      Log To Console    [SELLASIST] Start test
Test Teardown   Log To Console    [SELLASIST] End test

*** Test Cases ***
Open SellAsist Login Page (No Credentials)
    Log To Console    [SELLASIST] Navigating to login page
    Go To    ${SELLASIST_URL}
    Location Should Contain    ggautolublin.sellasist.pl
    Wait Until Page Contains Element    css:input[type="password"]    10s
    Log To Console    [SELLASIST] Login page loaded (no credentials entered)
