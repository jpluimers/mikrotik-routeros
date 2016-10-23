/system script environment remove [find where name="dateTimeToYYYYMMDDhhmmssNumber"];
:global dateTimeToYYYYMMDDhhmmssNumber do={
## returns a numeric YYYYMMDDhhmmss representation of the DateTime string in $value
## if $value only contains a time portion, then [/system clock get date] is used as date portion
## if $value only contains a date portion, then [/system clock get time] is used as time portion
## if $value has an invalid date or time portion, then [/system clock get date].[/system clock get time] is used
## the date portion can be either in long (mmm/dd/yyyy) or short (mmm/dd) Mikrotik format. If short, then the current year is used in yyyy.

  /system script environment get dateTimeToYYYYMMDDhhmmssString
  :global dateTimeToYYYYMMDDhhmmssString;
#  /system script environment get varDump
#  :global varDump;

#:put "value=";
#$varDump value=$value;

  :local dateTimeString [$dateTimeToYYYYMMDDhhmmssString value=$value];

  :local result [:tonum $dateTimeString];

#:put "result=";
#$varDump value=$result;
  :return $result;
};

## Examples:
## /import scripts/Function.dateTimeToYYYYMMDDhhmmssNumber.rsc
## :put [$dateTimeToYYYYMMDDhhmmssNumber value=([/system clock get date] . [/system clock get time])]
## :put [$dateTimeToYYYYMMDDhhmmssNumber value=([/system clock get time])]
## :put [$dateTimeToYYYYMMDDhhmmssNumber value=([/system clock get date])]
## :put [$dateTimeToYYYYMMDDhhmmssNumber value="oct/13/201617:37:09"]
## 20161013173709
## :put [$dateTimeToYYYYMMDDhhmmssNumber value="17:37:09"]
## :put [$dateTimeToYYYYMMDDhhmmssNumber value="oct/13/2016"]
## :put [$dateTimeToYYYYMMDDhhmmssNumber value="oct/13"]
## :put [$dateTimeToYYYYMMDDhhmmssNumber value="foo"]
## :put [$dateTimeToYYYYMMDDhhmmssNumber value="jan/03"]
## :put [$dateTimeToYYYYMMDDhhmmssNumber value="jan/03/2016"]
## :put [$dateTimeToYYYYMMDDhhmmssNumber value="jan/03/201607:06:09"]
## 20160103070609
## :put [$dateTimeToYYYYMMDDhhmmssNumber value="07:06:09"]
## :put [$dateTimeToYYYYMMDDhhmmssNumber value="jan/03/2016"]
## :put [$dateTimeToYYYYMMDDhhmmssNumber value="oct/14 00:19:51"]
## 20161014001951
## :put [$dateTimeToYYYYMMDDhhmmssNumber value="oct/14/2016 09:48:25"]
## 20161014094825
