/system script environment remove [find where name="timeToHHMMSSString"];
:global timeToHHMMSSString do={
## returns a string hhmmss representation of the Time string in $value
## $value can either be either in ISO-8601 (hhmmss) Mikrotik (hh:mm:ss) format.
## if $value has an invalid time, then [/system clock get time] is used

## maybe TODO: ensure the various parts are valid:
## - hour in range 0..23
## - minute in range 0..59
## - second in range 0..59

#  /system script environment get varDump
#  :global varDump;

#:put "value=";
#$varDump value=$value;

  :local varHour;
  :local varMinute;
  :local varSecond;

## unlike POSIX, character classes like [:digit:] are not supported in regular expressions http://forum.mikrotik.com/viewtopic.php?f=9&t=113422
## unlike POSIX regex, you have to escape the $ here "because Mikrotik scripting language"
# :local timeOnlyMask "^[0-9]{2}:[:digit:]{2}:[0-9]{2}\$";
  :local timeOnlyMask "^[0-9]{2}:[0-9]{2}:[0-9]{2}\$";
  :local iso8601TimeOnlyMask "^[0-9]{2}[0-9]{2}[0-9]{2}\$";

  :if ($value~$iso8601TimeOnlyMask) do={
#    :put "iso8601TimeOnly";
## hhmmss
## 0123456 index mod 10 for data
##         index mod 10 for separators
    :return $value;
## for future range checking:
##    :set $varHour [:pick $value 0 2];
##    :set $varMinute [:pick $value 2 4];
##    :set $varSecond [:pick $value 4 6];
  } else={
    :local time;
    :if ($value~$timeOnlyMask) do={
#      :put "timeOnly";
      :set $time ($value);
    } else={
#        :put "not any of iso8601TimeOnly, timeOnly"
      :set $time ([/system clock get time]);
    };
#:put "time=";
#$varDump value=$time;
## hh:mm:ss
## 01 34 678 index mod 10 for data
##   2  5    index mod 10 for separators
    :set $varHour [:pick $time 0 2];
    :set $varMinute [:pick $time 3 5];
    :set $varSecond [:pick $time 6 8];
  };
#:put "varHour=";
#$varDump value=$varHour;
#:put "varMinute=";
#$varDump value=$varMinute;
#:put "varSecond=";
#$varDump value=$varSecond;

  :local result ($varHour.$varMinute.$varSecond);

#:put "result=";
#$varDump value=$result;
  :return $result;
};

## Examples:
## /import scripts/Function.timeToHHMMSSString.rsc
## :put [$timeToHHMMSSString value=([/system clock get time])]
## :put [$timeToHHMMSSString value="17:37:09"]
## 173709
## :put [$timeToHHMMSSString value="07:06:09"]
## 070609
## :put [$timeToHHMMSSString value="00:19:51"]
## 001951
## :put [$timeToHHMMSSString value="09:48:25"]
## 094825
## :put [$timeToHHMMSSString value="173709"]
## 173709
## :put [$timeToHHMMSSString value="070609"]
## 070609
## :put [$timeToHHMMSSString value="001951"]
## 001951
## :put [$timeToHHMMSSString value="094825"]
## 094825
