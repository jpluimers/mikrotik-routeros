## Imports all Function.*.rsc and Procedure.*.rsc files from the /scripts directory
## so they can be used and listed as `/system script environment print`

## Emit output to both console and log.

## inspired by http://forum.mikrotik.com/viewtopic.php?t=75081#p477543 (Re: Functions and function parameters)

## Match scripts in `scripts/` folder ending with `.rsc` and starting with `Function.` or `Procedure.`

## Run by copying this script into the `scripts/` folder then running this from the terminal:

## `/import scripts/import.file-scripts-functions-procedures.rsc`

## Note in order to call a `:local` method from another method, it needs to be `:local` inside that other method.

:local importScriptsInScriptsDirectoryStartingWith do={
  :local importScriptsByPattern do={
    # imports scripts matching $value pattern
    :local logLine "Importing scripts matching pattern '$value'"
    :put $logLine
    :log info $logLine

    :local count 0

    :foreach fileId in [/file find where name~"$value"] do={
      :local fileName [/file get $fileId name]
      :local fileType [/file get $fileId type]
      :local fileSize [/file get $fileId size]
      :local fileSizeType [:typeof $fileSize]
      :local logLine "Importing script: $fileSize bytes ($fileSizeType), type $fileType: '$fileName'"
      :put $logLine
      :log info $logLine
      /import $fileName
      :set $count ($count + 1)
    }
    :if ($count = 0) do={
      :local logLine "No scripts matching pattern '$value'"
      :put $logLine
      :log info $logLine
    }
  }

  $importScriptsByPattern value=("^scripts/$value.*\\.rsc\$")
}

## start in the root so the outer `eval` in each function doesn't include the full path to where we were.
/

$importScriptsInScriptsDirectoryStartingWith value=("Function\\.")
$importScriptsInScriptsDirectoryStartingWith value=("Procedure\\.")

# Example:
# /import scripts/import.file-scripts-functions-procedures.rsc
