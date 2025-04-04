#!/bin/bash
echo "v1.0.0 - Initial release only designed for macOS, Intel and Apple Silicon processors. No support for Linux yet."

# Detect if the system is macOS or Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    SYS_TYPE="macOS"
    echo "Running on macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    SYS_TYPE="Linux"
    echo "Running on Linux"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Detect system architecture
echo "Detecting system architecture..."

ARCHITECTURE=$(uname -m)

if [[ "$ARCHITECTURE" == "x86_64" ]]; then
    SYS_ARCH="x64"
elif [[ "$ARCHITECTURE" == "arm64" || "$ARCHITECTURE" == "aarch64" ]]; then
    if [[ "$SYS_TYPE" == "macOS" ]]; then
        SYS_ARCH="macOS Silicon (ARM)"
    else
        SYS_ARCH="ARM"
    fi
else
    SYS_ARCH="$ARCHITECTURE (unsupported)"
    echo "System architecture: $SYS_ARCH"
    exit 1
fi

echo "System architecture: $SYS_ARCH"

# If the system is macOS and running on Apple Silicon, install Rosetta
if [[ "$SYS_TYPE" == "macOS" && "$SYS_ARCH" == "macOS Silicon (ARM)" ]]; then
    echo "Checking for Rosetta installation..."
    if /usr/bin/pgrep oahd >/dev/null 2>&1; then
        echo "Rosetta is already installed."
    else
        echo "Installing Rosetta..."
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
        if [ $? -eq 0 ]; then
            echo "Rosetta installed successfully."
        else
            echo "Failed to install Rosetta."
            exit 1
        fi
    fi
fi

