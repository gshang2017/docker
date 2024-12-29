#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

user_id_exists() {
    [ -f /etc/passwd ] && cat /etc/passwd | cut -d':' -f3 | grep -q "^$1\$"
}

user_name_exists() {
    [ -f /etc/passwd ] && cat /etc/passwd | cut -d':' -f1 | grep -q "^$1\$"
}

group_id_exists() {
    [ -f /etc/group ] && cat /etc/group | cut -d':' -f3 | grep -q "^$1\$"
}

group_name_exists() {
    [ -f /etc/group ] && cat /etc/group | cut -d':' -f1 | grep -q "^$1\$"
}

get_group_name_from_group_id() {
    if [ -f /etc/group ]; then
        cat /etc/group | grep ":x:$1:" | head -n1 | cut -d':' -f1
    fi
}

add_group() {
    DUPLICATE_CHECK=true
    if [ "$1" = "--allow-duplicate" ]; then
        DUPLICATE_CHECK=false
        shift
    fi

    NAME="$1"
    GID="$2"

    if $DUPLICATE_CHECK && group_id_exists "$GID"; then
        echo "ERROR: group ID '$GID' already exists."
        return 1
    elif $DUPLICATE_CHECK && group_name_exists "$NAME"; then
        echo "ERROR: group '$NAME' already exists."
        return 1
    fi

    echo "$NAME:x:$GID:" >> /etc/group
}

add_user() {
    DUPLICATE_CHECK=true
    if [ "$1" = "--allow-duplicate" ]; then
        DUPLICATE_CHECK=false
        shift
    fi

    NAME="$1"
    UID="$2"
    GID="$3"
    HOMEDIR="${4:-/dev/null}"

    if $DUPLICATE_CHECK && user_id_exists "$UID"; then
        echo "ERROR: user ID '$UID' already exists."
        return 1
    elif $DUPLICATE_CHECK && user_name_exists "$NAME"; then
        echo "ERROR: user '$NAME' already exists."
        return 1
    elif ! group_id_exists "$GID"; then
        echo "ERROR: group ID '$GID' doesn't exist."
        return 1
    fi

    # Add the user to '/etc/passwd'.
    echo "$NAME::$UID:$GID::$HOMEDIR:/sbin/nologin" >> /etc/passwd

    # Add a corresponding entry to '/etc/shadow'.
    echo "$NAME:!::0:::::" >> /etc/shadow
}

add_user_to_group() {
    UNAME="$1"
    GNAME="$2"

    if ! user_name_exists "$UNAME"; then
        echo "ERROR: user '$UNAME' doesn't exists."
        exit 1
    elif ! group_name_exists "$GNAME"; then
        echo "ERROR: group '$GNAME' doesn't exists."
        exit 1
    fi

    if cat /etc/group | grep -q "^$GNAME:.*:$"; then
        sed-patch "/^$GNAME:/ s/$/$UNAME/" /etc/group
    else
        sed-patch "/^$GNAME:/ s/$/,$UNAME/" /etc/group
    fi
}

# Initialize files.
cp -f /etc/bak.passwd /etc/passwd
cp -f /etc/bak.group /etc/group
cp -f /etc/bak.shadow /etc/shadow

# Add the 'root' user.
#add_group root 0
#add_user root 0 0 /root
#add_user_to_group root root

# Add the 'shadow' group.
#add_group shadow 42

# Ubuntu and debian require additional user/group for proper packages
# installation.
. /etc/os-release
case "$ID" in
    ubuntu|debian)
        # Add the 'staff' group.
        add_group staff 52

        # Add the 'nogroup' group.
        add_group nogroup  65534

        # Add the '_apt' user.
        add_user _apt 105 65534 /nonexistent
        ;;
    *) break ;;
esac

# Add the 'app' user.
# NOTE: This user requires special handling, since its user/group ID is
#       configurable and may match an existing one.
add_group --allow-duplicate app "$GROUP_ID"
add_user --allow-duplicate app "$USER_ID" "$GROUP_ID"
add_user_to_group app app

# Handle supplementary groups of user 'app'.
echo ${SUP_GROUP_IDS:-},${SUP_GROUP_IDS_INTERNAL:-} | tr ',' '\n' | grep -v '^$' | grep -v '^0$' | grep -vw "$GROUP_ID" | sort -nub | while read GID
do
    case "$GID" in
        (*[!0-9]*)
            echo "ERROR: SUP_GROUP_IDS contains invalid groupd ID '$GID'."
            exit 1;
            ;;
    esac
    if ! group_id_exists "$GID"; then
        add_group "grp$GID" "$GID"
        add_user_to_group app "grp$GID"
    else
        add_user_to_group app "$(get_group_name_from_group_id "$GID")"
    fi
done

# Finally, set correct permissions on files.
chmod 644 /etc/passwd
chmod 644 /etc/group
chown root:shadow /etc/shadow
chmod 644 /etc/shadow

# vim:ft=sh:ts=4:sw=4:et:sts=4
