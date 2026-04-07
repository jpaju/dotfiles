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
abbr --add loc              'tokei --num-format underscores'
abbr --add lt               'ls --tree --level 3'
abbr --add reload           'exec fish'
abbr --add rl               'exec fish'
abbr --add utcnow           'date -u +%Y-%m-%dT%H:%M:%SZ'
