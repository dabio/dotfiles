#if not begin
#    [ -f ~/.gnupg/agent-info ]
#    and kill -0 (cut -d: -f 2 ~/.gnupg/agent-info) ^/dev/null
#end
#
#/usr/local/opt/gpg2/bin/gpg-agent --daemon --no-grab --use-standard-socket --write-env-file ~/.gnupg/agent-info >/dev/null ^&1
#end
#
#set -g -x GPG_AGENT_INFO (cut -c 16- ~/.gnupg/agent-info)
set -g -x GPG_TTY (tty)

