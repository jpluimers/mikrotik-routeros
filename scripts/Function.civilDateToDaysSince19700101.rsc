/system script environment remove [find where name="civilDateToDaysSince19700101"];
:global civilDateToDaysSince19700101 do={
## based on
## - http://stackoverflow.com/questions/7960318/math-to-convert-seconds-since-1970-into-date-and-vice-versa
## - http://howardhinnant.github.io/date_algorithms.html#days_from_civil

## $value can either be either in ISO-8601 (yyyymmdd) long (mmm/dd/yyyy) or short (mmm/dd) Mikrotik format. If short, then the current year is used in yyyy.
## if $value has an invalid date, then [/system clock get date] is used

## Does not take into account leap seconds: only leap days

## Returns number of days since civil 1970-01-01.  Negative values indicate
##    days prior to 1970-01-01.
## Preconditions:  y-m-d represents a date in the civil (Gregorian) calendar
##                 m is in [1, 12]
##                 d is in [1, last_day_of_month(y, m)]
##                 y is "approximately" in
##                   [numeric_limits<Int>::min()/366, numeric_limits<Int>::max()/366]
##                 Exact range of validity is:
##                 [civil_from_days(numeric_limits<Int>::min()),
##                  civil_from_days(numeric_limits<Int>::max()-719468)]

## template <class Int>
## constexpr
## Int
## days_from_civil(Int y, unsigned m, unsigned d) noexcept
## {
##     static_assert(std::numeric_limits<unsigned>::digits >= 18,
##              "This algorithm has not been ported to a 16 bit unsigned integer");
##     static_assert(std::numeric_limits<Int>::digits >= 20,
##              "This algorithm has not been ported to a 16 bit signed integer");
##     y -= m <= 2;
##     const Int era = (y >= 0 ? y : y-399) / 400;
##     const unsigned yoe = static_cast<unsigned>(y - era * 400);      // [0, 399]
##     const unsigned doy = (153*(m + (m > 2 ? -3 : 9)) + 2)/5 + d-1;  // [0, 365]
##     const unsigned doe = yoe * 365 + yoe/4 - yoe/100 + doy;         // [0, 146096]
##     return era * 146097 + static_cast<Int>(doe) - 719468;
## }

## split it into the various numeric parts, based on:
## - http://wiki.mikrotik.com/wiki/Script_to_find_the_day_of_the_week
## - http://forum.mikrotik.com/viewtopic.php?t=110778#p550429

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
    :set $varYear [:pick $value 0 4];
    :set $varMonth [:pick $value 4 6];
    :set $varDay [:pick $value 6 8];
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

  :local d [:tonum $varDay];
  :local m [:tonum $varMonth];
  :local y [:tonum $varYear];
#:put "d=";
#$varDump value=$d;
#:put "m=";
#$varDump value=$m;
#:put "y=";
#$varDump value=$y;

  :if ($m <= 2) do={
    :set y ($y -1);
  }
#:put "y=";
#$varDump value=$y;

  :local era $y;
  if (y < 0) do={
    :set era ($y-399);
  }
#:put "era=";
#$varDump value=$era;
  :set era ($era / 400);
#:put "era=";
#$varDump value=$era;

  :local yoe ($y - $era * 400);
  ## [0, 399]
#:put "y=";
#$varDump value=$y;

  :local moy $m;
  :if ($m > 2) do={
    :set moy ($moy-3);
  } else={
    :set moy ($moy+9);
  }
#:put "moy=";
#$varDump value=$moy;

  :local doy ((153*$moy + 2)/5 + $d-1);
  ## [0, 365]
#:put "doy=";
#$varDump value=$doy;

  :local doe ($yoe * 365 + $yoe/4 - $yoe/100 + $doy);
  ## [0, 146096]
#:put "doe=";
#$varDump value=$doe;

  :local result ($era * 146097 + $doe - 719468);

#:put "result=";
#$varDump value=$result;
  :return $result;
};

## Examples:
## /import scripts/Function.civilDateToDaysSince19700101.rsc
## :put [$civilDateToDaysSince19700101 value=([/system clock get date])]
## :put [$civilDateToDaysSince19700101 value="foo"]
## :put [$civilDateToDaysSince19700101 value="20161013"]
## 17087
## :put [$civilDateToDaysSince19700101 value="oct/13/2016"]
## 17087
## :put [$civilDateToDaysSince19700101 value="oct/13"]
## 17087
## :put [$civilDateToDaysSince19700101 value="20160103"]
## 16803
## :put [$civilDateToDaysSince19700101 value="jan/03/2016"]
## 16803
## :put [$civilDateToDaysSince19700101 value="jan/03"]
## 16803
## :put [$civilDateToDaysSince19700101 value="20161014"]
## 17088
## :put [$civilDateToDaysSince19700101 value="oct/14/2016"]
## 17088
## :put [$civilDateToDaysSince19700101 value="oct/14"]
## 17088
