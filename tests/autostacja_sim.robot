*** Settings ***
Library    OperatingSystem
Resource   ../src/keywords/autostacja.robot

Test Setup     Set Environment Variable    DESKTOP_MODE    sim
Test Teardown  Remove Environment Variable    DESKTOP_MODE

*** Test Cases ***
Autostacja Desktop Steps (Sim Mode)
    Autostacja Open
    Autostacja Login    demo_user    demo_pass
    Autostacja Close Buffer If Present

    ${stock_d}=    Autostacja Search Product And Read Stock D    5Q0123456    1
    Should Be True    ${stock_d} > 0

    Autostacja Create Receipt Draft    nick123    5Q0123456    1    10.00    PayU
    ${doc_no}=    Autostacja Approve Document
    Should Start With    ${doc_no}    SIM-

    ${pdf}=    Set Variable    ${OUTPUT DIR}${/}invoice_sim.pdf
    Autostacja Create Invoice Draft    1234567890    nick123    5Q0123456    1    10.00    Pobranie
    Autostacja Print Invoice To PDF    ${pdf}
    File Should Exist    ${pdf}
    ${size}=    Get File Size    ${pdf}
    Should Be True    ${size} > 100

    ${trace}=    Set Variable    ${OUTPUT DIR}${/}autostacja_sim_trace.txt
    File Should Exist    ${trace}
    ${content}=    Get File    ${trace}
    Should Contain    ${content}    open_app
    Should Contain    ${content}    close_buffer_if_present
    Should Contain    ${content}    approve_document
