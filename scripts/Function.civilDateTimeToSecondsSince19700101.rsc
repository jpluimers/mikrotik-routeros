/system script environment remove [find where name="civilDateTimeToSecondsSince19700101"];
:global civilDateTimeToSecondsSince19700101 do={

  /system script environment get dateTimeToYYYYMMDDhhmmssString
  :global dateTimeToYYYYMMDDhhmmssString

  /system script environment get civilDateToDaysSince19700101
  :global civilDateToDaysSince19700101

  /system script environment get timeToSecondsSinceMidnight
  :global timeToSecondsSinceMidnight

#  /system script environment get varDump
#  :global varDump;

#:put "value=";
#$varDump value=$value;

  :local dateTimeString [$dateTimeToYYYYMMDDhhmmssString value=$value];
## now we have a valid date formatted like this:
##   20161023010203
##   012345678901234 index mod 10 for data
##   01234           YYYY
##       456             MM
##         678             DD
##           890            hh
##             012            mm
##               234            ss
  :local dateString [:pick $dateTimeString 0 8];
  :local timeString [:pick $dateTimeString 8 14];
#:put "dateTimeString=";
#$varDump value=$dateTimeString;
#:put "dateString=";
#$varDump value=$dateString;
#:put "dateString=";
#$varDump value=$dateString;

  :local daysSince19700101 [$civilDateToDaysSince19700101 value=$dateString];
  :local secondsSinceMidnight [$timeToSecondsSinceMidnight value=$timeString];

  :local result ($secondsSinceMidnight + 86400 * $daysSince19700101);

#:put "result=";
#$varDump value=$result;
  :return $result;
};

## Examples:
## /import scripts/Function.civilDateTimeToSecondsSince19700101.rsc
## :put [$civilDateTimeToSecondsSince19700101 value=([/system clock get date])]
## :put [$civilDateTimeToSecondsSince19700101 value="foo"]
## :put [$civilDateTimeToSecondsSince19700101 value="20161013"]
## 17087
## :put [$civilDateTimeToSecondsSince19700101 value="oct/13/2016"]
## 17087
## :put [$civilDateTimeToSecondsSince19700101 value="oct/13"]
## 17087
## :put [$civilDateTimeToSecondsSince19700101 value="20160103"]
## 16803
## :put [$civilDateTimeToSecondsSince19700101 value="jan/03/2016"]
## 16803
## :put [$civilDateTimeToSecondsSince19700101 value="jan/03"]
## 16803
## :put [$civilDateTimeToSecondsSince19700101 value="20161014"]
## 17088
## :put [$civilDateTimeToSecondsSince19700101 value="oct/14/2016"]
## 17088
## :put [$civilDateTimeToSecondsSince19700101 value="oct/14"]
## 17088
