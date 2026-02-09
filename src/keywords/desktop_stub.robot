*** Settings ***
Library    OperatingSystem
Library    Process

*** Keywords ***
Open Desktop Notepad Folder
    ${home}=    Get Environment Variable    HOME
    ${path}=    Join Path    ${home}    Desktop    NOTEPAD
    Directory Should Exist    ${path}
    Run Process    open    ${path}
