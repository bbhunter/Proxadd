# Proxadd ![Language](https://img.shields.io/badge/Language-Ruby-red.svg?longCache=true&style=flat-square)   ![License](https://img.shields.io/badge/License-MIT-green.svg?longCache=true&style=flat-square)

Proxadd is a dead-simple script that pulls proxy entries from [proxy-list API](https://www.proxy-list.download/api/v1) and adds them to Proxychains configuration file.

## Table of Contents
- [Requirements](#requirements)
- [Usage](#usage)
- [License](#license)


## Requirements
Proxadd requires following gems:
- optparse
- httparty
- colorize


## Usage

```
Usage: proxadd.rb [-h] [-o] [-s] [-t TYPE] [-n NUMBER] [-c CODE] [-a ANON] [-f CONFIG]
    -t, --type TYPE                  Select proxies type to query [*http|https|socks4|socks5]
    -n, --number NUMBER              Number of proxies to add to proxychains config
    -c, --country-code CODE          Filter proxies by country code
    -a, --anon ANON                  Filter by anonimity level [transparent|anonymous|elite]
    -f, --config-file CONFIG         Path of the Proxychains config file to append proxies to (default: /etc/proxychains.conf)
    -o, --stdout                     Print proxies to SDTOUT instead of writing to config file
    -s, --shuffle                    Shuffle proxy list before adding to Proxychains config
    -h, --help                       Print help message
```


## License
This software is under [MIT License](https://en.wikipedia.org/wiki/MIT_License)
