/system script environment remove [ find where name="endsWithString" ];
:global endsWithString do={
  ## returns true if $value ends with $subString

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
## DE -> length 2; positions 3..4

        :local valueStart ($valueLength - $subStringLength)
        ## bug that won't be fixed: :pick end parameter is 1-based, not 0-based http://forum.mikrotik.com/viewtopic.php?t=108311
        ## :local valueEnd ($valueLength - 1)
        :local valueEnd ($valueLength - 0)
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
## /import scripts/Function.endsWithString.rsc
## :put [$endsWithString value="ABCDE"]
## false
## :put [$endsWithString value="ABCDE" subString=(7)]
## false
## :put [$endsWithString value="ABCDE" subString="DE"]
## true
## :put [$endsWithString value="ABCDE" subString="AB"]
## false
