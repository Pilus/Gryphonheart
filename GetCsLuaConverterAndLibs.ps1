
$csLuaRepo = ".\..\CsLuaConverter\CsLuaProjects"

robocopy "$csLuaRepo\BlizzardApi" ".\BlizzardApi" "*.*" /S /XD bin obj
robocopy "$csLuaRepo\CsLuaConverter" ".\CsLuaConverter" "*.*" /S /XD bin obj
robocopy "$csLuaRepo\TestUtils" ".\TestUtils" "*.*" /S /XD bin obj
robocopy "$csLuaRepo\WoWSimulator" ".\WoWSimulator" "*.*" /S /XD bin obj


