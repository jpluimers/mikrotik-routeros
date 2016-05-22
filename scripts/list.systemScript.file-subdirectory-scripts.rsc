## can be executed as one-liner
## it lists size, typeof size, type and name of each file
#:foreach fileId in [/file find] do={ :local fileName [/file get $fileId name]; :local fileType [/file get $fileId type]; :local fileSize [/file get $fileId size]; :local fileSizeType [:typeof $fileSize]; :put "$fileSize bytes ($fileSizeType), type $fileType: '$fileName'" }

## Match anything
:foreach fileId in [/file find where name~".*"] do={ :local fileName [/file get $fileId name]; :local fileType [/file get $fileId type]; :local fileSize [/file get $fileId size]; :local fileSizeType [:typeof $fileSize]; :put "$fileSize bytes ($fileSizeType), type $fileType: '$fileName'" }

## Match starting with "scripts/Function."
:foreach fileId in [/file find where name~"^scripts\\/\\Function\\..*"] do={ :local fileName [/file get $fileId name]; :local fileType [/file get $fileId type]; :local fileSize [/file get $fileId size]; :local fileSizeType [:typeof $fileSize]; :put "$fileSize bytes ($fileSizeType), type $fileType: '$fileName'" }
## inspired by http://forum.mikrotik.com/viewtopic.php?t=75081#p477543 (Re: Functions and function parameters)

## Example:
## /import scripts/list.systemScript.file-subdirectory-scripts.rsc
