## initialise as empty array as the MikroTik RouterOS scripting language has a bug initialising
## assosiative arrays when they contain hex escapes like `:global convert {"\00"="\\00"}`
## see http://forum.mikrotik.com/viewtopic.php?f=9&t=108107&sid=74f5fd6f4b0e376b1eb6338ccb2f5ec2
:global convert ({})

## now add all the characters that need to be escaped:
#:set ($convert->"\00") "\\00"
:set ($convert->"\7F") "\\7F"
:set ($convert->"\81") "\\81"
:local hexChars "01234567890ABCDEF"
:local groupChars "01890ABCDEF"
:for groupCharsIndex from=0 to=([:len $groupChars] - 1) do={
  :local groupChar [:pick $groupChars $groupCharsIndex]
  :for hexCharsIndex from=0 to=([:len $hexChars] - 1) do={
    :local hexChar [:pick $hexChars $hexCharsIndex]
    ## the `:put` statements will output the formatted code for initialisation in `Function.escapeString.rsc`:
    :put ":set (\$convert->(\"\\$groupChar$hexChar\")) (\"\\\\$groupChar$hexChar\")"
  }
}

## for debugging/research purposes:
:put [/system script environment print]
:put [:typeof $convert]
:put "$convert"
:put ($convert->"\00")
:put ($convert->"\81")
:put ($convert->"f")
:put [:typeof ($convert->"\00")]
:put [:typeof ($convert->"\81")]
:put [:typeof ($convert->"f")]
