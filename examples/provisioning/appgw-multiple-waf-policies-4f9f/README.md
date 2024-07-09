```console
% curl -I '20.37.163.137/specific?path=../..'
HTTP/1.1 403 Forbidden
Server: Microsoft-Azure-Application-Gateway/v2
Date: Fri, 05 Jul 2024 15:03:02 GMT
Content-Type: text/html
Content-Length: 179
Connection: keep-alive

% curl -I '20.37.163.137/?path=../..'
HTTP/1.1 403 Forbidden
Server: Microsoft-Azure-Application-Gateway/v2
Date: Fri, 05 Jul 2024 15:03:11 GMT
Content-Type: text/html
Content-Length: 179
Connection: keep-alive

% curl -I -H 'User-Agent:' 20.37.163.137/specific
HTTP/1.1 404 Not Found
Date: Fri, 05 Jul 2024 15:03:40 GMT
Content-Type: text/html
Content-Length: 153
Connection: keep-alive
Server: nginx/1.27.0

% curl -I -H 'User-Agent:' 20.37.163.137
HTTP/1.1 403 Forbidden
Server: Microsoft-Azure-Application-Gateway/v2
Date: Fri, 05 Jul 2024 15:03:44 GMT
Content-Type: text/html
Content-Length: 179
Connection: keep-alive
```
