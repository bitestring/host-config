# OpenWrt Configuration

## Installing packages

Refer [packages.sh](./packages.sh) to install required packages on OpenWrt.

## DNSCrypt Proxy (DoH, DoT)

https://github.com/DNSCrypt/dnscrypt-proxy/wiki/Installation-on-OpenWrt

## Ad blocking

https://openwrt.org/docs/guide-user/services/ad-blocking

-   Enable Reports
-   Force DNS (Redirect any outbound requests to port 53 to OpenWrt Adblock)
-   [Follow best practices for `adblock` package](https://github.com/openwrt/packages/blob/master/net/adblock/files/README.md)

## Guest WiFi

https://openwrt.org/docs/guide-user/network/wifi/guestwifi/guestwifi_dumbap

## Firewall

https://openwrt.org/docs/guide-user/firewall/start

-   `DROP` (instead of `REJECT`) packets on `wan` zone. This hides the presence of the host/router from malicious port scanners and lowers resource consumption.

## Security and Hardening

https://openwrt.org/docs/guide-user/security/start

-   [Enable TTY password](https://openwrt.org/docs/guide-user/security/openwrt_security?s[]=word#securing_tty_and_serial_console)

## Attended Sysupgrade

https://openwrt.org/docs/guide-user/installation/attended.sysupgrade

## Backup and Restore Configuration

https://openwrt.org/docs/guide-user/troubleshooting/backup_restore

# References

https://openwrt.org/
