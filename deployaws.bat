call build.bat

IF NOT "%AwsUser%" == "" GOTO SetUser
set /p AwsUser="Enter Aws User: "

:SetUser
:: Get Current Branch Name
::cd "C:\Program Files\Git\bin"
for /f "delims=" %%a in ('git symbolic-ref --short HEAD') do @set stage=%%a

:: Replace characters. >>> A service name should only contain alphanumeric (case sensitive) and hyphens. It should start with an alphabetic character and shouldn't exceed 128 characters.
set stage=%stage:/=-%
set stage=%stage:_=-%

IF %stage% == develop (
	set stage=dev
)

IF %stage% == master (
	set stage=prod
)

cd %cd%

:: Packaging zip
::%GOPATH%\bin\build-lambda-zip.exe -o bin/main.zip bin/world
cd bin
%GOPATH%/bin/win-go-zipper.exe -o main.zip .
cd ..
:: Deploy with user and stage current branch for dev
aws-vault exec -- %AwsUser% sls deploy --stage %stage%
