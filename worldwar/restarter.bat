@title My Restarter
@echo  By: Danger II
@YurOTS.exe
@echo Restarting. . .

@color 1f
@echo ::       Checking for 'YurOTS.exe'. . .
@echo ::
@echo ::
@if not exist YurOTS.exe GOTO problem
@if exist YurOTS.exe GOTO FOUND

:problem
@echo ::       Sorry! Couldnt locate 'YurOTS.exe'!
@echo ::
@echo ::
@echo ::
@pause


:FOUND
@echo ::       'YurOTS.exe' was found and we are proceeding!
@echo ::
@echo ::
:GOTO HELL


:HELL

@YurOTS.exe
@echo ::       restarting. . .
@echo ::

:goto HELL


:exit


@reset.bat