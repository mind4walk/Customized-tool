#!/bin/bash
PATH_TO_VIMRC=/etc/vim/vimrc
COLO_NAME=bla

# Vim settings
cat <<EOL >> $PATH_TO_VIMRC
set cursorline

" Color configuration - albert 
set bg=dark
color evening  " Same as :colorscheme evening
hi LineNr cterm=bold ctermfg=DarkGrey ctermbg=NONE
hi CursorLineNr cterm=bold ctermfg=Green ctermbg=NONE
EOL

# Vimdiff colors
COLO_PATH=$(find / -type d -name "vim[0-9]*" 2>/dev/null -exec find {} -type d -name "colors" \;)
sleep 1
cat << EOF > $COLO_PATH/$COLO_NAME.vim
" Re-writer: A.W.L.
hi clear Normal
set bg&
hi clear
if exists("syntax_on")
syntax reset
endif
let colors_name = "$COLO_NAME"
highlight DiffAdd    cterm=bold ctermfg=black ctermbg=grey gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=black ctermbg=grey gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=black ctermbg=grey gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=black ctermbg=darkred gui=none guifg=bg guibg=Red
EOF
