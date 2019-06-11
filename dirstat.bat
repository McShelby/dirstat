@echo off
setlocal enabledelayedexpansion
chcp 65001 2>&1 >nul

set DIRSTAT_RET=0
set DIRSTAT_CMD=%~n0
set DIRSTAT_HELP=0
set DIRSTAT_ORDER=desc
set DIRSTAT_SORT=words,type
set DIRSTAT_DIR=

:DIRSTAT_PARAMETER_LOOP
if not "%1"=="" (
	set DIRSTAT_PARAMETER=%1
	if "!DIRSTAT_PARAMETER!"=="-h" (
		set DIRSTAT_HELP=1
	) else if "!DIRSTAT_PARAMETER!"=="--help" (
		set DIRSTAT_HELP=1
	) else if "!DIRSTAT_PARAMETER!"=="-o" (
		set DIRSTAT_ORDER=%~2
		shift
	) else if "!DIRSTAT_PARAMETER!"=="--order" (
		set DIRSTAT_ORDER=%~2
		shift
	) else if "!DIRSTAT_PARAMETER!"=="-s" (
		set DIRSTAT_SORT=%~2
		shift
	) else if "!DIRSTAT_PARAMETER!"=="--sort" (
		set DIRSTAT_SORT=%~2
		shift
	) else if "!DIRSTAT_PARAMETER:~0,1!"=="-" (
		echo Invalid parameter "!DIRSTAT_PARAMETER!"
		set DIRSTAT_RET=1
		goto :DIRSTAT_END
	) else if not "%DIRSTAT_DIR%"=="" (
		echo Invalid syntax "!DIRSTAT_PARAMETER!"
		set DIRSTAT_RET=1
		goto :DIRSTAT_END
	) else (
		set DIRSTAT_DIR=%~1
	)
	shift
	goto :DIRSTAT_PARAMETER_LOOP
)

if %DIRSTAT_HELP%==1 (
	goto :DIRSTAT_SHOW_HELP
)
if "%DIRSTAT_DIR%"=="" (
	set DIRSTAT_DIR=%cd%
)

echo Analyzing directory "%DIRSTAT_DIR%", sorting by "%DIRSTAT_SORT%" in "%DIRSTAT_ORDER%" order. This may take a while...

set DIRSTAT_ORDER=-%DIRSTAT_ORDER%
if "%DIRSTAT_ORDER%"=="-asc" (
	set DIRSTAT_ORDER=
)
powershell -command "& {get-childitem -path '%DIRSTAT_DIR%' -file -recurse | where {$_.FullName -notmatch '.hg'} | where {$_.FullName -notmatch '.git'} | where {$_.FullName -notmatch '.svn'} | where {$_.FullName -notmatch '_objs'} | where {$_.FullName -notmatch 'FG2Files'} | where {$_.FullName -notmatch 'node_modules'} | where {$_.FullName -notlike '*openui5*'} | where {$_.FullName -notlike '*swagger-ui*'} | select @{n='Type';e={$(if($_.extension.length){$_.extension}else{$_.name})}}, @{n='Files';e={(($_ | measure length).count)}}, @{n='Lines';e={(($_ | get-content | measure -line).lines)}}, @{n='Words';e={(($_ | get-content | measure -word).words)}}, @{n='Characters';e={(($_ | get-content | measure -character).characters)}}, @{n='Bytes';e={(($_ | measure length -sum).sum)}} | group Type | select @{n='type';e={$_.name}}, @{n='files';e={(($_.group | measure files -sum).sum)}}, @{n='lines';e={(($_.group | measure lines -sum).sum)}}, @{n='words';e={(($_.group | measure words -sum).sum)}}, @{n='characters';e={(($_.group | measure characters -sum).sum)}}, @{n='bytes';e={(($_.group | measure bytes -sum).sum)}}, @{n='/lines';e={(($_.group | measure lines -sum).sum / ($_.group | measure files -sum).sum)}}, @{n='/words';e={(($_.group | measure words -sum).sum / ($_.group | measure files -sum).sum)}}, @{n='/characters';e={(($_.group | measure characters -sum).sum / ($_.group | measure files -sum).sum)}}, @{n='/bytes';e={(($_.group | measure bytes -sum).sum / ($_.group | measure files -sum).sum)}} | sort %DIRSTAT_SORT% %DIRSTAT_ORDER% | format-table @{e='*';f='#,0'} }"
set DIRSTAT_RET=%ERRORLEVEL%

goto DIRSTAT_END

:DIRSTAT_SHOW_HELP
echo %DIRSTAT_CMD% - analyze directory contents
echo.
echo Syntax:
echo   %DIRSTAT_CMD% [DIRECTORY] [OPTION...]
echo.
echo Description:
echo Recursivley analyzes files in DIRECTORY and lists size information grouped
echo by file type given by the files extension. Files without an extension are
echo handled as if the file name itself is the file extension.
echo.
echo Parameter:
echo   DIRECTORY
echo     Optional path to the directory to be analyzed. If omitted the current
echo     working directory will be used.
echo.
echo Options:
echo   -o DIRECTION, --order DIRECTION
echo     Orders the list by the given DIRECTION which can be either "asc"
echo     or "desc".
echo   -s FIELDS, --sort FIELDS
echo     Sorts the list by the given FIELDS. Multiple FIELDS can be separated by
echo     comma. Valid field names are all column names displayed in the output,
echo     which are "type" for the file extension, "files", "lines", "words",
echo     "characters" and "bytes" for their respective summed up values and
echo     "/lines", "/words", "/characters" and "/bytes" for the average values
echo     per file.
echo   -h, --help
echo     Displays this help.

:DIRSTAT_END
exit /b %DIRSTAT_RET%
