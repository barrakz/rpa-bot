*** Settings ***
Library    OperatingSystem
Library    DateTime
Library    SeleniumLibrary
Library    String

*** Keywords ***
Ensure Artifacts Dirs Exist
    Create Directory    ${LOGS_DIR}
    Create Directory    ${SCREENSHOTS_DIR}

Resolve Browser
    [Arguments]    ${requested}=${EMPTY}
    ${env_browser}=    Get Environment Variable    BROWSER    default=
    ${env_rpa}=        Get Environment Variable    RPA_ENV    default=
    ${requested}=      Convert To Lowercase    ${requested}
    ${env_browser}=    Convert To Lowercase    ${env_browser}
    ${env_rpa}=        Convert To Lowercase    ${env_rpa}

    ${browser}=        Set Variable If    '${requested}'!=''    ${requested}    ${EMPTY}
    ${browser}=        Set Variable If    '${browser}'=='' and '${env_browser}'!=''    ${env_browser}    ${browser}
    ${browser}=        Set Variable If    '${browser}'==''    ${BROWSER}    ${browser}
    ${browser}=        Convert To Lowercase    ${browser}
    ${browser}=        Set Variable If    '${browser}'!='' and '${browser}'!='auto'    ${browser}    ${EMPTY}
    Run Keyword If     '${browser}'!=''    RETURN    ${browser}

    ${platform}=       Evaluate    sys.platform    modules=sys
    ${platform}=       Convert To Lowercase    ${platform}
    ${is_env_win}=     Run Keyword And Return Status    Should Match Regexp    ${env_rpa}    ^(win|windows)$
    ${is_env_mac}=     Run Keyword And Return Status    Should Match Regexp    ${env_rpa}    ^(mac|darwin|osx)$
    ${is_win}=         Run Keyword And Return Status    Should Match Regexp    ${platform}    ^win
    ${is_mac}=         Run Keyword And Return Status    Should Match Regexp    ${platform}    ^darwin

    ${browser}=        Set Variable If    ${is_env_win}    ${DEFAULT_BROWSER_WIN}    ${EMPTY}
    ${browser}=        Set Variable If    '${browser}'=='' and ${is_env_mac}    ${DEFAULT_BROWSER_MAC}    ${browser}
    ${browser}=        Set Variable If    '${browser}'=='' and ${is_win}    ${DEFAULT_BROWSER_WIN}    ${browser}
    ${browser}=        Set Variable If    '${browser}'=='' and ${is_mac}    ${DEFAULT_BROWSER_MAC}    ${browser}
    ${browser}=        Set Variable If    '${browser}'==''    ${DEFAULT_BROWSER_OTHER}    ${browser}
    RETURN    ${browser}

Write Smoke Marker
    ${timestamp}=    Get Time    result_format=%Y-%m-%d %H:%M:%S
    ${path}=    Set Variable    ${LOGS_DIR}/smoke_ok.txt
    Create File    ${path}    Smoke OK - ${timestamp}

Open Browser To Blank
    [Arguments]    ${browser}=${BROWSER}
    Ensure Artifacts Dirs Exist
    ${resolved}=    Resolve Browser    ${browser}
    Log To Console    [RPA] Browser resolved: ${resolved}
    Open Browser    about:blank    ${resolved}
    Set Selenium Speed    0.2
