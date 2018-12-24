
Docker container of ngrok.

- Deploy ngrok to your own server by one-step
- Build the latest ngrok from source code for both server and client

# Server Side

You'd better to run ngrok server with a public IP and domain.

## 1. Setup Docker Images

Download and create docker images for ngrok.

```sh
$ git clone https://github.com/nullpointer/docker-ngrok-backend.git
$ make build
```

There is also a docker image if you do not want to build by yourself.

```sh
$ docker pull airpointer/ngrok
```

## 2. Run Docker Container

```sh
$ make run
```

The default domain and port mapping are config in [Makefile](Makefile), you can change them.

* Default domain: `tunnel.nullpointer.ltd`

* Default ports mapping:

| SCHEME  | HOST | CONTAINER |
|  ---    | ---  |    ---    |
|  HTTP   | 9525 |    9525   |
|  HTTPS  | 9526 |    9526   |
|  TUNNEL | 9527 |    9527   |


# Client Side

## 1. Setup

You can use the pre-built clients in [clients](clients) directly. 

OR

You can copy build output for clients from container to your host.
It will build ngrok from source code when the first time you run the container.

Run `docker ps` to find the container id of ngrok, then copy the build output:

```sh
$ docker cp <CONTAINERID>:/ngrokd-backend/build/bin clients
```

## 2. Run

```sh
$ ngrok -subdomain=<SUBDOMAIN> -config=ngrok.cfg <PORT>
```

Examples:

You can use [clients/ngrok.cfg](clients/ngrok.cfg) as the config:

```sh
$ ngrok -subdomain=my -config=ngrok.cfg 8888
```

After connected to ngrok server, you will see the following output: 

```
Tunnel Status                 online
Version                       1.7/1.7
Forwarding                    http://my.tunnel.nullpointer.ltd:9525 -> 127.0.0.1:8888
Forwarding                    https://my.tunnel.nullpointer.ltd:9525 -> 127.0.0.1:8888
Web Interface                 127.0.0.1:4040
# Conn                        0
Avg Conn Time                 0.00ms
```

Right now, access to http://my.tunnel.nullpointer.ltd:9525 is the same as 127.0.0.1:8888 on your local host.

> **Notice**: Everytime you create a new ngrok container, a new pair of client and server ngrok will be built out.
> You MUST use the new client to connect to the new server.
