# Load Copilot API key from Dashlane if not already set. Not sure if this the secure way to do this, but it works for now.
# TODO This takes a long time, so would be nice to do it in the background
if test -z "$COPILOT_API_KEY"
    set -x COPILOT_API_KEY (dcli read "dl://Copilot API key/password")
end

