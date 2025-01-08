#! /bin/bash

while inotifywait -e close -e modify $HOME/.config/joplin/log-clipper.txt; do
    inotifywait -m $HOME/.config/joplin/log-clipper.txt -t 60
    joplin sync
done
