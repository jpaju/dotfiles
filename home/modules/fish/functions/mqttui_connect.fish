function mqttui_connect --wraps='mqttui'
    set secrets (gum spin --title "Loading list of secrets from 1password" --show-output -- op item list --format json | jq -r '.[] | select(.category == "SERVER") | .title')

    if not set -q secrets[1]
        print_red "Failed to read secrets, aborting"; return 1
    end

    set chosen_secret_name (gum filter $secrets)

    if not set -q chosen_secret_name[1]
        print_red "No secret selected, aborting"; return 1
    end

    # Load specific secret by name
    set chosen_secret_json (gum spin --title "Loading $chosen_secret_name" --show-output -- op item get $chosen_secret_name --format json)

    # Extract required secrets from the JSON
    set username (echo $chosen_secret_json | jq -r '.fields[] | select(.id == "username") | .value')
    set password (echo $chosen_secret_json | jq -r '.fields[] | select(.id == "password") | .value')
    set mqtt_url (echo $chosen_secret_json | jq -r '.fields[] | select(.id == "url") | .value')

    if test $username = null
        print_red "Missing username, aborting"; return 1
    else if test $password = null
        print_red "Missing password, aborting"; return 1
    else if test $mqtt_url = null
        print_red "Missing url, aborting"; return 1
    end

    command mqttui --broker $mqtt_url --username $username --password $password $argv
end

function print_red --argument-names text
    echo (set_color red)"$text"(set_color normal)
end
