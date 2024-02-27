#!/usr/bin/env bash
# set -e

echo "======================================================"
echo " Torizon Plugin Installer for apt-based distributions "
echo "======================================================"
echo '                                                    '
echo '                      ******,                       '      
echo '                   ************                     '      
echo '              *****    ****,     ***                '      
echo '          ************,      .**********            '      
echo '      **     *******          *********             '      
echo '  .*********          ((((((((    *.     *******    '      
echo '  **********        /(((((((((((      ************* '      
echo '      **.     *****.    ((((      ****    *****     '      
echo '           ************       ************          '      
echo ' %%%          ******      *     ********       &%%% '      
echo '  *%%%%%              *********             %%%%%   '      
echo '      %%%%%%         ***********        %%%%%     . '      
echo ' ***      %%%%%&         ***        %%%%%.     **** '      
echo '   *****      %%%%%.            %%%%%%     ******   '      
echo '      .*****      %%%%%     %%%%%%      *****       '      
echo '          ******     .%%%%%%%%      *****           '      
echo '              ******            *****               '      
echo '                  *****     ******                  '      
echo '                      ********                      '      
echo '                                                    '      

echo "You will be prompted for your password by sudo."

curl=$(which curl)
gpg=$(which gpg)

if [ ! "$curl" ] && [ ! "$gpg" ] ; then
    echo "Please install curl and gpg with apt-get install -y curl gpg"
    echo "You might need to executed apt-get update before apt-get install"
    exit 1
fi

if [ ! "$curl" ] ; then
    echo "Please install curl with apt-get install -y curl and re-run the script"
    echo "You might need to executed apt-get update before apt-get install"
    exit 1
fi

if [ ! "$gpg" ] ; then
    echo "Please install gpg with apt-get install -y gpg and re-run the script"
    echo "You might need to executed apt-get update before apt-get install"
    exit 1
fi

# Determine package type to install: https://unix.stackexchange.com/a/6348
# OS used by all - for Debs it must be Ubuntu or Debian
# CODENAME only used for Debs
if [ -f /etc/os-release ]; then
    # Debian uses Dash which does not support source
    # shellcheck source=/dev/null
    . /etc/os-release
    OS=$( echo "${ID}" | tr '[:upper:]' '[:lower:]')
    CODENAME=$( echo "${VERSION_CODENAME}" | tr '[:upper:]' '[:lower:]')
elif lsb_release &>/dev/null; then
    OS=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
    CODENAME=$(lsb_release -cs)
else
    OS=$(uname -s)
fi

SUDO=sudo
if [ "$(id -u)" -eq 0 ]; then
    SUDO=''
else
    # Clear any previous sudo permission
    sudo -k
fi

case ${OS} in
    ubuntu|debian)
        $SUDO sh <<SCRIPT
export DEBIAN_FRONTEND=noninteractive
mkdir -p /usr/share/keyrings/  

case ${CODENAME} in
    jammy)
        curl https://feeds.toradex.com/staging/${OS}/toradex-debian-repo-19092023.asc | gpg --dearmor > /usr/share/keyrings/toradex.gpg
        cat > /etc/apt/sources.list.d/toradex.list <<EOF
deb [signed-by=/usr/share/keyrings/toradex.gpg] https://feeds.toradex.com/staging/${OS}/ ${CODENAME} main
EOF
        cat /etc/apt/sources.list.d/toradex.list
        apt-get -y update
        apt-get -y install aktualizr-torizon
        ;;

    focal)
        curl https://feeds.toradex.com/staging/${OS}/toradex-debian-repo-19092023.asc | gpg --dearmor > /usr/share/keyrings/toradex.gpg
        cat > /etc/apt/sources.list.d/toradex.list <<EOF
deb [signed-by=/usr/share/keyrings/toradex.gpg] https://feeds.toradex.com/staging/${OS}/ ${CODENAME} main
EOF
        cat /etc/apt/sources.list.d/toradex.list
        apt-get -y update
        apt-get -y install aktualizr-torizon
        ;;

    trixie)
        curl https://feeds.toradex.com/staging/${OS}/toradex-debian-repo-19092023.asc | gpg --dearmor > /usr/share/keyrings/toradex.gpg
        cat > /etc/apt/sources.list.d/toradex.list <<EOF
deb [signed-by=/usr/share/keyrings/toradex.gpg] https://feeds.toradex.com/staging/${OS}/ ${CODENAME} main
EOF
        cat /etc/apt/sources.list.d/toradex.list
        apt-get -y update
        apt-get -y install aktualizr-torizon
        ;;

    bookworm)
        curl https://feeds.toradex.com/staging/${OS}/toradex-debian-repo-19092023.asc | gpg --dearmor > /usr/share/keyrings/toradex.gpg
        cat > /etc/apt/sources.list.d/toradex.list <<EOF
deb [signed-by=/usr/share/keyrings/toradex.gpg] https://feeds.toradex.com/staging/${OS}/ ${CODENAME} main
EOF
        cat /etc/apt/sources.list.d/toradex.list
        apt-get -y update
        apt-get -y install aktualizr-torizon
        ;;

    *)
        echo "Unsupported release: ${CODENAME} for ${OS}."
        exit 1
        ;;
esac

SCRIPT
    ;;
    *)
        echo "${OS} not supported."
        exit 1
    ;;    
esac

echo ""
echo "Installation completed! ⭐"
echo "Go to app.torizon.io and provision the device!"
echo "https://developer.toradex.com/torizon/torizon-platform/devices-fleet-management/#provisioning-a-single-device"
echo ""
