#!/bin/bash

prep_term()
{
    unset term_child_pid
    unset term_kill_needed
    trap 'handle_term' TERM INT
}

handle_term()
{
    if [ "${term_child_pid}" ]; then
	echo "sigterm caught"
        #kill -TERM "${term_child_pid}" 2>/dev/null
	screen -S terra -p 0 -X stuff "exit^M"
    else
        term_kill_needed="yes"
    fi
}

wait_term()
{
    term_child_pid=$!
    if [ "${term_kill_needed}" ]; then
        kill -TERM "${term_child_pid}" 2>/dev/null 
    fi
    wait ${term_child_pid} 2>/dev/null
    trap - TERM INT
    wait ${term_child_pid} 2>/dev/null
}

if [ ! -f "/config/serverconfig.txt" ]; then
    cp ./serverconfig.default /config/serverconfig.txt
fi

if [ ! -f "/config/banlist.txt" ]; then
    touch /config/banlist.txt
fi

chmod -R g+w /config

echo "Prep Term"
prep_term

screen -mS terra ./TerrariaServer -x64 -config /config/serverconfig.txt -banlist /config/banlist.txt $@

echo "Wait Term"
wait_term
