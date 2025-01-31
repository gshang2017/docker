#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

if [ ! -d $HOME/mpd ]; then
	mkdir -p $HOME/mpd
fi
if [ ! -f $HOME/mpd/mpd.conf ]; then
	cp -f /usr/local/mpd/mpd.conf $HOME/mpd/mpd.conf
  cat >> $HOME/mpd/mpd.conf << EOF
# Filters #####################################################################
filter {
        plugin "ffmpeg"
        name   "speed1.25"
        graph  "atempo=1.25"
}
filter {
        plugin "ffmpeg"
        name   "speed1.5"
        graph  "atempo=1.5"
}
filter {
        plugin "ffmpeg"
        name   "speed1.75"
        graph  "atempo=1.75"
}
filter {
        plugin "ffmpeg"
        name   "speed2"
        graph  "atempo=2"
}
filter {
        plugin "ffmpeg"
        name   "speed2.5"
        graph  "atempo=sqrt(2.5),atempo=sqrt(2.5)"
}
filter {
        plugin "ffmpeg"
        name   "speed3"
        graph  "atempo=sqrt(3),atempo=sqrt(3)"
}
###############################################################################
audio_output {
        type            "pulse"
        name            "Bluetooth"
        mixer_type      "software"
        enabled         "yes"
}

audio_output {
        type            "pulse"
        name            "Bluetooth(125%)"
        filters         "speed1.25"
        mixer_type      "software"
}
audio_output {
        type            "pulse"
        name            "Bluetooth(150%)"
        filters         "speed1.5"
        mixer_type      "software"
}
audio_output {
        type            "pulse"
        name            "Bluetooth(175%)"
        filters         "speed1.75"
        mixer_type      "software"
}
audio_output {
        type            "pulse"
        name            "Bluetooth(200%)"
        filters         "speed2"
        mixer_type      "software"
}
audio_output {
        type            "pulse"
        name            "Bluetooth(250%)"
        filters         "speed2.5"
        mixer_type      "software"
}
audio_output {
        type            "pulse"
        name            "Bluetooth(300%)"
        filters         "speed3"
        mixer_type      "software"
}
EOF
	sed -i s/"~\/.mpd"/"~\/mpd"/g $HOME/mpd/mpd.conf
	sed -i s/"#music_directory\t\t\"~\/music\""/"music_directory\t\t\"~\/music\""/g $HOME/mpd/mpd.conf
	sed -i s/"#playlist_directory"/"playlist_directory"/g $HOME/mpd/mpd.conf
	sed -i s/"#db_file"/"db_file"/g $HOME/mpd/mpd.conf
	sed -i s/"#pid_file"/"pid_file"/g $HOME/mpd/mpd.conf
	sed -i s/"#state_file"/"state_file"/g $HOME/mpd/mpd.conf
	sed -i s/"#sticker_file"/"sticker_file"/g $HOME/mpd/mpd.conf
	sed -i s/"user"/"#user"/g $HOME/mpd/mpd.conf
fi

if [ "$MPD_PORT" != "6600" ]; then
  if [ `grep -w "#port" $HOME/mpd/mpd.conf|wc -l` -eq 1 ]; then
    sed -i '/^\#port/d' $HOME/mpd/mpd.conf
  fi
  if [ `grep -w "^port" $HOME/mpd/mpd.conf|wc -l` -gt 0 ]; then
    sed -i '/^port/d' $HOME/mpd/mpd.conf
  fi
  sed -i '$a\port\t\t\t\t"'$MPD_PORT'"' $HOME/mpd/mpd.conf
fi

if [ ! -d $HOME/mpd/playlists ]; then
  mkdir -p $HOME/mpd/playlists
fi

if [ ! -d $HOME/music ]; then
  mkdir -p $HOME/music
	chown -R app:app $HOME/music
fi

chown -R app:app $HOME/mpd
chown -R app:app /usr/local/mpd
