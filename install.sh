DRIVE='/dev/nvme0n1'
DRIVE_PASSPHRASE='drivepassword'
ROOT_PASSWORD='rootpassword'
USER_NAME='user'
USER_PASSWORD='userpassword'
TIMEZONE='Iran'
WIRELESS='wlan0'
WIFI_PASSWORD='wifipassword'
WIFI_SSID='wifi'

network_config() {
    iwctl
        station "$WIRELESS" scan
        station "$WIRELESS" connect "$WIFI_SSID"
        if [ -z "$WIFI_PASSWORD" ]
        then
            echo 'Enter the WiFi password:'
            stty -echo
            read WIFI_PASSWORD
            stty echo
        fi
        echo "$WIFI_PASSWORD"
}