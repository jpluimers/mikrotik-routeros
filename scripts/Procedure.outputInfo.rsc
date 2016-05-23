:global outputInfo do={
  ## outputs $value using both :put and :log info
  :put "info: $value"
  :log info "$value"
}

## Examples:
## /import scripts/Procedure.outputInfo.rsc

## > $outputInfo value="12345"
## > $outputInfo value=12345
## > $outputInfo value=(12345)
