*** Variables ***
${BASE_URL}              https://www.wp.pl
${BROWSER}               auto
${RPA_ENV}               auto
${SELLASIST_URL}         https://ggautolublin.sellasist.pl/admin/login?redirect=%2Fadmin
${SELLASIST_LOGIN_INPUT}  css:input[type="text"],input[type="email"]
${SELLASIST_PASSWORD_INPUT}  css:input[type="password"]
${SELLASIST_LOGIN_BUTTON}  css:button[type="submit"],input[type="submit"]
${SELLASIST_TEST_USER}    test@test.pl
${SELLASIST_TEST_PASS}    testtest
${SELLASIST_API_DOCS_URL}     https://api.sellasist.pl
${SELLASIST_API_URL_TEMPLATE}  https://{account}.sellasist.pl/api/v1
${SELLASIST_API_ACCOUNT}      ggautolublin
${SELLASIST_API_KEY}         

${DEFAULT_BROWSER_MAC}   safari
${DEFAULT_BROWSER_WIN}   chrome
${DEFAULT_BROWSER_OTHER}  chrome

${ARTIFACTS_DIR}         ${CURDIR}/../artifacts
${LOGS_DIR}              ${ARTIFACTS_DIR}/logs
${SCREENSHOTS_DIR}       ${ARTIFACTS_DIR}/screenshots
