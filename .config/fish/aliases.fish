function cpu
  sysctl -n machdep.cpu.brand_string
end

function ip
  dig +short myip.opendns.com @resolver1.opendns.com
end

function battery
  pmset -g batt | egrep "([0-9]+\%).*" -o --colour=auto | cut -f1 -d';'
  pmset -g batt | egrep "([0-9]+\%).*" -o --colour=auto | cut -f3 -d';'
end

alias uuidgen 'uuidgen | tr "[:upper:]" "[:lower:]"'
