::还是有问题的，会把自己也给变了，而且还有想办法指定目标目录;主要问题还变量的获取

@echo off
setlocal enabledelayedexpansion
set n=1
set pre="000"


for /f %%i in ('dir /b *') do (
	if %n% geq 10 (
		set pre="00"
		if %n% geq 100 (
			set pre="0"
		)
	) else (
		set pre=""
	)
	ren "%%i" test_!pre!!n!.jpg
	set /a n+=1
)
cd ..
echo 批量重命名完成！ 
pause