scripts
=======

There are lots of gotchas writing RouterOS scripts. The ones I found are documented inside the scripts. Hopefully I will have time in the future to write that up into a proper document.

For now you will have to do with the below information.

Some conventions used:

- method names start with lower case and are `camelCase <https://en.wikipedia.org/wiki/CamelCase>`_ starting with a lowercase character.
- descriptive/explanatory comments start with a double ``##``
- comments used while debugging start with a single ``#``
- explanation of each script is usually at the end of it

``:global`` functions that assist in various operations:

- `Function.civilDateTimeToSecondsSince19700101.rsc               <Function.civilDateTimeToSecondsSince19700101.rsc>`_
- `Function.civilDateToDaysSince19700101.rsc                      <Function.civilDateToDaysSince19700101.rsc>`_
- `Function.dateTimeToYYYYMMDDhhmmssNumber.rsc                    <Function.dateTimeToYYYYMMDDhhmmssNumber.rsc>`_
- `Function.dateTimeToYYYYMMDDhhmmssString.rsc                    <Function.dateTimeToYYYYMMDDhhmmssString.rsc>`_
- `Function.dateToYYYYMMDDString.rsc                              <Function.dateToYYYYMMDDString.rsc>`_
- `Function.endsWithString.rsc                                    <Function.endsWithString.rsc>`_
- `Function.escapeString.rsc                                      <Function.escapeString.rsc>`_
- `Function.padLeftString.rsc                                     <Function.padLeftString.rsc>`_
- `Function.padRightString.rsc                                    <Function.padRightString.rsc>`_
- `Function.startsWithString.rsc                                  <Function.startsWithString.rsc>`_
- `Function.stripInvalidHostNameCharactersFromString.rsc          <Function.stripInvalidHostNameCharactersFromString.rsc>`_
- `Function.timeToHHMMSSString.rsc                                <Function.timeToHHMMSSString.rsc>`_
- `Function.timeToSecondsSinceMidnight.rsc                        <Function.timeToSecondsSinceMidnight.rsc>`_
- `Function.toString.rsc                                          <Function.toString.rsc>`_

Helper:

- `Generate-convert-set-statements.for.Function.escapeString.rsc  <Generate-convert-set-statements.for.Function.escapeString.rsc>`_

Imports all ``.rsc`` files starting with ``Function.`` or ``Procedure``; run like this::

  /import scripts/import.file-scripts-functions-procedures.rsc

- `import.file-scripts-functions-procedures.rsc                   <import.file-scripts-functions-procedures.rsc>`_

Various utilities (not procedures or functions, so just start with ``/import``):

- `list.systemScript.file-subdirectory-scripts.rsc                <list.systemScript.file-subdirectory-scripts.rsc>`_
- `list.systemScript.lengthName.rsc                               <list.systemScript.lengthName.rsc>`_
