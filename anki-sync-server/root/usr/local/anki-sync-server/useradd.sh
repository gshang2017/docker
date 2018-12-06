#!/usr/bin/expect 

set USER [lindex $argv 0 ]
set PASSWORD [lindex $argv 1 ]
spawn python3 /usr/local/anki-sync-server/ankisyncctl.py  adduser $USER
expect "Enter password for $USER:" {send "$PASSWORD\r"}                                         
expect eof
