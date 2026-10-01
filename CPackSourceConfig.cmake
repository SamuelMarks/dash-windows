# CPack Source configuration for DASH Shell Windows
set(CPACK_SOURCE_GENERATOR "ZIP;TGZ")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "DASH-0.5.13.5-src")
set(CPACK_SOURCE_IGNORE_FILES
    "/\.git/"
    "/build.*/"
    "/\.vscode/"
    "/\.idea/"
    "/__pycache__/"
    "/\.DS_Store"
)
