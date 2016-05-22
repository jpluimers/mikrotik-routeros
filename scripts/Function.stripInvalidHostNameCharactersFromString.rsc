:global stripInvalidHostNameCharactersFromString do={
  ## returns $value without invalid characters for a Hostname
  ## if $allowMultipleLabels is not nothing, then it also allows dots between labels
#  :put "$value"
#  :put "$allowMultipleLabels"
  ## https://en.wikipedia.org/wiki/Hostname#Restrictions_on_valid_host_names
  ## valid: a..z A..Z 0..9 -
  ## for convenience, replace space and underscore with hyphen.
  ## string loop based on URL encoding in http://forum.mikrotik.com/viewtopic.php?t=84705
  :local result "";
  ## set empty associative array: http://forum.mikrotik.com/viewtopic.php?p=418796&sid=52e10f322b216132a5fd8179bbbcf08a#p418796
  :local convert ({})
  :if ([:typeof $allowMultipleLabels] != "nothing") do={
    # allow multiple labels in a host name
    :set ($convert->(".")) (".")
  };
  :local validChars "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890-"
  :for validCharsIndex from=0 to=([:len $validChars] - 1) do={
    :local validChar [:pick $validChars $validCharsIndex]
    :set ($convert->($validChar)) ($validChar)
  }
  ## for convenience, translate space and underscore to hyphen
  :set ($convert->("_")) ("-")
  :set ($convert->(" ")) ("-")
#  :put "$convert"

  :for i from=0 to=([:len $value] - 1) do={
    :local char [:pick $value $i]
    :local converted ($convert->"$char")
    :local convertedType [:typeof $converted]
#    :put "$char $converted $convertedType"
    :if ($convertedType = "str") do={
      :set $char $converted
    } else={
      :set $char ""
    }
    :set result ($result.$char)
  }
  :return $result;
}

## Example:
## /import scripts/Function.stripInvalidHostNameCharactersFromString.rsc
## :put [$stripInvalidHostNameCharactersFromString value=("a#host#name")]
## ahostname
## :put [$stripInvalidHostNameCharactersFromString value=("a@host/name.domain name" ) allowMultipleLabels="yes"]
## ahostname.domainname
