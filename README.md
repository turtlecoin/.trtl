![image](https://user-images.githubusercontent.com/34389545/56409412-8f1c4600-623e-11e9-961b-ed57382df370.png)
Domain system for .trtl TLD
This repo holds the DNS config for Bind9 serving the .trtl TLD. New domains should follow the format in the config.

# Applying for a domain
[Fill out the form here](https://github.com/turtlecoin/.trtl/issues/new?assignees=&labels=REQUEST&template=-trtl-tld-domain-application.md&title=%5BREQUEST%5D+YourDomainHere.trtl) and wait patiently.

# Adding your domain
Domains are added by pull-request only when the associated application has been approved. All pull requests for adding a domain require a link to an approved application.

To add your domain, fill in the information marked below in alphabetical order.

``` 
;
; BIND data file for TLD ".trtl"
;
$TTL      604800    ; (1 week)
@         IN        SOA       trtl. root.trtl. (
2019042000          ; serial (timestamp)
604800              ; refresh (1 week)
86400               ; retry (1 day)
2419200             ; expire (28 days)
604800 )            ; minimum (1 week)
;

trtl      IN        NS        ns1.trtl.
$ORIGIN trtl.
google    IN        A        8.8.8.8
ns1       IN        A        0.0.0.0
yourname  IN        A        your.ip.goes.here
```

## TODO
[Needs Work] registrar frontend

[In Progress] repo monitor agent

[In Progress] [domain guidelines](https://github.com/turtlecoin/.trtl/issues/1)

[DONE] issue temnplates for domain application & complaints

