# TODO Set secret environment variables only for programs that need them. Should be possible by defining nix wrappers
set -x COPILOT_API_KEY (cat $TMPDIR/secrets/copilot_api_key)

