scripts
=======

Some conventions used:

- method names start with lower case and are `camelCase <https://en.wikipedia.org/wiki/CamelCase>`_ starting with a lowercase character.
- descriptive/explanatory comments start with a double :code:`##`
- comments used while debugging start with a single :code:`#`
- explanation of each script is usually at the end of it

:code:`:global` functions that assist in various operations:

- Function.endsWithString.rsc
- Function.escapeString.rsc
- Function.padLeftString.rsc
- Function.padRightString.rsc
- Function.startsWithString.rsc
- Function.stripInvalidHostNameCharactersFromString.rsc
- Function.varDump.rsc

Helper:

- Generate-convert-set-statements.for.Function.escapeString.rsc

Imports all :code:`.rsc` files starting with :code:`Function.` or :code:`.Procedure`:

- import.file-scripts-functions-procedures.rsc

Various utilities (not procedures or functions, so just start with :code:`/import`):

- list.systemScript.file-subdirectory-scripts.rsc
- list.systemScript.lengthName.rsc
