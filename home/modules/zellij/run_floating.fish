function zellij_run_floating_center --argument-names percentage
    if not set -q percentage
        echo "Usage: zellij_run_floating_center percentage"; return 1
    end

    set calculated_percentage (math "$percentage")

    if [ $calculated_percentage -lt 0 -o $calculated_percentage -gt 100 ]
        echo "Invalid percentage: The percentage should be between 0 and 100."; return 1
    end

    # Get terminal dimensions
    set terminal_width (tput cols)
    set terminal_height (tput lines)

    # Calculate pane dimensions based on percentage
    set pane_width (math "($terminal_width * $calculated_percentage) / 100")
    set pane_height (math "($terminal_height * $calculated_percentage) / 100")

    # Calculate center positions
    set x_pos (math "(($terminal_width - $pane_width) / 2)")
    set y_pos (math "(($terminal_height - $pane_height) / 2)")

    # Command to run Zellij centered floating pane
    zellij options layout --width $pane_width --height $pane_height -x $x_pos -y $y_pos

    echo "Floating pane launched with width $pane_width, height $pane_height, at position x: $x_pos, y: $y_pos."
end

