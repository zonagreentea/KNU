
cat > knu.zsh <<'KNU'
#!/bin/zsh
# KNU — Kernel Names Unix
# One file. Four public operations. No third-party dependencies.
#
# connect HOST PORT       Connect to a TCP peer.
# connect --listen PORT   Listen for and accept one TCP peer.
# send TEXT               Send one newline-framed text message.
# read                    Receive one newline-framed text message.
# disconnect              Close the active connection.
#
# This is a user-space communication core, not a bootable OS kernel.
# Initial transport: TCP. Initial wire format: newline-framed text.
# TCP is unencrypted here. Do not use this prototype for sensitive data.

emulate -LR zsh

typeset -gi KNU_FD=-1
typeset -gi KNU_LISTEN_FD=-1
typeset -g KNU_PEER=''

connect() {
    emulate -L zsh

    if (( $# == 2 )) && [[ $1 == --listen ]]; then
        local port=$2

        if [[ $port != <-> ]] || (( port < 1 || port > 65535 )); then
            print -u2 -r -- 'KNU: invalid port'
            return 2
        fi

        if (( KNU_FD >= 0 || KNU_LISTEN_FD >= 0 )); then
            print -u2 -r -- 'KNU: disconnect first'
            return 1
        fi

        zmodload zsh/net/tcp || return 1

        if ! ztcp -l "$port"; then
            print -u2 -r -- 'KNU: listen failed'
            return 1
        fi

        KNU_LISTEN_FD=$REPLY
        print -u2 -r -- "KNU: listening on port $port"

        if ! ztcp -a "$KNU_LISTEN_FD"; then
            ztcp -c "$KNU_LISTEN_FD" 2>/dev/null
            KNU_LISTEN_FD=-1
            print -u2 -r -- 'KNU: accept failed'
            return 1
        fi

        KNU_FD=$REPLY
        ztcp -c "$KNU_LISTEN_FD" 2>/dev/null
        KNU_LISTEN_FD=-1
        KNU_PEER="accepted:$port"
        print -u2 -r -- 'KNU: peer connected'
        return 0
    fi

    if (( $# != 2 )); then
        print -u2 -r -- 'Usage: connect HOST PORT | connect --listen PORT'
        return 2
    fi

    if (( KNU_FD >= 0 || KNU_LISTEN_FD >= 0 )); then
        print -u2 -r -- 'KNU: disconnect first'
        return 1
    fi

    local host=$1 port=$2

    if [[ -z $host || $port != <-> ]] ||
       (( port < 1 || port > 65535 )); then
        print -u2 -r -- 'KNU: invalid host or port'
        return 2
    fi

    zmodload zsh/net/tcp || return 1

    if ! ztcp "$host" "$port"; then
        print -u2 -r -- "KNU: connection to $host:$port failed"
        return 1
    fi

    KNU_FD=$REPLY
    KNU_PEER="$host:$port"
    print -u2 -r -- "KNU: connected to $KNU_PEER"
}

disconnect() {
    emulate -L zsh
    local failed=0

    if (( KNU_FD >= 0 )); then
        ztcp -c "$KNU_FD" 2>/dev/null || failed=1
        KNU_FD=-1
    fi

    if (( KNU_LISTEN_FD >= 0 )); then
        ztcp -c "$KNU_LISTEN_FD" 2>/dev/null || failed=1
        KNU_LISTEN_FD=-1
    fi

    KNU_PEER=''

    if (( failed )); then
        print -u2 -r -- 'KNU: a descriptor reported an error'
        return 1
    fi

    print -u2 -r -- 'KNU: disconnected'
}

send() {
    emulate -L zsh

    if (( KNU_FD < 0 )); then
        print -u2 -r -- 'KNU: not connected'
        return 1
    fi

    if (( $# == 0 )); then
        print -u2 -r -- 'Usage: send TEXT'
        return 2
    fi

    local payload="$*"

    if [[ $payload == *$'\n'* || $payload == *$'\r'* ]]; then
        print -u2 -r -- 'KNU: messages must fit on one line'
        return 2
    fi

    if ! print -r -u "$KNU_FD" -- "$payload"; then
        print -u2 -r -- 'KNU: send failed'
        return 1
    fi
}

read() {
    emulate -L zsh

    if (( KNU_FD < 0 )); then
        print -u2 -r -- 'KNU: not connected'
        return 1
    fi

    local message

    if builtin read -r -u "$KNU_FD" message; then
        print -r -- "$message"
        return 0
    fi

    print -u2 -r -- 'KNU: peer closed the stream or read failed'
    return 1
}

_knu_help() {
    print -r -- 'KNU — Kernel Names Unix'
    print -r -- 'connect HOST PORT'
    print -r -- 'connect --listen PORT'
    print -r -- 'send TEXT'
    print -r -- 'read'
    print -r -- 'disconnect'
    print -r -- 'help'
    print -r -- 'quit'
}

_knu_prompt() {
    emulate -L zsh
    local line op rest
    local -a words

    _knu_help

    while true; do
        print -n -r -- 'knu> '

        if ! builtin read -r line; then
            print
            break
        fi

        [[ -z $line ]] && continue

        op=${line%%[[:space:]]*}

        if [[ $line == *[[:space:]]* ]]; then
            rest=${line#*[[:space:]]}
        else
            rest=''
        fi

        case $op in
            connect)
                words=(${(z)rest})
                connect "${words[@]}"
                ;;
            disconnect)
                disconnect
                ;;
            send)
                send "$rest"
                ;;
            read)
                read
                ;;
            help)
                _knu_help
                ;;
            quit|exit)
                disconnect
                break
                ;;
            *)
                print -u2 -r -- 'KNU: unknown operation; type help'
                ;;
        esac
    done
}

if [[ ${ZSH_EVAL_CONTEXT:-} == toplevel ]]; then
    if (( $# )); then
        case $1 in
            connect) shift; connect "$@" ;;
            disconnect) disconnect ;;
            send) shift; send "$@" ;;
            read) read ;;
            help|-h|--help) _knu_help ;;
            *)
                print -u2 -r -- 'Usage: knu.zsh [connect|disconnect|send|read|help]'
                exit 2
                ;;
        esac
    else
        _knu_prompt
    fi
fi
KNU
chmod +x knu.zsh
