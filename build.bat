IF EXIST bin DEL /S /Q /F bin
rmdir /S /Q bin
set GOOS=linux
go build -ldflags="-s -w" -o bin/world main.go

::copy config.json bin