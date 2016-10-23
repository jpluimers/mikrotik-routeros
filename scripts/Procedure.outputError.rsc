/system script environment remove [ find where name="outputError" ];
:global outputError do={
  ## outputs $value using both :put and :log info
  :put "error: $value"
  :log error "$value"
}

## Examples:
## /import scripts/Procedure.outputError.rsc

## > $outputError value="12345"
## > $outputError value=12345
## > $outputError value=(12345)
