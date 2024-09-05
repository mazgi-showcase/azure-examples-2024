## Export

```console
export APPGW_IPADDR=$(docker compose exec provisioning zsh -c "terraform output -json appgw-multiple-waf-policies-4f9f | jq -r '.azurerm_public_ip.\"for-main-appgw\".ip_address'" 2> /dev/null)
export BACKEND_FQDN=$(docker compose exec provisioning zsh -c "terraform output -json appgw-multiple-waf-policies-4f9f | jq -r '.azurerm_linux_web_app.\"main-linux-docker\".default_hostname'" 2> /dev/null)
```

## Verify

```console
curl -s "http://${BACKEND_FQDN}" | jq .
```

```console
❯ curl -s "http://${BACKEND_FQDN}" | jq .
{
  "app_info": {
    "version": "2024.7.1+505dbcc"
  },
  "method": "GET",
  "path": "/"
}
```

```console
curl -s "http://${APPGW_IPADDR}" | jq .
```

```console
❯ curl -s "http://${APPGW_IPADDR}" | jq .
{
  "app_info": {
    "version": "2024.7.1+505dbcc"
  },
  "method": "GET",
  "path": "/"
}
```

## WAF

```console
curl -s -H 'User-Agent:' "http://${APPGW_IPADDR}"
```

```console
❯ curl -s -H 'User-Agent:' "http://${APPGW_IPADDR}"
<html>
<head><title>403 Forbidden</title></head>
<body>
<center><h1>403 Forbidden</h1></center>
<hr><center>Microsoft-Azure-Application-Gateway/v2</center>
</body>
</html>
```

```console
curl -o /dev/null -s -w '{"header_json":%{header_json},"json":%{json}}' -H 'User-Agent:' "http://${APPGW_IPADDR}" | jq .
```

```console
❯ curl -o /dev/null -s -w '{"header_json":%{header_json},"json":%{json}}' -H 'User-Agent:' "http://${APPGW_IPADDR}" | jq .
{
  "header_json": {
    "server": [
      "Microsoft-Azure-Application-Gateway/v2"
    ]
  },
  "json": {
    "content_type": "text/html",
    "method": "GET",
    "response_code": 403,
    "scheme": "HTTP",
    "url.scheme": "http",
    "url.port": "80",
    "url.path": "/",
    "curl_version": "libcurl/8.6.0 (SecureTransport) LibreSSL/3.3.6 zlib/1.2.12 nghttp2/1.61.0"
  }
}
```

```console
curl -s -H 'User-Agent:' "http://${APPGW_IPADDR}/specific" | jq .
```

```console
❯ curl -s -H 'User-Agent:' "http://${APPGW_IPADDR}/specific" | jq .
{
  "app_info": {
    "version": "2024.7.1+505dbcc"
  },
  "method": "GET",
  "path": "/specific"
}
```

```console
curl -o /dev/null -s -w '{"header_json":%{header_json},"json":%{json}}' -H 'User-Agent:' "http://${APPGW_IPADDR}/specific" | jq .
```

```console
❯ curl -o /dev/null -s -w '{"header_json":%{header_json},"json":%{json}}' -H 'User-Agent:' "http://${APPGW_IPADDR}/specific" | jq .
{
  "header_json": {
    "content-type": [
      "application/json; charset=utf-8"
    ]
  },
  "json": {
    "content_type": "application/json; charset=utf-8",
    "method": "GET",
    "response_code": 200,
    "scheme": "HTTP",
    "url.scheme": "http",
    "url.port": "80",
    "url.path": "/specific",
    "curl_version": "libcurl/8.6.0 (SecureTransport) LibreSSL/3.3.6 zlib/1.2.12 nghttp2/1.61.0"
  }
}
```

```console
curl -o /dev/null -s -w '{"header_json":%{header_json},"json":%{json}}' -H 'User-Agent: Mozilla/5.0 (compatible; Nmap Scripting Engine; http://nmap.org/book/nse.html)' "http://${APPGW_IPADDR}" | jq .
```

```console
❯ curl -o /dev/null -s -w '{"header_json":%{header_json},"json":%{json}}' -H 'User-Agent: Mozilla/5.0 (compatible; Nmap Scripting Engine; http://nmap.org/book/nse.html)' "http://${APPGW_IPADDR}" | jq .
{
  "header_json": {
    "server": [
      "Microsoft-Azure-Application-Gateway/v2"
    ]
  },
  "json": {
    "response_code": 403,
  }
}
```

```console
curl -o /dev/null -s -w '{"header_json":%{header_json},"json":%{json}}' -H 'User-Agent: Mozilla/5.0 (compatible; Nmap Scripting Engine; http://nmap.org/book/nse.html)' "http://${APPGW_IPADDR}/specific" | jq .
```

```console
❯ curl -o /dev/null -s -w '{"header_json":%{header_json},"json":%{json}}' -H 'User-Agent: Mozilla/5.0 (compatible; Nmap Scripting Engine; http://nmap.org/book/nse.html)' "http://${APPGW_IPADDR}/specific" | jq .
{
  "header_json": {
    "server": [
      "Microsoft-Azure-Application-Gateway/v2"
    ]
  },
  "json": {
    "response_code": 403
  }
}
```
