# dirstat

Windows commandline script to analyze directory contents

## About

Recursivley analyzes files in a directory and lists size information grouped by file type given by the files extension.

Files without an extension are handled as if the file name itself is the file extension.

## Prequisites

Dirstat is a DOS batch using PowerShell to execute.

## Installation

Copy this repository or just the dirstat.bat into a directory of your choice.

Optionally add this directory to your `PATH` environment variable to have access to this script from every working path.

## Syntax

```bat
dirstat [DIRECTORY] [OPTION...]
```

### Parameter

- DIRECTORY

    Optional path to the directory to be analyzed. If omitted the current working directory will be used.

### Options

- -o DIRECTION, --order DIRECTION

    Orders the list by the given DIRECTION which can be either "asc" or "desc".
- -s FIELDS, --sort FIELDS

    Sorts the list by the given FIELDS. Multiple FIELDS can be separated by comma. Valid field names are all column names displayed in the output, which are "type" for the file extension, "files", "lines", "words", "characters" and "bytes" for their respective summed up values and "/lines", "/words", "/characters" and "/bytes" for the average values per file.
- -h, --help

    Displays the help.

## Usage example

Analyze the current working directory with default sorting and ordering options.

```bat
dirstat
```

This is equal to setting the options explicitly.

```bat
dirstat F:\ExternalSrc\marsmission -s "words,type" -o desc
```

```bat
Analyzing directory "F:\ExternalSrc\marsmission", sorting by "words,type" in "desc" order. This may take a while...

type        files  lines   words characters     bytes /lines  /words /characters    /bytes
----        -----  -----   ----- ----------     ----- ------  ------ -----------    ------
.mp3            2 63.368 232.577  7.839.766 7.903.831 31.684 116.289   3.919.883 3.951.916
.png           16 20.304  72.236  2.625.932 2.646.402  1.269   4.515     164.121   165.400
.js            34  7.938  62.780    977.755   996.335    233   1.846      28.758    29.304
.jpg            3  8.568  27.967    960.669   969.312  2.856   9.322     320.223   323.104
.css            8  2.367   7.016     82.552    88.092    296     877      10.319    11.012
.html           3    338   1.059     17.748    18.422    113     353       5.916     6.141
.xml           12    454   1.037     22.210    23.094     38      86       1.851     1.925
.json           4    476     964     10.529    11.473    119     241       2.632     2.868
.md             1     29     309      2.069     2.139     29     309       2.069     2.139
.properties     2     57     235      2.172     2.302     29     118       1.086     1.151
.svg            4     23     177      2.420     2.458      6      44         605       615
.project        1     11      13        193       215     11      13         193       215
.map            1      1       1     36.007    36.007      1       1      36.007    36.007
```

## License

[MIT licensed](https://en.wikipedia.org/wiki/MIT_License).

Copyright (C) 2019 [Sören Weber](https://soeren-weber.de)
