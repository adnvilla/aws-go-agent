IF NOT "%AwsUser%" == "" GOTO SetUser
set /p AwsUser="Enter Aws User: "

:SetUser
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

aws-vault exec -- %awsuser% sls remove --stage %stage%