# Scripts and Snippets

## Electronics (scripts\\electronics\\)
| Filename | Function Names | Script Type | Description |
|---|---|---|---|
| main.py | - | Python | Script selector |
| LM317_Rfb_E24.py | - | Python | Calculate E24 feedback resistor values combinations for LM317 |
| LM317_Rfb_E48.py | - | Python | Calculate E48 feedback resistor values combinations for LM317 |
| Vdivider_E24_with_Ilimit.py | - | Python | Calculate E24 resistor values combinations for voltage divider with current limit |
| Vdivider_E24.py | - | Python | Calculate E24 resistor values combinations for voltage divider |
| Vdivider_E48_with_Ilimit.py | - | Python | Calculate E48 resistor values combinations for voltage divider with current limit |
| Vdivider_E48.py | - | Python | Calculate E48 resistor values combinations for voltage divider |

## File Operation (scripts\\file_op\\)
| Filename | Function Names | Script Type | Description |
|---|---|---|---|
| filecopy_different_size_only.psm1 | Copy-ItemsChangedSizeOnly | PowerShell | Copy files excluding files with same file size (completes the only option Robocopy is missing, "/XT" to exclude files with changed time attributes with same size) |
| filecopy_with_timestamps.psm1 | Copy-ItemsWithTimeStamps | PowerShell | Copy files with time attributes. (Robocopy can perform similar operation except prompting) |
| filename_trim_leading_trailing_spaces.psm1 | Rename-FileNames | PowerShell | Trim leading and trailing spaces in filename of specified file or all files under a directory. |

## Python Snippets (snippets\\python\\)
| Filename | Description |
|---|---|
| module_try_import.py | Try to import module, exit script and provide user with installation information if module not installed |

## PowerShell Snippets (snippets\\powershell\\)
| Filename | Description |
|---|---|
| clipboard_display_each_changes.ps1 | Print every changes in clipboard |
| clipboard_wait_for_change.ps1 | Wait for a change in clipboard |
| config_Read-Config.ps1<br>config.ini | Read configuration from provided \$ConfigFile and \$ConfigName |
| file_rw_remove_matching_lines.ps1 | Remove lines with matching search string |
| function_test_argument | Test if argument is passed to function |
| press_any_key_to_continue.ps11 | Wait for any key to continue |
| press_specific_keys_to_continue.ps1 | Wait for specific keys to continue |
| prompt_user_input.ps1 | Prompt user for answer |
