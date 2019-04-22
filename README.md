![image](https://user-images.githubusercontent.com/34389545/56409412-8f1c4600-623e-11e9-961b-ed57382df370.png)

# Domain system for .trtl TLD
![image](https://img.shields.io/discord/388915017187328002.svg?label=TRTL%20Discord%20&style=popout-square)  
Join us on [Discord](http://chat.turtlecoin.lol)

This repo holds the DNS config for Bind9 serving the .trtl TLD. New domains should follow the format in the config.

# Applying for a domain
[Fill out the form here](https://github.com/turtlecoin/.trtl/issues/new?assignees=&labels=REQUEST&template=-trtl-tld-domain-application.md&title=%5BREQUEST%5D+YourDomainHere.trtl) to apply for a domain.

# What to do after creating your application
Domains are added by pull-request only when the associated application has been approved. All pull requests for adding a domain require a link to an approved application.

To add your domain, fill in the information marked below in alphabetical order.

``` 
;
; BIND data file for TLD ".trtl"
;
$TTL      604800    ; (1 week)
trtl.         IN        SOA       trtl. root.trtl. (
2019042201          ; serial (timestamp)
604800              ; refresh (1 week)
86400               ; retry (1 day)
2419200             ; expire (28 days)
604800 )            ; minimum (1 week)
;

trtl.      IN        NS       ns1.trtl.
trtl.      IN        NS       ns2.trtl.

$ORIGIN trtl.
google    IN        A        8.8.8.8
ns1       IN        A       142.93.1.231
ns2       IN        A       104.248.57.4

; testing domain
edu       IN        A        188.166.7.218
extra     IN        A        142.93.21.48
```

# Domain Guidelines
Your domain must follow our guidelines laid out [here](https://github.com/turtlecoin/.trtl/issues/1)  
Additionally, it may not be any of the [reserved domains](https://github.com/turtlecoin/.trtl/issues/2)


## TODO

- [ ] domain contact crawlier for whois-like info. indexed from approved domain applications  
- [ ] repo monitor agent  
- [x] Mentioning domain guidelines
- [x] Issue templates for domain application and complaints

