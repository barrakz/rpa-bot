*** Settings ***
Library    OperatingSystem
Library    Process
Library    String
Resource   ../config/postman_locators_macos.robot

*** Keywords ***
Postman Training Init
    ${trace}=    Set Variable    ${OUTPUT DIR}${/}postman_training_trace.txt
    Set Suite Variable    ${POSTMAN_TRAINING_TRACE}    ${trace}
    Create File    ${trace}    [POSTMAN-TRAINING] Trace start\n
Postman Trace
    [Arguments]    ${msg}
    ${line}=    Replace String    ${msg}    \n    \\n
    Append To File    ${POSTMAN_TRAINING_TRACE}    ${line}\n
    Log To Console    [POSTMAN] ${msg}

Ensure macOS Platform
    ${platform}=    Evaluate    str(sys.platform).lower()    modules=sys
    ${is_mac}=      Run Keyword And Return Status    Should Match Regexp    ${platform}    ^darwin
    IF    not ${is_mac}
        Fail    Postman training path supports macOS only (platform=${platform})
    END

Open Postman From Dock
    Ensure macOS Platform
    ${dry}=    Get Environment Variable    POSTMAN_SIM_DRY_RUN    default=0
    ${dry}=    Convert To Lowercase    ${dry}
    Postman Trace    open_postman_from_dock strategy=${POSTMAN_OPEN_STRATEGY}
    IF    '${dry}'=='1' or '${dry}'=='true'
        Postman Trace    dry_run_skip_open
        RETURN
    END

    ${dock_title}=    Set Variable    ${POSTMAN_DOCK_ITEM_TITLE}
    ${script}=    Catenate    SEPARATOR=
    ...    tell application "System Events" to tell process "Dock" to click UI element "${dock_title}" of list 1
    Postman Trace    click_dock_item title=${dock_title} type=${POSTMAN_DOCK_AUTOMATION_TYPE}
    ${res}=    Run Process    osascript    -e    ${script}
    Postman Trace    open_postman_from_dock_rc rc=${res.rc}
    Postman Trace    open_postman_from_dock_stdout ${res.stdout}
    Postman Trace    open_postman_from_dock_stderr ${res.stderr}

    Should Be Equal As Integers    ${res.rc}    0
    ${open_wait}=    Set Variable    ${POSTMAN_OPEN_WAIT_SECONDS}
    Postman Trace    wait_postman_ui_ready seconds=${open_wait}
    Sleep    ${open_wait}s

Type Postman Collections Search Filter
    [Arguments]    ${filter_text}    ${search_label}    ${attempts}
    ${script}=    Catenate    SEPARATOR=\n
    ...    on run argv
    ...        set filterText to item 1 of argv
    ...        set searchLabel to item 2 of argv
    ...        set maxAttempts to (item 3 of argv) as integer
    ...        tell application "System Events"
    ...            tell process "Postman"
    ...                set frontmost to true
    ...                delay 0.35
    ...                repeat with i from 1 to maxAttempts
    ...                    set focusedSearch to false
    ...                    try
    ...                        set elemsSearch to entire contents of window 1
    ...                        repeat with s in elemsSearch
    ...                            try
    ...                                set sName to ""
    ...                                set sLabel to ""
    ...                                set sSubrole to ""
    ...                                try
    ...                                    set sName to name of s
    ...                                end try
    ...                                try
    ...                                    set sLabel to description of s
    ...                                end try
    ...                                try
    ...                                    set sSubrole to subrole of s
    ...                                end try
    ...                                set hasSearchText to false
    ...                                if sName is not missing value and sName is not "" and (sName contains searchLabel or sName contains "search" or sName contains "Search") then
    ...                                    set hasSearchText to true
    ...                                end if
    ...                                if sLabel is not missing value and sLabel is not "" and (sLabel contains searchLabel or sLabel contains "search" or sLabel contains "Search") then
    ...                                    set hasSearchText to true
    ...                                end if
    ...                                if sSubrole is "AXSearchField" and hasSearchText then
    ...                                    try
    ...                                        click s
    ...                                    on error
    ...                                        perform action "AXPress" of s
    ...                                    end try
    ...                                    delay 0.1
    ...                                    keystroke "a" using command down
    ...                                    key code 51
    ...                                    keystroke filterText
    ...                                    delay 0.25
    ...                                    return "typed_search_filter:" & filterText
    ...                                end if
    ...                            end try
    ...                        end repeat
    ...                    end try
    ...                    delay 0.2
    ...                end repeat
    ...            end tell
    ...        end tell
    ...        error "collection search input failed: " & filterText
    ...    end run
    Postman Trace    type_collection_search_filter value=${filter_text} label=${search_label} attempts=${attempts}
    ${res}=    Run Process    osascript    -e    ${script}    ${filter_text}    ${search_label}    ${attempts}
    Postman Trace    type_collection_search_filter_rc rc=${res.rc}
    Postman Trace    type_collection_search_filter_stdout ${res.stdout}
    Postman Trace    type_collection_search_filter_stderr ${res.stderr}
    Should Be Equal As Integers    ${res.rc}    0

