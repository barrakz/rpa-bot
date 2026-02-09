*** Settings ***
Library      SeleniumLibrary
Resource     ../config/variables.robot
Resource     ../src/keywords/common.robot
Resource     ../src/keywords/sellasist.robot

Suite Setup     Open Browser To Blank
Suite Teardown  Close All Browsers
Test Setup      Log To Console    [SELLASIST] Start test
Test Teardown   Log To Console    [SELLASIST] End test

*** Test Cases ***
Open SellAsist Login Page (Test Login)
    Log To Console    [SELLASIST] Navigating to login page
    Open SellAsist Login Page
    Login To SellAsist
    Log To Console    [SELLASIST] Test credentials filled (no submit)
