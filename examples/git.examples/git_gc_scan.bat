@echo off

REM We need to delay expansion, otherwise variables inside 'for' block will get replaced when the batch processor reads them in the 'for' loop, before it is executed.
REM See this link for details: https://stackoverflow.com/questions/5615206/windows-batch-files-setting-variable-in-for-loop
setlocal enabledelayedexpansion

REM Iterate over all git repositories 
for /f %%l in ('C:\"Program Files"\Git\usr\bin\find . -name ".git"') do (

	echo Checking dir:%%~dpnl

	REM We need to check whether a git repository contains any untracked file. If so DO NOT EXECUTE 'git clean -fxd' command
	set  foundUntrackedFiles=no
	
	REM This will be executed for each line returned from the 'git status' command. So, avoid printing info inside it.
	for /f "tokens=*" %%i in ('git -C %%~dpnl status') do (
        
		REM This command will print each line returned by the 'git status' command. Uncomment it if you want to see that result.
		echo %%i
		
		set temp=%%~ni
		
		REM This line is another way to execute a 'if' command. Let it here just for future references
		REM If NOT "!temp:~0,80!"=="!temp:On branch=!" (
	    echo.!temp:~0,80!|findstr /C:"Untracked" >nul 2>&1 
		if not errorlevel 1 (
		   set  foundUntrackedFiles=yes
		   REM echo XXXX Found untracked file
		) 
	)
	
	REM echo foundUntrackedFiles: !foundUntrackedFiles:~0,3!
	
	REM Now that we iterated over all lines returned by the 'git status' command, check whether 'untracked' word was found. If so,
	REM just print a warn message and DO NOT EXECUTE 'git clean -fxd command'
	echo.!foundUntrackedFiles:~0,3!|findstr /C:"yes" >nul 2>&1 
	if not errorlevel 1 (
	   echo.
	   echo WARNING: At least one file is untracked. Skipping clean git repository
	) else (
	   echo.
	   echo Calling git gc for %%l
	   git -C %%~dpnl gc
	)
	
    echo #####################################
    echo.
    echo.
)