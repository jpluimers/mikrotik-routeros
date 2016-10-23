/system script environment remove [find where name="timeToSecondsSinceMidnight"];
:global timeToSecondsSinceMidnight do={

## $value can either be either in ISO-8601 (hhmmss) Mikrotik (hh:mm:ss) format.
## if $value has an invalid time, then [/system clock get time] is used

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
    :set $varHour [:pick $value 0 2];
    :set $varMinute [:pick $value 2 4];
    :set $varSecond [:pick $value 4 6];
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

  :local h [:tonum $varHour];
#:put "h=";
#$varDump value=$h;
  :local m [:tonum $varMinute];
#:put "m=";
#$varDump value=$m;
  :local s [:tonum $varSecond];
#:put "s=";
#$varDump value=$s;
  :local result (($h * 60 * 60) + ($m * 60) + $s);

#:put "result=";
#$varDump value=$result;
  :return $result;
};

## Examples:
## /import scripts/Function.timeToSecondsSinceMidnight.rsc
## :put [$timeToSecondsSinceMidnight value=([/system clock get time])]
## :put [$timeToSecondsSinceMidnight value="17:37:09"]
## 63429
## :put [$timeToSecondsSinceMidnight value="07:06:09"]
## 25569
## :put [$timeToSecondsSinceMidnight value="09:48:25"]
## 35305
## :put [$timeToSecondsSinceMidnight value="24:00:00"]
## 86400
## :put [$timeToSecondsSinceMidnight value="foo"]
## :put [$timeToSecondsSinceMidnight value="173709"]
## 63429
## :put [$timeToSecondsSinceMidnight value="070609"]
## 25569
## :put [$timeToSecondsSinceMidnight value="094825"]
## 35305
## :put [$timeToSecondsSinceMidnight value="240000"]
## 86400
