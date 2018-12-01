@setlocal enableextensions
@if not defined gx_cmd_debug (echo off)
@endlocal
@rem prebuild.cmd should be called as pre-build event like this:
@rem Path\to\buildtools\prebuild.cmd $(OUTPUTDIR)$(OUTPUTNAME)
@echo %0
@echo running in %CD%

set PROJECTPATH=%1
rem remove quotes
set PROJECTPATH=%PROJECTPATH:"=%

if "%PROJECTPATH%"=="" goto NeedPara
rem echo PROJECTPATH=%PROJECTPATH%
set PROJECTNAMEONLY=%~dpn1
rem echo PROJECTNAMEONLY=%PROJECTNAMEONLY%
set OUTPUTDIR=%~dp1

pushd %OUTPUTDIR%

"%~dp0\prepbuild.exe" --readini="%PROJECTPATH%" --WriteRc="%PROJECTPATH%" --incbuild
brcc32 "%PROJECTNAMEONLY%_Version.rc"

popd

echo %0 exiting
goto :EOF

:NeedPara
echo Error: Needs the base filename of the executable as parameter
