if status --is-login
    set -x EDITOR /usr/bin/nvim
    set -x PYTHONDONTWRITEBYTECODE 1
    set -x VOLTPATH $HOME/.vim/volt

    if test -d $HOME/.poetry/bin
        set -x PATH $PATH $HOME/.poetry/bin
    end

    direnv hook fish | source
end

alias pass gopass
alias ip "dig +short myip.opendns.com @resolver1.opendns.com"
alias cpu "sysctl -n machdep.cpu.brand_string"
alias uuidgen 'uuidgen | tr "[:upper:]" "[:lower:]"'

function battery
    pmset -g batt | egrep "([0-9]+\%).*" -o --colour=auto | cut -f1 -d';'
    pmset -g batt | egrep "([0-9]+\%).*" -o --colour=auto | cut -f3 -d';'
end
