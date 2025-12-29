# https://fishshell.com/docs/current/cmds/abbr.html

# NPM
abbr --add nr  'pnpm run'
abbr --add nit 'pnpm init'
abbr --add ni  'pnpm install'
abbr --add nb  'pnpm run build'
abbr --add nc  'pnpm run compile'
abbr --add nd  'pnpm run dev'
abbr --add nst 'pnpm run start'
abbr --add nt  'pnpm run test'
abbr --add nti 'pnpm run test:integration'
abbr --add nv  'pnpm --version'

# Misc
abbr --add cb     'fish_clipboard_copy'
abbr --add cpuuid 'uuidgen | fish_clipboard_copy'
abbr --add gw     './gradlew'
abbr --add gwf    './gradlew ktlintFormat'
abbr --add gwt    './gradlew test --tests "**"'
abbr --add gwta   './gradlew test'
abbr --add jps    'jps -lm'
abbr --add loc    'tokei --num-format underscores'
abbr --add lt     'ls --tree --level 3'
abbr --add reload 'exec fish'
abbr --add utcnow 'date -u +%Y-%m-%dT%H:%M:%SZ'
abbr --add ya     'yazi'
alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'
