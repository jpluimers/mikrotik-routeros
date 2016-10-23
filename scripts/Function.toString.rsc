:local scriptName "Function.toString.rsc"
/system script environment remove [ find where name="toString" ];
## First try at https://gist.github.com/jpluimers/f667af4696d2a6411be44df1eeda2c2f
:global toString do={
  ## for recursion
  :global toString;
  ## convert non-printable characters in $value to HEX-escaped compatible with the Scripting Language
  ## string loop based on URL encoding in http://forum.mikrotik.com/viewtopic.php?t=84705
  :local result "";
  :local infoMessage "$scriptName testing for function existence; if you get `no such item` then one or more dependencies fail; test with `/system script environment print` and `/system logging action print` if they are there."
#  :put "info: $infoMessage"

#  :put "$value"
  :local typeOfValue [:typeof $value]

  :if ($typeOfValue = "str") do={
    :set $result $value;
#    :put "str: $result"
  } else={
    :if ($typeOfValue = "array") do={
#      :put "$typeOfValue"
      :foreach key,element in=$value do={
        :if ($result != "") do={
          :set $result "$result,";
#          :put "comma: $result"
        }
        :local typeOfKey [:typeof $key];
        :if ($typeOfKey != "num") do={
          :local keyString [$toString value=$key];
          :set $result ($result."$keyString=");
#          :put "non-num key: $result"
        }
        :local elementString [$toString value=$element];
#        :put "element: $elementString=$element"
        :set $result ($result."$elementString");
#        :put "iteration: $result"
      };
    } else={
#      :put "typeOfValue: $typeOfValue"
      :if (($typeOfValue = "nothing") or ($typeOfValue = "nil")) do={
      } else={
        :set result "$value";
      }
    }
  }
#  :put "result=$result"
  :return $result;
}

## Example:
## /import scripts/Function.toString.rsc
##{
##  :global dateTimeToYYYYMMDDhhmmssNumber;
##  :global toString;
##  :foreach logEntry in=[/log print as-value where buffer="memory"] do={
##    :local logEntryTime ($logEntry->"time");
##    :local logEntryTopics ($logEntry->"topics");
##    :local logEntryMessage ($logEntry->"message");
##
##    :local logEntryDateTime [$dateTimeToYYYYMMDDhhmmssNumber value=$logEntryTime];
##    :local logEntryTopicsType [:typeof $logEntryTopics];
##    :local logEntryTopicsString [$toString value=$logEntryTopics];
##    :put "$logEntryDateTime;$logEntryTime;$logEntryMessage;$logEntryTopicsType;$logEntryTopicsString";
##  }
##}
