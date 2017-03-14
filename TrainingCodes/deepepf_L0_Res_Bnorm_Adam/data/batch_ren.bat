@echo off
setlocal EnableDelayedExpansion
set n=1
set pre="000"


for /f %%i in ('dir /b *') do (
	if "%%i" neq "batch_ren.bat" (
		ren "%%i" val_!n!.jpg
		set /a n+=1
	)
)

echo 批量重命名完成！
pause
