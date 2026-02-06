*** Settings ***
Library      SeleniumLibrary
Resource     ../config/variables.robot
Resource     ../src/keywords/common.robot
Resource     ../src/keywords/sellasist.robot

Suite Setup     Open Browser To Blank
Suite Teardown  Close All Browsers

*** Test Cases ***
Open SellAsist Login Page (Test Login)
    Open SellAsist Login Page
    Login To SellAsist
