function mqttui --wraps='mqttui'
    set secret_titles (gum spin --title "Loading list of secrets from Dashlane" --show-output -- dcli password --output json | jq -r '.[].title | select(. != null)')

    if not set -q secret_titles[1]
        print_red "Failed to read secrets, aborting"; return 1
    end

    set chosen_secret_name (gum filter $secret_titles)

    if not set -q chosen_secret_name[1]
        print_red "No secret selected, aborting"; return 1
    end

    # Load specific secret by name
    set chosen_secret_json (gum spin  --title "Loading $chosen_secret_name" --show-output -- dcli read "dl://$chosen_secret_name")


    # Extract required secrets from the JSON
    set username (echo $chosen_secret_json | jq -r '.login')
    set password (echo $chosen_secret_json | jq -r '.password')
    set url (echo $chosen_secret_json | jq -r '.url')

    if test $username = null
        print_red "Missing username, aborting"; return 1
    else if test $password = null
        print_red "Missing password, aborting"; return 1
    else if test $url = null
        print_red "Missing url, aborting"; return 1
    end

    # Dashlane adds http(s):// to every url so replace it with mqtt://
    set mqtt_url (string replace --regex "https?://" "mqtt://" $url) 

    command mqttui --broker $mqtt_url --username $username --password $password $argv
end

function print_red --argument-names text
    echo (set_color red)"$text"(set_color normal)
end

