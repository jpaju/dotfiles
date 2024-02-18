# Load function descriptions to show them in auto-completion
# This is a workaround until the following issue is resolved: https://github.com/fish-shell/fish-shell/issues/328
# Stole from this comment: https://github.com/fish-shell/fish-shell/issues/1915#issuecomment-72315918
for i in (functions);functions $i > /dev/null;end
