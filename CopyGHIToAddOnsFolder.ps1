
$addonFolder = ".\..\AddOns"

robocopy ".\GHI" "$addonFolder\GHI" "*.*" /S /XD bin obj
robocopy ".\GHM" "$addonFolder\GHM" "*.*" /S /XD bin obj



