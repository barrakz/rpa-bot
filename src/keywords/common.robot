*** Settings ***
Library    OperatingSystem
Library    DateTime
Library    SeleniumLibrary

*** Keywords ***
Ensure Artifacts Dirs Exist
    Create Directory    ${LOGS_DIR}
    Create Directory    ${SCREENSHOTS_DIR}

Write Smoke Marker
    ${timestamp}=    Get Time    result_format=%Y-%m-%d %H:%M:%S
    ${path}=    Set Variable    ${LOGS_DIR}/smoke_ok.txt
    Create File    ${path}    Smoke OK - ${timestamp}

Open Browser To Blank
    [Arguments]    ${browser}=${BROWSER}
    Ensure Artifacts Dirs Exist
    Open Browser    about:blank    ${browser}
    Set Selenium Speed    0.2
