#!/bin/bash
#
# Make system more personal

# Configuration variables, true=enable.
#centos=true
ubuntu=true
install_pack=true
apply_vim_settings=true
apply_vimdiff_colors=true

# Function to install tmux, vim
install_pack() {
  local os_install_command=""

  if [[ "${ubuntu}" == "true" ]]; then
    os_install_command="apt"
  else
    os_install_command="yum"
  fi
  if [[ -n "${os_install_command}" ]]; then
    sudo ${os_install_command} install tmux vim git wget -y
  fi

  # Increase the history log for tmux
  echo "set-option -g history-limit 50000" > /root/.tmux.conf
  tmux source-file /root/.tmux.conf 2>/dev/null
}

# Function to apply Vim settings
apply_vim_settings() {
  VIMRC_PATH="/etc/vim/vimrc"

  cat <<EOL >> "${VIMRC_PATH}"
set cursorline

" Color configuration - A.W.L.
set bg=dark
color evening  " Same as :colorscheme evening
hi LineNr cterm=bold ctermfg=DarkGrey ctermbg=NONE
hi CursorLineNr cterm=bold ctermfg=Green ctermbg=NONE
EOL
}

# Function to apply Vimdiff colors
apply_vimdiff_colors() {
  COLO_NAME="bla"
  COLO_FILENAME="${COLO_NAME}.vim"

  # Function to find vim colors directory
  find_vim_colors() {
    local vim_dirs=($(find /usr -type d -name "vim[0-9]*" 2>/dev/null))

    for dir in "${vim_dirs[@]}"; do
      if [[ -d "${dir}/colors" ]]; then
        echo "${dir}/colors"
        return 0
      fi
    done
    echo "Error: Unable to find Vim colors directory" >&2
    return 1
  }

  local COLO_PATH=$(find_vim_colors)

  if [[ -z "${COLO_PATH}" ]]; then
    exit 1
  fi
  cat << EOF > "${COLO_PATH}/${COLO_FILENAME}"
" Re-writer: A.W.L.
hi clear Normal
set bg&
hi clear
if exists("syntax_on")
syntax reset
endif
let colors_name = "${COLO_NAME}"
highlight DiffAdd    cterm=bold ctermfg=black ctermbg=grey gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=black ctermbg=grey gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=black ctermbg=grey gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=black ctermbg=darkred gui=none guifg=bg guibg=Red
EOF
}

# Print the tasks name and execute the task from Main function
execute_task() {
  if [[ "${1}" == "true" ]]; then
    echo "*"
    echo "* ${2}"
    echo "********************"
    shift 2
    "${@}"
  fi
}

# Main function
execute_task "${install_pack}" "Install packages ..." install_pack
execute_task "${apply_vim_settings}" "Modify vim settings ..." apply_vim_settings
execute_task "${apply_vimdiff_colors}" "Add vimddiff colors ..." apply_vimdiff_colors
