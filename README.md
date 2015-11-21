# docker-console

This is a conosle tools for docker!

## 0. Quick Start

**First, install docker & docer-machine & ruby!**
```
$ git clone https://github.com/zhuangbiaowei/docker-console
$ cd docker-console
$ bundle install
$ bundle exec ./bin/docker-console
unix:///var/run/docker.sock > _
```

## 1. machine commands

### 1.1. list machine (or search machine)

```
unix:///var/run/docker.sock > lm
Number  Name                	URL                         Labels
0       local               	tcp://192.168.99.100:2376   web
1       swarm-agent-00      	tcp://192.168.99.102:2376
2       swarm-agent-01      	tcp://192.168.99.103:2376
3       swarm-master        	tcp://192.168.99.101:2376   db
=> "Total 4 machines."
unix:///var/run/docker.sock > lm swarm
Number  Name                	URL                         Labels
0       swarm-agent-00      	tcp://192.168.99.102:2376   web
1       swarm-agent-01      	tcp://192.168.99.103:2376
2       swarm-master        	tcp://192.168.99.101:2376   db
=> "Total 3 machines."
unix:///var/run/docker.sock > lm * web
Number  Name                	URL                         Labels
0       local               	tcp://192.168.99.100:2376   web
=> "Total 1 machines."
```

### 1.2 connect machine

```
unix:///var/run/docker.sock > cm local
=> "Connected Docker: tcp://192.168.99.101:2376"
unix:///var/run/docker.sock > lm swarm
Number  Name                	URL                         Labels
0       swarm-agent-00      	tcp://192.168.99.102:2376
1       swarm-agent-01      	tcp://192.168.99.103:2376
2       swarm-master        	tcp://192.168.99.101:2376   db
=> "Total 3 machines."
tcp://192.168.99.101:2376 > cm 2
=> "Connected Docker: tcp://192.168.99.101:2376"
tcp://192.168.99.101:2376 > cm tcp://192.168.99.102:2376
=> "Connected Docker: tcp://192.168.99.102:2376"
```

# 2. container commands

## 2.1. list container
```
tcp://192.168.99.100:2376 > lc
ID      	Image               	Name                	Command                       	Status              	Port
3edb26a6	nginx               	/berserk_brattain   	nginx -g 'daemon off;'        	Up 2 seconds        	:443->/tcp
3edb26a6	nginx               	/berserk_brattain   	nginx -g 'daemon off;'        	Up 2 seconds        	:80->/tcp
=> "Total 1 containers."
```
### 2.2. rm container
```
tcp://192.168.99.100:2376 > rm 3edb26a6
=> "Container 3edb26a6 Deleted!"
```
### 2.3. run container
```
tcp://192.168.99.100:2376 > run nginx -p 80:80,443:443
=> nil
tcp://192.168.99.100:2376 > run swarm --rm create
!fc23ab04571c9e6f388a60f914ba697e
=> nil
```
### 2.4. multi run containers
```
tcp://192.168.99.100:2376 > lm
Number  Name                	URL                         Labels
0       local               	tcp://192.168.99.100:2376   web
1       swarm-agent-00      	tcp://192.168.99.102:2376
2       swarm-agent-01      	tcp://192.168.99.103:2376
3       swarm-master        	tcp://192.168.99.101:2376   db
=> "Total 4 machines."
tcp://192.168.99.100:2376 > mrun nginx -p 80:80,443:443
=> "Run command at 4 machines."
```
