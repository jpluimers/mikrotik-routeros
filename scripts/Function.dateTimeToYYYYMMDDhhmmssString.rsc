/system script environment remove [find where name="dateTimeToYYYYMMDDhhmmssString"];
:global dateTimeToYYYYMMDDhhmmssString do={
## returns a string YYYYMMDDhhmmss representation of the DateTime string in $value
## if $value only contains a time portion, then [/system clock get date] is used as date portion
## if $value only contains a date portion, then [/system clock get time] is used as time portion
## the date portion of $value can be either in long (mmm/dd/yyyy) or short (mmm/dd) Mikrotik format. If short, then the current year is used in yyyy.
## the time portion of $value can either be either in ISO-8601 (hhmmss) Mikrotik (hh:mm:ss) format.
## if $value has an invalid date or time portion, then [/system clock get date].[/system clock get time] is used

## maybe TODO: ensure the various parts are valid:
## - month is valid
## - day of the month is valid (0..27 extended by max days in month)
## - hour in range 0..23
## - minute in range 0..59
## - second in range 0..59

  /system script environment get dateToYYYYMMDDString
  :global dateToYYYYMMDDString;

  /system script environment get timeToHHMMSSString
  :global timeToHHMMSSString;

#  /system script environment get varDump
#  :global varDump;

#:put "value=";
#$varDump value=$value;

  :local dateString "";
  :local timeString "";
## unlike POSIX, character classes like [:digit:] are not supported in regular expressions http://forum.mikrotik.com/viewtopic.php?f=9&t=113422
## unlike POSIX regex, you have to escape the $ here "because Mikrotik scripting language"
#  :local dateOnlyMask "^[a-zA-Z]{3}/[:digit:]{2}/[0-9]{4}\$";
  :local iso8601DateOnlyMask "^[0-9]{4}[0-9]{2}[0-9]{2}\$";
  :local dateOnlyMask "^[a-zA-Z]{3}/[0-9]{2}/[0-9]{4}\$";
  :local shortDateOnlyMask "^[a-zA-Z]{3}/[0-9]{2}\$";

  :local iso8601TimeOnlyMask "^[0-9]{2}[0-9]{2}[0-9]{2}\$";
  :local timeOnlyMask "^[0-9]{2}:[0-9]{2}:[0-9]{2}\$";

  :local iso8601DateTimeMask "^[0-9]{4}[0-9]{2}[0-9]{2}[0-9]{2}[0-9]{2}[0-9]{2}\$";
  :local iso8601DateSpaceTimeMask "^[0-9]{4}[0-9]{2}[0-9]{2} [0-9]{2}[0-9]{2}[0-9]{2}\$";

  :local dateTimeMask "^[a-zA-Z]{3}/[0-9]{2}/[0-9]{4}[0-9]{2}:[0-9]{2}:[0-9]{2}\$";
  :local dateSpaceTimeMask "^[a-zA-Z]{3}/[0-9]{2}/[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}\$";

  :local shortDateTimeMask "^[a-zA-Z]{3}/[0-9]{2}[0-9]{2}:[0-9]{2}:[0-9]{2}\$";
  :local shortDateSpaceTimeMask "^[a-zA-Z]{3}/[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\$";

  :if ($value~$iso8601DateOnlyMask) do={
#    :put "iso8601DateOnly";
##   20161231
##   01234567   index mod 10 for data (date portion only)
##           8  index mod 10 for separators
    :set $dateString [$dateToYYYYMMDDString value=$value];
  } else={
    :if ($value~$dateOnlyMask) do={
#      :put "dateOnly";
##   /log print where buffer=failedauth
##   oct/14/2016
##   012 45 7890   index mod 10 for data
##      3  6    1  index mod 10 for separators
      :set $dateString [$dateToYYYYMMDDString value=$value];
    } else={
      :if ($value~$shortDateOnlyMask) do={
#        :put "shortDateOnly";
##   /log print where buffer=failedauth
##   oct/14 system,error,critical login failure for user root from 201.217.248.217 via telnet
##   012 45   index mod 10 for data
##      3  6  index mod 10 for separators
        :local currentDate [/system clock get date]
        :local currentYear [:pick $currentDate 7 11]
        :set $dateString [$dateToYYYYMMDDString value=($value."/$currentYear")];
      } else={
        :if ($value~$iso8601TimeOnlyMask) do={
#          :put "iso8601TimeOnly";
##   012345
##   012345   index mod 10 for data (date portion only)
##         6  index mod 10 for separators
          :set $timeString $value;
        } else={
          :if ($value~$timeOnlyMask) do={
#            :put "timeOnly";
## 17:37:09
## 01 34 67  index mod 10 for data (time portion only)
##   2  5  8 index mod 10 for separators (time portion only)
            :set $timeString [$timeToHHMMSSString value=$value];
          } else={
            :if ($value~$iso8601DateTimeMask) do={
#              :put "iso8601DateTime";
##   20161231012345
##   01234567         index mod 10 for data (date portion only)
##           890123   index mod 10 for data (time portion only)
##                 4  index mod 10 for separators
              :set $dateString [:pick $value 0 8]
              :set $timeString [:pick $value 8 14]
            } else={
              :if ($value~$iso8601DateSpaceTimeMask) do={
#                :put "iso8601DateSpaceTime";
##   20161231 012345
##   01234567          index mod 10 for data (date portion only)
##            901234   index mod 10 for data (time portion only)
##           8      5  index mod 10 for separators
                :set $dateString [:pick $value 0 8]
                :set $timeString [:pick $value 9 15]
              } else={
                :if ($value~$dateTimeMask) do={
#                  :put "dateTime";
## oct/13/201617:37:09
## 012 45 7890          index mod 10 for data (date portion only)
##    3  6    1         index mod 10 for separators (date portion only)
##            12 45 78  index mod 10 for data (time portion only)
##              3  6  9 index mod 10 for separators (time portion only)
                  :set $dateString [$dateToYYYYMMDDString value=[:pick $value 0 11]];
                  :set $timeString [$timeToHHMMSSString value=[:pick $value 11 19]];
                } else={
                  :if ($value~$dateSpaceTimeMask) do={
#                    :put "dateSpaceTime";
## oct/13/2016 17:37:09
## 012 45 7890          index mod 10 for data (date portion only)
##    3  6    1         index mod 10 for separators (date portion only)
##             23 56 89  index mod 10 for data (time portion only)
##               4  7  0 index mod 10 for separators (time portion only)
                    :set $dateString [$dateToYYYYMMDDString value=[:pick $value 0 11]];
                    :set $timeString [$timeToHHMMSSString value=[:pick $value 12 20]];
                  } else={
                    :if ($value~$shortDateTimeMask) do={
#                      :put "shortDateTime";
## oct/1317:37:09
## 012 45          index mod 10 for data (date portion only)
##    3  6         index mod 10 for separators (date portion only)
##       67 90 23  index mod 10 for data (time portion only)
##         89 1  4 index mod 10 for separators (time portion only)
                      :local currentDate [/system clock get date]
                      :local currentYear [:pick $currentDate 7 11]
                      :set $dateString [$dateToYYYYMMDDString value=([:pick $value 0 6]."/$currentYear")];
                      :set $timeString [$timeToHHMMSSString value=[:pick $value 7 14]];
                    } else={
                      :if ($value~$shortDateSpaceTimeMask) do={
#                        :put "shortDateSpaceTime";
## oct/13 17:37:09
## 012 45           index mod 10 for data (date portion only)
##    3  6          index mod 10 for separators (date portion only)
##        78 01 34  index mod 10 for data (time portion only)
##          9  2  5 index mod 10 for separators (time portion only)
                        :local currentDate [/system clock get date]
                        :local currentYear [:pick $currentDate 7 11]
                        :set $dateString [$dateToYYYYMMDDString value=([:pick $value 0 6]."/$currentYear")];
                        :set $timeString [$timeToHHMMSSString value=[:pick $value 7 15]];
                      } else={
#                        :put "not any of iso8601DateOnly, dateOnly, shortDateOnly, iso8601TimeOnly, timeOnly, iso8601DateTime, iso8601DateSpaceTime, dateTime, dateSpaceTime, shortDateTime, shortDateSpaceTime"
## foo
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  :if ($dateString = "") do={
    :set $dateString [$dateToYYYYMMDDString value=[/system clock get date]];
  }
  :if ($timeString = "") do={
    :set $timeString [$timeToHHMMSSString value=[/system clock get time]];
  }
#:put "dateString=";
#$varDump value=$dateString;
#:put "timeString=";
#$varDump value=$timeString;

  :local result ($dateString.$timeString);
#:put "result=";
#$varDump value=$result;
  return $result;
}

## Examples:
## /import scripts/Function.dateTimeToYYYYMMDDhhmmssString.rsc
## :put [$dateTimeToYYYYMMDDhhmmssString value=([/system clock get date] . [/system clock get time])]
## :put [$dateTimeToYYYYMMDDhhmmssString value=([/system clock get time])]
## :put [$dateTimeToYYYYMMDDhhmmssString value=([/system clock get date])]
## :put [$dateTimeToYYYYMMDDhhmmssString value="oct/13/2016"]
## :put [$dateTimeToYYYYMMDDhhmmssString value="oct/13"]
## :put [$dateTimeToYYYYMMDDhhmmssString value="jan/03"]
## :put [$dateTimeToYYYYMMDDhhmmssString value="jan/03/2016"]
## :put [$dateTimeToYYYYMMDDhhmmssString value="jan/03/201607:06:09"]
## 20160103070609
## :put [$dateTimeToYYYYMMDDhhmmssString value="07:06:09"]
## :put [$dateTimeToYYYYMMDDhhmmssString value="jan/03/2016"]
## :put [$dateTimeToYYYYMMDDhhmmssString value="oct/14 00:19:51"]
## 20161014001951
## :put [$dateTimeToYYYYMMDDhhmmssString value="oct/14/2016 09:48:25"]
## 20161014094825
## :put [$dateTimeToYYYYMMDDhhmmssString value="20161231"]
## :put [$dateTimeToYYYYMMDDhhmmssString value="oct/14/2016"]
## :put [$dateTimeToYYYYMMDDhhmmssString value="oct/14"]
## :put [$dateTimeToYYYYMMDDhhmmssString value="012345"]
## :put [$dateTimeToYYYYMMDDhhmmssString value="17:37:09"]
## :put [$dateTimeToYYYYMMDDhhmmssString value="20161231012345"]
## 20161231012345
## :put [$dateTimeToYYYYMMDDhhmmssString value="20161231 012345"]
## 20161231012345
## :put [$dateTimeToYYYYMMDDhhmmssString value="oct/13/201617:37:09"]
## 20161013173709
## :put [$dateTimeToYYYYMMDDhhmmssString value="oct/13/2016 17:37:09"]
## 20161013173709
## :put [$dateTimeToYYYYMMDDhhmmssString value="oct/1317:37:09"]
## :put [$dateTimeToYYYYMMDDhhmmssString value="oct/13 17:37:09"]
## :put [$dateTimeToYYYYMMDDhhmmssString value="foo"]
