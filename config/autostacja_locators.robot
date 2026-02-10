*** Variables ***
# Placeholder locators / window titles for AutoStacja (Windows).
#
# When you have AutoStacja installed, you'll replace these with real selectors
# discovered via Inspect.exe / UIA viewer. Keep them centralized so keyword
# implementations don't hardcode selectors.
#
# Notes:
# - RPA.Windows uses UI Automation (UIA). Locators vary by control.
# - Start with stable attributes: Name/AutomationId/ClassName where possible.

${AUTOSTACJA_MAIN_WINDOW}        name:AutoStacja
${AUTOSTACJA_LOGIN_WINDOW}       name:Logowanie
${AUTOSTACJA_BUFFER_WINDOW}      name:Bufor

# Examples (placeholders):
${AUTOSTACJA_USERNAME_INPUT}     name:Uzytkownik
${AUTOSTACJA_PASSWORD_INPUT}     name:Haslo
${AUTOSTACJA_LOGIN_BUTTON}       name:Zaloguj

${AUTOSTACJA_MENU_DOKUMENTY}     name:Dokumenty
${AUTOSTACJA_MENU_SPRZEDAZY}     name:Sprzedazy
${AUTOSTACJA_NEW_DOC_BUTTON}     name:Nowy dokument

