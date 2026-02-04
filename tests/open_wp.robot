*** Settings ***
Library      SeleniumLibrary
Resource     ../config/variables.robot
Resource     ../src/keywords/common.robot

Suite Setup     Open Browser To Blank
Suite Teardown  Close All Browsers
Test Setup      Log To Console    [WEB] Start test
Test Teardown   Log To Console    [WEB] End test

*** Test Cases ***
Open WP
    Log To Console    [WEB] Navigating to ${BASE_URL}
    Go To    ${BASE_URL}
    Title Should Be    Wirtualna Polska - Wszystko co ważne - www.wp.pl
