*** Settings ***
Resource     ../config/variables.robot
Resource     ../src/keywords/common.robot

Suite Setup    Ensure Artifacts Dirs Exist
Test Setup     Log To Console    [SMOKE] Start test
Test Teardown  Log To Console    [SMOKE] End test

*** Test Cases ***
Smoke Test
    Log To Console    [SMOKE] Writing marker file
    Write Smoke Marker
    Log To Console    [SMOKE] Done
