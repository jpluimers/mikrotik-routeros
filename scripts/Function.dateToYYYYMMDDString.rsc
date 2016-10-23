/system script environment remove [find where name="dateToYYYYMMDDString"];
:global dateToYYYYMMDDString do={
## returns a string YYYYMMDD representation of the Date string in $value
## $value can either be either in ISO-8601 (yyyymmdd) long (mmm/dd/yyyy) or short (mmm/dd) Mikrotik format. If short, then the current year is used in yyyy.
## if $value has an invalid date, then [/system clock get date] is used

## maybe TODO: ensure the various parts are valid:
## - month is valid
## - day of the month is valid (0..27 extended by max days in month)

#  /system script environment get varDump
#  :global varDump;

#:put "value=";
#$varDump value=$value;

## unlike POSIX, character classes like [:digit:] are not supported in regular expressions http://forum.mikrotik.com/viewtopic.php?f=9&t=113422
## unlike POSIX regex, you have to escape the $ here "because Mikrotik scripting language"
#  :local dateOnlyMask "^[a-zA-Z]{3}/[:digit:]{2}/[0-9]{4}\$";
  :local iso8601DateOnlyMask "^[0-9]{4}[0-9]{2}[0-9]{2}\$";
  :local dateOnlyMask "^[a-zA-Z]{3}/[0-9]{2}/[0-9]{4}\$";
  :local shortDateOnlyMask "^[a-zA-Z]{3}/[0-9]{2}\$";

  :local varDay;
  :local varMonth;
  :local varYear;

  :if ($value~$iso8601DateOnlyMask) do={
#    :put "iso8601DateOnly";
## now we have a valid date formatted like this:
##   20161013
##   012345678 index mod 10 for data
    :return $value;
## for future range checking:
##    :set $varYear [:pick $value 0 4];
##    :set $varMonth [:pick $value 4 6];
##    :set $varDay [:pick $value 6 8];
#:put "varYear=";
#$varDump value=$varYear;
#:put "varMonth=";
#$varDump value=$varMonth;
#:put "varDay=";
#$varDump value=$varDay;
  } else={
    :local date
    :if ($value~$dateOnlyMask) do={
#      :put "dateOnly";
      :set $date ($value);
    } else={
      :if ($value~$shortDateOnlyMask) do={
#          :put "shortDateOnly";
##       /log print where buffer=failedauth
##       oct/14 00:19:51 system,error,critical login failure for user root from 201.217.248.217 via telnet
##       012 45 78 01 34   index mod 10 for data
##          3  6  9  2  5  index mod 10 for separators
        :local currentDate [/system clock get date]
        :local currentYear [:pick $currentDate 7 11]
        :local shortDatePart [:pick $value 0 6]
        :set $date ($shortDatePart."/$currentYear");
      } else={
#        :put "not any of iso8601DateOnly, dateOnly, shortDateOnly"
        :set $date ([/system clock get date]);
      };
    };
#:put "date=";
#$varDump value=$date;
##   now we have a valid date formatted like this:
##   oct/13/2016
##   012 45 78901 index mod 10 for data
##      3  6      index mod 10 for separators
    :local months [:toarray "jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec"]
    :local varMonthString [:pick $date 0 3];
    :local varMonthPosition [:find $months $varMonthString -1];
    :set $varMonth ($varMonthPosition + 1);
#:put "months=";
#$varDump value=$months;
#:put "varMonthString=";
#$varDump value=$varMonthString;
#:put "varMonthPosition=";
#$varDump value=$varMonthPosition;
#:put "varMonth=";
#$varDump value=$varMonth;
    :if ($varMonth < 10) do={
      :set varMonth ("0" . $varMonth);
#:put "varMonth=";
#$varDump value=$varMonth;
    }
    :set $varDay [:pick $date 4 6];
    :set $varYear [:pick $date 7 11];
#:put "varDay=";
#$varDump value=$varDay;
#:put "varYear=";
#$varDump value=$varYear;
  };

  :local result ($varYear.$varMonth.$varDay);

#:put "result=";
#$varDump value=$result;
  :return $result;
};

## Examples:
## /import scripts/Function.dateToYYYYMMDDString.rsc
## :put [$dateToYYYYMMDDString value=([/system clock get date])]
## :put [$dateToYYYYMMDDString value="oct/13/2016"]
## 20161013
## :put [$dateToYYYYMMDDString value="oct/13"]
## 20161013
## :put [$dateToYYYYMMDDString value="foo"]
## :put [$dateToYYYYMMDDString value="jan/03"]
## 20160103
## :put [$dateToYYYYMMDDString value="jan/03/2016"]
## 20160103
## :put [$dateToYYYYMMDDString value="oct/14"]
## 20161014
## :put [$dateToYYYYMMDDString value="oct/14/2016"]
## 20161014
