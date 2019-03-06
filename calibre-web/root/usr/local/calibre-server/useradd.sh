#!/usr/bin/expect 

set USER [lindex $argv 0 ]
set PASSWORD [lindex $argv 1 ]
spawn calibre-server --userdb /srv/calibre/users.sqlite --manage-users 
expect "What do you want to do" 
send "1\r"
expect "Enter the username:"
send "$USER\r"
expect {
-re "Enter the username:" { exit }
-re "Enter the new password for" { exp_send "$PASSWORD\r"; exp_continue} 
-re "to verify:" { exp_send "$PASSWORD\r"; exp_continue}
-re "successfully!" { exit }
}
expect eof
