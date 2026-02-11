*** Settings ***
Resource   ../keywords/postman_training.robot

*** Test Cases ***
Open Postman And Filter Collection
    [Documentation]    Open Postman, type LOCAL VECTOR in search, and click PROD UPDATE SLUG request.
    Postman Open
    Postman Filter Collection
    Postman Prepare Click Prod Update Slug
