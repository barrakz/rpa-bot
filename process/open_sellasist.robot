*** Settings ***
Library      SeleniumLibrary
Resource     ../config/variables.robot
Resource     ../src/keywords/common.robot

Suite Setup     Open Browser To Blank
Suite Teardown  Close All Browsers

*** Test Cases ***
Open SellAsist Login Page
    Go To    ${SELLASIST_URL}
    Location Should Contain    ggautolublin.sellasist.pl
    Wait Until Page Contains Element    css:input[type="password"]    10s
