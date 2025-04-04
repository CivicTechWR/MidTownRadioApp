@echo off
:: Install Flutter script

:: Define the Flutter download URL
set FLUTTER_URL=https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.29.2-stable.zip

:: Define the destination folder
set DEST_FOLDER=%~dp0flutter

:: Download Flutter
echo Downloading Flutter...
powershell -Command "Invoke-WebRequest -Uri %FLUTTER_URL% -OutFile flutter.zip"

:: Extract Flutter
echo Extracting Flutter...
powershell -Command "Expand-Archive -Path flutter.zip -DestinationPath %DEST_FOLDER% -Force"

:: Clean up
echo Cleaning up...
del flutter.zip

:: Add Flutter to PATH
setx PATH "%DEST_FOLDER%\flutter\bin;%PATH%"

echo Flutter installation complete. Please restart your terminal or command prompt.

:: Check if winget is installed
echo Checking for winget...
where winget >nul 2>&1
if %errorlevel% neq 0 (
    echo winget is not installed. Please install winget manually and re-run this script.
    exit /b 1
)

:: Check if Android Studio is installed
echo Checking for Android Studio...
where "C:\Program Files\Android\Android Studio\bin\studio64.exe" >nul 2>&1
if %errorlevel% neq 0 (
    echo Android Studio is not installed. Installing Android Studio...
    winget install -e --id Google.AndroidStudio
) else (
    echo Android Studio is already installed.
)

:: Run Flutter doctor to verify installation
echo Running Flutter doctor...
"%DEST_FOLDER%\flutter\bin\flutter" doctor

:: Prompt user to add an issue in the project and assign/tag Julian
echo If you encounter any issues, please add an issue in the project repository and assign/tag Julian.