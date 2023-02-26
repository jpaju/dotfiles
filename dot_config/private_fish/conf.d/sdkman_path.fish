set -g -x SDKMAN_DIR $(brew --prefix sdkman-cli)/libexec
set -g sdkman_prefix $SDKMAN_DIR

sdk current java # This adds java binary to PATH and sets JAVA_HOME variable
