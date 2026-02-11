*** Settings ***
Library    OperatingSystem
Resource   ../keywords/postman_training.robot

Test Setup     Set Environment Variable    POSTMAN_SIM_DRY_RUN    1
Test Teardown  Remove Environment Variable    POSTMAN_SIM_DRY_RUN

*** Test Cases ***
Postman Training Steps (Dry Run)
    Postman Open
    Postman Filter Collection
    Postman Prepare Click Prod Update Slug

    ${trace}=    Set Variable    ${OUTPUT DIR}${/}postman_training_trace.txt
    File Should Exist    ${trace}
    ${content}=    Get File    ${trace}
    Should Contain    ${content}    open_postman_from_dock
    Should Contain    ${content}    postman_filter_collection
    Should Contain    ${content}    dry_run_skip_click_prod_update_slug
