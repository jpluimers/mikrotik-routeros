## can be executed as one-liner
## see http://forum.mikrotik.com/viewtopic.php?f=9&t=108405#p538221 (Is there a good way to sync a local directory from the scripts that a Mikrotik has? - MikroTik RouterOS)

## Match anything
:foreach scriptId in [/system script find] do={ :local scriptSource [/system script get $scriptId source]; :local scriptSourceLength [:len $scriptSource];  :local scriptName [/system script get $scriptId name]; :put "$scriptSourceLength bytes: '$scriptName'" }

## Example:
## /import scripts/list.systemScript.lengthName.rsc
