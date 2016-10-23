/system script environment remove [ find where name="startsWithString" ];
:global startsWithString do={
  ## returns true if $value starts with $subString

#global varDump

#:put "value="
#$varDump value=$value
#:put "subString="
#$varDump value=$subString

  :local result false
#:put "result="
#$varDump value=$result

  :if ([:typeof $value] = "str") do={
    :if ([:typeof $subString] = "str") do={
      :local valueLength [:len $value]
      :local subStringLength [:len $subString]
      :if ($valueLength > $subStringLength) do={
## strings start at position zero (0)!
## 01234
## ABCDE -> length 5
## AB -> length 2; positions 0..1

        :local valueStart (0)
        # bug that won't be fixed: :pick end parameter is 1-based, not 0-based http://forum.mikrotik.com/viewtopic.php?t=108311
        # :local valueEnd ($subStringLength - 1)
        :local valueEnd ($subStringLength - 0)
        :local valuePick [:pick $value $valueStart $valueEnd]
#:put "valueStart="
#$varDump value=$valueStart
#:put "valueEnd="
#$varDump value=$valueEnd
#:put "valuePick="
#$varDump value=$valuePick
        :set $result ($subString = $valuePick)
      }
    }
  };

#:put "result="
#$varDump value=$result
  :return $result;
}

## Examples:
## /import scripts/Function.startsWithString.rsc
## :put [$startsWithString value="ABCDE"]
## false
## :put [$startsWithString value="ABCDE" subString=(7)]
## false
## :put [$startsWithString value="ABCDE" subString="DE"]
## false
## :put [$startsWithString value="ABCDE" subString="AB"]
## true
