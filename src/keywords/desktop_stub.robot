*** Settings ***
Library    OperatingSystem
Library    Process

*** Keywords ***
Open Desktop Notepad Folder
    ${platform}=    Evaluate    str(sys.platform).lower()    modules=sys
    ${is_mac}=      Run Keyword And Return Status    Should Match Regexp    ${platform}    ^darwin
    ${is_win}=      Run Keyword And Return Status    Should Match Regexp    ${platform}    ^win

    Run Keyword If    ${is_mac}    Open Desktop Notepad Folder (macOS)
    Run Keyword If    ${is_win}    Open Desktop Notepad Folder (Windows)
    Run Keyword If    not ${is_mac} and not ${is_win}    Log To Console    [DESKTOP] Skip NOTEPAD open (unsupported platform: ${platform})

Open Desktop Notepad Folder (macOS)
    ${home}=    Get Environment Variable    HOME
    ${path}=    Join Path    ${home}    Desktop    NOTEPAD
    Create Directory    ${path}
    Run Process    open    ${path}

Open Desktop Notepad Folder (Windows)
    ${userprofile}=    Get Environment Variable    USERPROFILE
    ${desktop}=        Join Path    ${userprofile}    Desktop
    ${onedrive_desktop}=    Join Path    ${userprofile}    OneDrive    Desktop
    ${desktop_exists}=      Run Keyword And Return Status    Directory Should Exist    ${desktop}
    ${onedrive_exists}=     Run Keyword And Return Status    Directory Should Exist    ${onedrive_desktop}
    ${base}=    Set Variable If    ${onedrive_exists}    ${onedrive_desktop}    ${desktop}
    ${path}=    Join Path    ${base}    NOTEPAD
    Create Directory    ${path}
    Run Process    explorer.exe    ${path}
