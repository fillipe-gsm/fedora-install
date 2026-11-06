# Android SDK / Java for Capacitor builds (personal-workout-app)
# Java 25 (system) is too new for Gradle 8.11.1 (major version 69 error),
# so JAVA_HOME points at a Temurin JDK 21 LTS installed in ~/jdks
set -x JAVA_HOME $HOME/jdks/temurin-21
set -x ANDROID_HOME $HOME/Android/Sdk
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $ANDROID_HOME/platform-tools
