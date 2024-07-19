# https://fishshell.com/docs/current/cmds/abbr.html

# NPM
abbr --add nr  'npm run'
abbr --add nit 'npm init'
abbr --add ni  'npm install'
abbr --add nb  'npm run build'
abbr --add nc  'npm run compile'
abbr --add nd  'npm run dev'
abbr --add nst 'npm run start'
abbr --add nt  'npm run test'
abbr --add nti 'npm run test:integration'
abbr --add nv  'npm --version'

# Misc
abbr --add cb     'fish_clipboard_copy'
abbr --add cpuuid 'uuidgen | fish_clipboard_copy'
abbr --add jps    'jps -lm'
abbr --add loc    'tokei'
abbr --add lt     'ls --tree --level 3'
abbr --add reload 'exec fish'
abbr --add utcnow 'date -u +%Y-%m-%dT%H:%M:%SZ'
abbr --add ya     'yazi'
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'
