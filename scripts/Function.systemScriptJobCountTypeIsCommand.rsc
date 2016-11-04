:local scriptName "Function.systemScriptJobCountTypeIsCommand.rsc"
/system script environment remove [ find where name="systemScriptJobCountTypeIsCommand" ];
## First try at https://gist.github.com/jpluimers/f667af4696d2a6411be44df1eeda2c2f
:global systemScriptJobCountTypeIsCommand do={
  :local result [:len [/system script job find where type=command]];
#  :put "result=$result"
  :return $result;
}

## Example:
## /import scripts/Function.systemScriptJobCountTypeIsCommand.rsc
## :put [$systemScriptJobCountTypeIsCommand];
