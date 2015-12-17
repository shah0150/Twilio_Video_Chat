@echo off
setlocal
set PORT=8000

:PYTHON
for /L %%v IN (4,1,7) do call set "PATH=%%PATH%%;C:\Python2%%v"
for /L %%v IN (0,1,4) do call set "PATH=%%PATH%%;C:\Python3%%v"
python.exe -V > NUL 2>&1
if %ERRORLEVEL% == 9009 goto PHP
call :MESSAGE Python
python -m SimpleHTTPServer %PORT%
if %ERRORLEVEL% == 0 goto END
python -m http.server %PORT%
if %ERRORLEVEL% == 0 goto END
echo Unknown Python version

:PHP
set PATH=%PATH%;C:\PHP;
php -v > NUL 2>&1
if %ERRORLEVEL% == 9009 goto RUBY
call :MESSAGE PHP
php -S 127.0.0.1:%PORT%
if %ERRORLEVEL% == 0 goto END
echo Unknown PHP version

:RUBY
set PATH=%PATH%;C:\Ruby187\bin;C:\Ruby192\bin;C:\Ruby193\bin;C:\Ruby200\bin;C:\Ruby21\bin;C:\Ruby22\bin
ruby.exe -v > NUL 2>&1
if %ERRORLEVEL% == 9009 goto IIS
call :MESSAGE Ruby
ruby -run -ehttpd . -p%PORT%
if %ERRORLEVEL% == 0 goto END
ruby -rwebrick -e"WEBrick::HTTPServer.new(:Port => %PORT%, :DocumentRoot => Dir.pwd).start"
if %ERRORLEVEL% == 0 goto END
echo Unknown Ruby version

:IIS
set PATH=%PATH%;C:\Program Files (x86)\IIS Express;C:\Program Files\IIS Express
iisexpress /? > NUL 2>&1
if %ERRORLEVEL% == 9009 goto NOT_FOUND
call :MESSAGE IISExpress
iisexpress.exe /path:"%CD%" /port:%PORT%
if %ERRORLEVEL% == 0 goto END
echo Unknown IIS Express version

:NOT_FOUND
echo Unable to launch a local web server. Please try the Heroku deployment option from the Twilio portal.
pause
:END
endlocal
goto :EOF

:MESSAGE
echo Attempting to start a local web server using %1. View your Twilio Conversations Quickstart at http://localhost:%PORT%/quickstart.html
exit /b