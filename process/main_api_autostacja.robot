*** Settings ***
Library      Collections
Library      OperatingSystem
Library      String
Resource     ../src/keywords/sellasist_api.robot
Resource     ../src/keywords/sellasist_api_orders.robot

*** Test Cases ***
Main Bot Flow (Sellasist API -> Handoff For Autostacja)
    [Documentation]    Main process stage: fetch queue + order details from Sellasist API and prepare handoff for AutoStacja.
    Sellasist API Init

    ${statuses}=    Sellasist API Get Statuses
    ${status_no_lu}=    Sellasist API Find Status Id By Name    ${statuses}    NO-LU_AutohausOtto
    ${status_send}=     Sellasist API Find Status Id By Name    ${statuses}    Do WYSŁANIA Lublin

    ${limit_raw}=    Get Environment Variable    SELLASIST_QUEUE_LIMIT    default=50
    ${limit}=        Convert To Integer    ${limit_raw}
    ${queue}=        Sellasist API Get Orders Queue    ${status_no_lu}    ${limit}    0
    ${selected}=     Sellasist API Select Order From Queue    ${queue}
    ${selected_id}=  Get From Dictionary    ${selected}    id

    ${order}=        Sellasist API Get Order Details    ${selected_id}
    ${handoff}=      Sellasist Build Autostacja Handoff    ${order}

    Set To Dictionary    ${handoff}    status_no_lu_id=${status_no_lu}
    Set To Dictionary    ${handoff}    status_send_id=${status_send}

    ${handoff_json}=    Evaluate    json.dumps($handoff, ensure_ascii=False, indent=2)    modules=json
    ${handoff_path}=    Set Variable    ${OUTPUT DIR}${/}handoff_autostacja_order_${selected_id}.json
    Create File    ${handoff_path}    ${handoff_json}

    Log To Console    [FLOW] Prepared order ${selected_id} from status ${status_no_lu}.
    Log To Console    [FLOW] Handoff saved: ${handoff_path}

    ${autostacja_exe}=    Get Environment Variable    AUTOSTACJA_EXE    default=
    ${autostacja_exe}=    Strip String    ${autostacja_exe}
    Run Keyword If    '${autostacja_exe}'==''
    ...    Pass Execution
    ...    [FLOW] API stage complete. AutoStacja not available locally (AUTOSTACJA_EXE missing). Stopped before desktop actions.

    Pass Execution    [FLOW] API stage complete. Handoff ready for upcoming AutoStacja desktop stage.
