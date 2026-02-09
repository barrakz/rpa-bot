*** Settings ***
Library    SeleniumLibrary
Resource   ../../config/variables.robot

*** Keywords ***
Open SellAsist Login Page
    Go To    ${SELLASIST_URL}
    Location Should Contain    ggautolublin.sellasist.pl
    Wait Until Page Contains Element    ${SELLASIST_LOGIN_INPUT}    10s
    Wait Until Page Contains Element    ${SELLASIST_PASSWORD_INPUT}    10s

Login To SellAsist
    [Arguments]    ${user}=${SELLASIST_TEST_USER}    ${password}=${SELLASIST_TEST_PASS}
    Wait Until Page Contains Element    ${SELLASIST_LOGIN_INPUT}    10s
    Wait Until Page Contains Element    ${SELLASIST_PASSWORD_INPUT}    10s
    Input Text    ${SELLASIST_LOGIN_INPUT}    ${user}
    Input Text    ${SELLASIST_PASSWORD_INPUT}    ${password}
    Element Attribute Value Should Be    ${SELLASIST_LOGIN_INPUT}    value    ${user}
    Wait Until Page Contains Element    ${SELLASIST_LOGIN_BUTTON}    10s
