#!/usr/bin/expect

set CALIBRE_SERVER_USER [lindex $argv 0 ]
set CALIBRE_SERVER_PASSWORD [lindex $argv 1 ]
spawn calibre-server --userdb /config/calibre-server/calibre/server-users.sqlite --manage-users
expect "What do you want to do"
send "1\r"
expect "Enter the username:"
send "$CALIBRE_SERVER_USER\r"
expect {
-re "already exists" { exit }
-re "Enter the username:" { exit }
-re "Enter the new password for" { exp_send "$CALIBRE_SERVER_PASSWORD\r"; exp_continue}
-re "to verify:" { exp_send "$CALIBRE_SERVER_PASSWORD\r"; exp_continue}
-re "successfully!" { exit }
}
expect eof
