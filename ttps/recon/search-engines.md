# Search engine for public facing apps

Let's say I want to find public facing panOS Global Protect and f5 big ip servers...

## Fofa

```
app="paloalto-GlobalProtect"
app="f5-BIGIP"
```

https://en.fofa.info/

## Hunter.how

```
product.name="GlobalProtect Portal"
product.name="F5 BIG-IP"
```

https://hunter.how/

## Shodan

```
http.favicon.hash:-631559155
http.title:"BIG-IP&reg;- Redirect" 
```

https://shodan.io/

## proceed to nmap to scan for CVE's against target of opportunity

