*** Variables ***
# Postman training path on macOS.

${POSTMAN_OPEN_STRATEGY}                dock_click

# Dock locator for opening app via System Events.
${POSTMAN_DOCK_ITEM_TITLE}              Postman
${POSTMAN_DOCK_AUTOMATION_TYPE}         DockItem
${POSTMAN_OPEN_WAIT_SECONDS}            2

# Sidebar search settings.
${POSTMAN_COLLECTION_FILTER_TEXT}       LOCAL VECTOR
${POSTMAN_COLLECTION_SEARCH_LABEL}      search
${POSTMAN_COLLECTION_SEARCH_ATTEMPTS}   10

# Prepared for next phase: request click in collection list.
${POSTMAN_REQUEST_TARGET_TITLE}         PROD UPDATE SLUG
${POSTMAN_REQUEST_CLICK_ATTEMPTS}       10
${POSTMAN_REQUEST_TEXT_ROLE}            AXStaticText
${POSTMAN_REQUEST_LINK_ROLE}            AXLink