# Check if Homebrew is installed
echo "Checking for Homebrew installation..."
if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."
    if [[ "$SYS_TYPE" == "macOS" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ $? -eq 0 ]; then
            echo "Homebrew installed successfully."
        else
            echo "Failed to install Homebrew."
            exit 1
        fi
    else
        echo "Homebrew installation is only supported on macOS in this script."
        exit 1
    fi
else
    echo "Homebrew is already installed."
fi

# Install the latest version of Git using Homebrew
if [[ "$SYS_TYPE" == "macOS" ]]; then
    echo "Installing the latest version of Git..."
    brew install git
    if [ $? -eq 0 ]; then
        echo "Git installed successfully."
    else
        echo "Failed to install Git."
        exit 1
    fi

    # Install the latest version of CocoaPods using Homebrew
    echo "Installing the latest version of CocoaPods..."
    brew install cocoapods
    if [ $? -eq 0 ]; then
        echo "CocoaPods installed successfully."
    else
        echo "Failed to install CocoaPods."
        exit 1
    fi

    # Download and install Flutter
    echo "Installing Flutter..."
    FLUTTER_URL=""
    if [[ "$SYS_ARCH" == "x64" ]]; then
        FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.29.2-stable.zip"
    elif [[ "$SYS_ARCH" == "macOS Silicon (ARM)" ]]; then
        FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.29.2-stable.zip"
    fi

    if [[ -n "$FLUTTER_URL" ]]; then
        curl -o flutter.zip "$FLUTTER_URL"
        if [ $? -eq 0 ]; then
            echo "Flutter downloaded successfully."
        else
            echo "Failed to download Flutter."
            exit 1
        fi

        echo "Unzipping Flutter..."
        mkdir -p ~/.flutter/
        unzip -q flutter.zip -d ~/.flutter/
        if [ $? -eq 0 ]; then
            echo "Flutter unzipped successfully."
        else
            echo "Failed to unzip Flutter."
            exit 1
        fi

        echo "Moving Flutter to the correct directory..."
        mv ~/.flutter/flutter/* ~/.flutter/
        rmdir ~/.flutter/flutter

        echo "Adding Flutter to PATH..."
        FLUTTER_BIN_PATH='export PATH="$HOME/.flutter/bin:$PATH"'
        if ! grep -Fxq "$FLUTTER_BIN_PATH" ~/.zshrc; then
            echo "$FLUTTER_BIN_PATH" >> ~/.zshrc
            echo "Flutter path added to ~/.zshrc."
        else
            echo "Flutter path already exists in ~/.zshrc."
        fi

        echo "Installation of Flutter completed."
    else
        echo "Unsupported architecture for Flutter installation."
        exit 1
    fi

    # Install the latest version of Xcode
    echo "Installing the latest version of Xcode..."
    if ! xcode-select -p &>/dev/null; then
        echo "Xcode is not installed. Installing Xcode..."
        xcode-select --install
        if [ $? -eq 0 ]; then
            echo "Xcode installed successfully."
        else
            echo "Failed to install Xcode."
            exit 1
        fi
    else
        echo "Xcode is already installed."
    fi
    # Accept Xcode license
    echo "Accepting Xcode license..."
    sudo xcodebuild -license accept
    if [ $? -eq 0 ]; then
        echo "Xcode license accepted."
    else
        echo "Failed to accept Xcode license."
        exit 1
    fi
    # Check if Google Chrome is installed
    echo "Checking for Google Chrome installation..."
    if open -Ra "Google Chrome"; then
        echo "Google Chrome is already installed."
    else
        echo "Google Chrome is not installed. Installing Google Chrome with Homebrew..."
        brew install --cask google-chrome
        if [ $? -eq 0 ]; then
            echo "Google Chrome installed successfully."
        else
            echo "Failed to install Google Chrome."
            exit 1
        fi
    fi

    # Check if Android Studio is installed
    echo "Checking for Android Studio installation..."
    if open -Ra "Android Studio"; then
        echo "Android Studio is already installed."
    else
        echo "Android Studio is not installed. Installing Android Studio with Homebrew..."
        brew install --cask android-studio
        if [ $? -eq 0 ]; then
            echo "Android Studio installed successfully."
        else
            echo "Failed to install Android Studio."
            exit 1
        fi
    fi

    # Install Android SDK components
    echo "Installing Android SDK components..."

    # Ensure Android SDK Command-line Tools are installed
    echo "Installing Android SDK Command-line Tools..."
    brew install --cask android-commandlinetools
    if [ $? -eq 0 ]; then
        echo "Android SDK Command-line Tools installed successfully."
    else
        echo "Failed to install Android SDK Command-line Tools."
        exit 1
    fi

    # Set up Android SDK environment variables
    ANDROID_HOME="$HOME/Library/Android/sdk"
    PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
    export ANDROID_HOME PATH

    # Accept licenses
    echo "Accepting Android SDK licenses..."
    yes | sdkmanager --licenses

    # Install Android SDK Platform, API 35.0.2
    echo "Installing Android SDK Platform, API 35.0.2..."
    sdkmanager "platforms;android-35"
    if [ $? -eq 0 ]; then
        echo "Android SDK Platform installed successfully."
    else
        echo "Failed to install Android SDK Platform."
        exit 1
    fi

    # Install Android SDK Build-Tools
    echo "Installing Android SDK Build-Tools..."
    sdkmanager "build-tools;35.0.2"
    if [ $? -eq 0 ]; then
        echo "Android SDK Build-Tools installed successfully."
    else
        echo "Failed to install Android SDK Build-Tools."
        exit 1
    fi

    # Install Android SDK Platform-Tools
    echo "Installing Android SDK Platform-Tools..."
    sdkmanager "platform-tools"
    if [ $? -eq 0 ]; then
        echo "Android SDK Platform-Tools installed successfully."
    else
        echo "Failed to install Android SDK Platform-Tools."
        exit 1
    fi

    # Install Android Emulator
    echo "Installing Android Emulator..."
    sdkmanager "emulator"
    if [ $? -eq 0 ]; then
        echo "Android Emulator installed successfully."
    else
        echo "Failed to install Android Emulator."
        exit 1
    fi

    echo "Android SDK components installed successfully."

fi

echo "Installation completed successfully."
echo "Please restart your terminal or run 'source ~/.zshrc' to apply the changes."
echo "You can now start using Flutter and Android development tools."
echo "If you encounter any issues, please create an issue on the GitHub repository."

echo "v1.0.0 - Initial release only designed for macOS, Intel and Apple Silicon processors. No support for Linux yet."