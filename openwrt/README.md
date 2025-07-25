# OpenWrt Configuration

## Firmware Selector

https://firmware-selector.openwrt.org/

## Installing packages

Refer [packages.sh](./packages.sh) to install required packages on OpenWrt.

## zram-swap

Install package `zram-swap` to activate compressed in-memory swap on routers with less memory.

## Guest WiFi

https://openwrt.org/docs/guide-user/network/wifi/guestwifi/start
https://openwrt.org/docs/guide-user/network/wifi/guestwifi/guestwifi_dumbap

Use separate VLANs to isolate untrusted devices.

## USB Storage

https://openwrt.org/docs/guide-user/storage/usb-drives-quickstart

Store configs, logs and other static data in USB drive to lessen wear & tear on router flash storage.

## DNS Encryption (DNSCrypt, DoH, DoT)

https://openwrt.org/docs/guide-user/services/dns/start

### dnscrypt-proxy

https://github.com/DNSCrypt/dnscrypt-proxy/wiki/Installation-on-OpenWrt

#### Quad9 Configuration for dnscrypt-proxy

https://github.com/Quad9DNS/dnscrypt-settings

## Ad blocking

https://openwrt.org/docs/guide-user/services/ad-blocking

-   Enable Feeds
-   Enable Reports
-   Force DNS (Redirect any outbound requests to port 53 to OpenWrt Adblock)
-   [Follow best practices for `adblock` package](https://github.com/openwrt/packages/blob/master/net/adblock/files/README.md)
-   Set cron for auto refresh of the feeds
-   Configure backup to include Adblock directories

## IP blocking

https://openwrt.org/docs/guide-user/services/banip

-   Enable Feeds
-   [Follow best practices for `banIP` package] (https://github.com/openwrt/packages/blob/master/net/banip/files/README.md)
-   Set cron for auto refresh of the feeds
-   Configure backup to include banIP directories

## Firewall

https://openwrt.org/docs/guide-user/firewall/start

-   `DROP` (instead of `REJECT`) packets on `wan` zone. This lowers resource consumption of the host/router due to malicious port scanners.

## Security and Hardening

https://openwrt.org/docs/guide-user/security/start

-   [Enable TTY password](https://openwrt.org/docs/guide-user/security/openwrt_security?s[]=word#securing_tty_and_serial_console)

## Attended Sysupgrade

https://openwrt.org/docs/guide-user/installation/attended.sysupgrade

## Backup and Restore Configuration

https://openwrt.org/docs/guide-user/troubleshooting/backup_restore

# References

https://openwrt.org/
https://routersecurity.org/