Prepare Click Postman Request In Sidebar
    [Arguments]    ${request_title}    ${attempts}    ${text_role}    ${link_role}
    ${script}=    Catenate    SEPARATOR=\n
    ...    on run argv
    ...        set requestTitle to item 1 of argv
    ...        set maxAttempts to (item 2 of argv) as integer
    ...        set requestTextRole to item 3 of argv
    ...        set requestLinkRole to item 4 of argv
    ...        tell application "System Events"
    ...            tell process "Postman"
    ...                set frontmost to true
    ...                delay 0.25
    ...                repeat with i from 1 to maxAttempts
    ...                    try
    ...                        set elems to entire contents of window 1
    ...                        repeat with e in elems
    ...                            try
    ...                                set eName to ""
    ...                                set eValue to ""
    ...                                set eDesc to ""
    ...                                set eRole to ""
    ...                                set eSubrole to ""
    ...                                try
    ...                                    set eName to name of e
    ...                                end try
    ...                                try
    ...                                    set eValue to value of e
    ...                                end try
    ...                                try
    ...                                    set eDesc to description of e
    ...                                end try
    ...                                try
    ...                                    set eRole to role of e
    ...                                end try
    ...                                try
    ...                                    set eSubrole to subrole of e
    ...                                end try
    ...                                set isSearchField to false
    ...                                if eSubrole is "AXSearchField" then
    ...                                    set isSearchField to true
    ...                                end if
    ...                                if eRole is "AXTextField" and ((eName contains "search") or (eName contains "Search")) then
    ...                                    set isSearchField to true
    ...                                end if
    ...                                if not isSearchField then
    ...                                    if eRole is requestLinkRole and eName is not missing value and eName is not "" and eName contains requestTitle then
    ...                                        try
    ...                                            click e
    ...                                        on error
    ...                                            perform action "AXPress" of e
    ...                                        end try
    ...                                        return "clicked_request_link_name:" & requestTitle
    ...                                    end if
    ...                                    if eRole is requestLinkRole and eValue is not missing value and eValue is not "" and eValue contains requestTitle then
    ...                                        try
    ...                                            click e
    ...                                        on error
    ...                                            perform action "AXPress" of e
    ...                                        end try
    ...                                        return "clicked_request_link_value:" & requestTitle
    ...                                    end if
    ...                                    if eRole is requestLinkRole and eDesc is not missing value and eDesc is not "" and eDesc contains requestTitle then
    ...                                        try
    ...                                            click e
    ...                                        on error
    ...                                            perform action "AXPress" of e
    ...                                        end try
    ...                                        return "clicked_request_link_desc:" & requestTitle
    ...                                    end if
    ...                                    if eRole is requestTextRole and eValue is not missing value and eValue is not "" and eValue is requestTitle then
    ...                                        try
    ...                                            set p to parent of e
    ...                                            try
    ...                                                click p
    ...                                            on error
    ...                                                perform action "AXPress" of p
    ...                                            end try
    ...                                            return "clicked_request_text_parent:" & requestTitle
    ...                                        on error
    ...                                            try
    ...                                                click e
    ...                                            on error
    ...                                                perform action "AXPress" of e
    ...                                            end try
    ...                                            return "clicked_request_text_direct:" & requestTitle
    ...                                        end try
    ...                                    end if
    ...                                end if
    ...                            end try
    ...                        end repeat
    ...                    end try
    ...                    delay 0.2
    ...                end repeat
    ...            end tell
    ...        end tell
    ...        error "request click prep failed: " & requestTitle
    ...    end run
    Postman Trace    prepare_click_postman_request target=${request_title} attempts=${attempts}
    ${res}=    Run Process    osascript    -e    ${script}    ${request_title}    ${attempts}    ${text_role}    ${link_role}
    Postman Trace    prepare_click_postman_request_rc rc=${res.rc}
    Postman Trace    prepare_click_postman_request_stdout ${res.stdout}
    Postman Trace    prepare_click_postman_request_stderr ${res.stderr}
    Should Be Equal As Integers    ${res.rc}    0

Postman Open
    Postman Training Init
    Open Postman From Dock

Postman Filter Collection
    ${filter}=    Set Variable    ${POSTMAN_COLLECTION_FILTER_TEXT}
    ${search_label}=    Set Variable    ${POSTMAN_COLLECTION_SEARCH_LABEL}
    ${attempts}=    Set Variable    ${POSTMAN_COLLECTION_SEARCH_ATTEMPTS}
    ${dry}=    Get Environment Variable    POSTMAN_SIM_DRY_RUN    default=0
    ${dry}=    Convert To Lowercase    ${dry}
    Postman Trace    postman_filter_collection value=${filter} label=${search_label} attempts=${attempts}
    IF    '${dry}'=='1' or '${dry}'=='true'
        Postman Trace    dry_run_skip_filter_collection
        RETURN
    END
    Type Postman Collections Search Filter    ${filter}    ${search_label}    ${attempts}

Postman Prepare Click Prod Update Slug
    [Documentation]    Prepared for next phase; enable in process after inspector-based tuning.
    ${target}=    Set Variable    ${POSTMAN_REQUEST_TARGET_TITLE}
    ${attempts}=    Set Variable    ${POSTMAN_REQUEST_CLICK_ATTEMPTS}
    ${text_role}=    Set Variable    ${POSTMAN_REQUEST_TEXT_ROLE}
    ${link_role}=    Set Variable    ${POSTMAN_REQUEST_LINK_ROLE}
    ${dry}=    Get Environment Variable    POSTMAN_SIM_DRY_RUN    default=0
    ${dry}=    Convert To Lowercase    ${dry}
    Postman Trace    postman_prepare_click_prod_update_slug target=${target} attempts=${attempts} text_role=${text_role} link_role=${link_role}
    IF    '${dry}'=='1' or '${dry}'=='true'
        Postman Trace    dry_run_skip_click_prod_update_slug
        RETURN
    END
    Prepare Click Postman Request In Sidebar    ${target}    ${attempts}    ${text_role}    ${link_role}
