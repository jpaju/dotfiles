function git_blame --argument-names file line_number
    # Capturing blame output to variable doesn't seem to work because of how newlines are handled.
    # Grepping the output from a variable storing git blame output didn't work
    set blame_cmd "git blame -L $line_number,$line_number --line-porcelain $file"

    set commit_hash (eval $blame_cmd | head -n1 | cut -d ' ' -f1)

    # Line contains uncommitted changes
    if test "$commit_hash" = "0000000000000000000000000000000000000000"
        set author_name "You"
        set date "Just now"
        set commit_msg "Not committed yet"
    else
        set author_name (eval $blame_cmd | grep "^author " | cut -d ' ' -f2-)

        set epoch_seconds (eval $blame_cmd | grep "^author-time " | cut -d ' ' -f2)
        set date (/bin/date -j -f %s $epoch_seconds "+%d.%m.%Y, %H:%M")

        set commit_msg (git --no-pager log -1 --pretty=format:"%s" $commit_hash)
    end

    echo "👤 $author_name • 📅 $date • 󰘬 $commit_msg"
end
