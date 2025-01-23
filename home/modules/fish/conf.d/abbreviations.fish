# https://fishshell.com/docs/current/cmds/abbr.html

# NPM
abbr --add nr  'pnpm'
abbr --add nit 'pnpm init'
abbr --add ni  'pnpm install'
abbr --add nb  'pnpm build'
abbr --add nc  'pnpm compile'
abbr --add nd  'pnpm dev'
abbr --add nst 'pnpm start'
abbr --add nt  'pnpm test'
abbr --add nti 'pnpm test:integration'
abbr --add nv  'pnpm --version'

# Misc
abbr --add cb     'fish_clipboard_copy'
abbr --add cpuuid 'uuidgen | fish_clipboard_copy'
abbr --add gw    './gradlew'
abbr --add jps    'jps -lm'
abbr --add loc    'tokei'
abbr --add lt     'ls --tree --level 3'
abbr --add reload 'exec fish'
abbr --add utcnow 'date -u +%Y-%m-%dT%H:%M:%SZ'
abbr --add ya     'yazi'
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'
