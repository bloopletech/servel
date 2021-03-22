docker build -t bloopletech/servel .
@if %errorlevel% neq 0 exit /b %errorlevel%
docker push bloopletech/servel
@if %errorlevel% neq 0 exit /b %errorlevel%