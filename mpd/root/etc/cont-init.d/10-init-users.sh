#!/bin/sh
#
# Initialize Linux users and groups, by (re)writing /etc/passwd, /etc/group and
# /etc/shadow.
#

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

err() {
    echo "ERROR: $*" >&2
}

user_id_exists() {
    [ -f /etc/passwd ] && cut -d':' -f3 < /etc/passwd | grep -q "^$1\$"
}

user_name_exists() {
    [ -f /etc/passwd ] && cut -d':' -f1 < /etc/passwd | grep -q "^$1\$"
}

group_id_exists() {
    [ -f /etc/group ] && cut -d':' -f3 < /etc/group | grep -q "^$1\$"
}

group_name_exists() {
    [ -f /etc/group ] && cut -d':' -f1 < /etc/group | grep -q "^$1\$"
}

get_group_name_from_group_id() {
    if [ -f /etc/group ]; then
        grep ":x:$1:" /etc/group | head -n1 | cut -d':' -f1
    fi
}

add_group() {
    duplicate_check=true
    if [ "$1" = "--allow-duplicate" ]; then
        duplicate_check=false
        shift
    fi

    name="$1"
    gid="$2"

    if ${duplicate_check} && group_id_exists "${gid}"; then
        err "group ID '${gid}' already exists."
        return 1
    elif ${duplicate_check} && group_name_exists "${name}"; then
        err "group '${name}' already exists."
        return 1
    fi

    echo "${name}:x:${gid}:" >> /etc/group
}

add_user() {
    duplicate_check=true
    if [ "$1" = "--allow-duplicate" ]; then
        duplicate_check=false
        shift
    fi

    name="$1"
    uid="$2"
    gid="$3"
    homedir="${4:-/dev/null}"

    if ${duplicate_check} && user_id_exists "${uid}"; then
        err "user ID '${uid}' already exists."
        return 1
    elif ${duplicate_check} && user_name_exists "${name}"; then
        err "user '${name}' already exists."
        return 1
    elif ! group_id_exists "${gid}"; then
        err "group ID '${gid}' doesn't exist."
        return 1
    fi

    # Add the user to '/etc/passwd'.
    echo "${name}::${uid}:${gid}::${homedir}:/sbin/nologin" >> /etc/passwd

    # Add a corresponding entry to '/etc/shadow'.
    echo "${name}:!::0:::::" >> /etc/shadow
}

add_user_to_group() {
    uname="$1"
    gname="$2"

    if ! user_name_exists "${uname}"; then
        err "user '${uname}' doesn't exists."
        exit 1
    elif ! group_name_exists "${gname}"; then
        err "group '${gname}' doesn't exists."
        exit 1
    fi

    if grep -q "^${gname}:.*:$" /etc/group; then
        sed-patch "/^${gname}:/ s/$/${uname}/" /etc/group
    else
        sed-patch "/^${gname}:/ s/$/,${uname}/" /etc/group
    fi
}

# Initialize files.
#rm -f /etc/passwd /etc/group /etc/shadow
#touch /etc/passwd /etc/group /etc/shadow
cp -f /etc/bak.passwd /etc/passwd
cp -f /etc/bak.group /etc/group
cp -f /etc/bak.shadow /etc/shadow

# Add the 'root' user.
#add_group root 0
#add_user root 0 0 /root
#add_user_to_group root root

# Add the 'shadow' group.
#add_group shadow 42

# Add the 'cinit' group.
add_group cinit 72

# Ubuntu and debian require additional user/group for proper packages
# installation.
. /etc/os-release
case "${ID}" in
    ubuntu | debian)
        # Add the 'staff' group.
        add_group staff 52

        # Add the 'nogroup' group.
        add_group nogroup 65534

        # Add the '_apt' user.
        add_user _apt 105 65534 /nonexistent
        ;;
    *) ;;
esac

# Add the 'app' user.
# NOTE: This user requires special handling, since its user/group ID is
#       configurable and may match an existing one.
add_group --allow-duplicate app "${GROUP_ID}"
add_user --allow-duplicate app "${USER_ID}" "${GROUP_ID}"
add_user_to_group app app

# Handle supplementary groups of user 'app'.
echo "${SUP_GROUP_IDS:-},${SUP_GROUP_IDS_INTERNAL:-}" \
    | tr ',' '\n' \
    | grep -v '^$' \
    | grep -v '^0$' \
    | grep -vw "${GROUP_ID}" \
    | sort -nub \
    | while read -r gid; do
        case "${gid}" in
            '' | *[!0-9]*)
                err "SUP_GROUP_IDS contains invalid groupd ID '${gid}'."
                exit 1
                ;;
        esac
        if ! group_id_exists "${gid}"; then
            add_group "grp${gid}" "${gid}"
            add_user_to_group app "grp${gid}"
        else
            add_user_to_group app "$(get_group_name_from_group_id "${gid}")"
        fi
    done

# Finally, set correct permissions on files.
chmod 644 /etc/passwd
chmod 644 /etc/group
chown root:shadow /etc/shadow
chmod 644 /etc/shadow

# vim:ft=sh:ts=4:sw=4:et:sts=4
