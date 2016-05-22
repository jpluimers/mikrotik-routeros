:global padRightString do={
  ## returns $value padded right with $padChar (space when Right out) up to a $padLength length
  ## if $padLength is not defined or less than [:len $value], then returns $value

# :global varDump

# :put "value="
# $varDump value=$value
# :put "padChar="
# $varDump value=$padChar
# :put "padLength="
# $varDump value=$padLength

  :local result "$value"
  :local valueLength [:len $value]
  :local paddingCount 0
  :if ([:typeof $padLength] = "num") do={
    :if ($padLength > $valueLength) do={
      :set $paddingCount ($padLength - $valueLength)
    }
  };
  :local padding " "
  :if ([:typeof $padChar] = "str") do={
    :if ([:len $padChar] = 1) do={
      :set $padding $padChar
    }
  };

# :put "result="
# $varDump value=$result
# :put "valueLength="
# $varDump value=$valueLength
# :put "paddingCount="
# $varDump value=$paddingCount
# :put "padding="
# $varDump value=$padding

  :if ($paddingCount  > 0) do={
    :for i from=1 to=$paddingCount do={
# :put "$i"
      :set result ($result.$padding)
    }
  }
  :return $result;
}

## Examples: (note the parenthsis around the numbers!)
## /import scripts/Function.padRightString.rsc
## :put [$padRightString value="12345"]
## 12345
## :put [$padRightString value="12345" padLength=(7)]
## 12345
## :put [$padRightString value="12345" padLength=(7) padChar="."]
## 12345..
