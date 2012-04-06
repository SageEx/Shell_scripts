#! /bin/dash

{
    if [ $# -gt 0 ] ; then
        window_ids=$(xdotool search --desktop "$@" --class .)
    else
        window_ids=$(xdotool search --class .)
    fi

    for wid in $window_ids ; do
        desk=$(xprop _NET_WM_DESKTOP -id "$wid" | grep '= [0-9]$' | sed 's/= //')
        if [ -n "$desk" ] ; then
            echo $(xprop -notype -f WM_CLASS 8s ' $0 $1 ' WM_CLASS WM_NAME -id "$wid" | sed 's/^[^"]\+"\([^"]\+\)"[^"]\+"\([^"]\+\)"[^"]\+"\([^"]\+\)"/\2\/\1: \3/') "($wid)"
        fi
    done
} | dmenu_select | sed 's/.*(\([0-9]\+\))$/\1/' | {
    read wid
    if [ -n "$wid" ] ; then
        xdotool windowactivate "$wid"
    fi
}