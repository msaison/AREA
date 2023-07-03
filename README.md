# Area

	
&#9888; This is a clone of my school repo, i didn't make the entire project. I made the entire Flutter application, and adding some api to the Back-end like Twitter, Discord and Yammer



## Setup using docker compose

### PROD & DEV
Build the app`docker-compose build`

Start the app `docker-compose up`

### MAC DEV 
Start the app `docker-compose -f mac.yml up`

Build the app `docker-compose -f mac.yml build`

---
# Mobile

### Preview

&#9888; The lag is due to the gif

<img src="https://drive.google.com/thumbnail?id=1s4dRUmusfXiBrKtYqzjFhOBLvzFTrgx_&sz=h180" alt="Gif app"><img src="https://drive.google.com/thumbnail?id=1dKrKdVQnTwhfQBJEMr-aqpg5j6gbFEm-&sz=h180" alt="Gif app">

---
# Web client


### /about.json

#### GET
##### Summary

Display about.json

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |

### /client.apk

#### GET
##### Summary

Download Android APK

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |


---
# API

## Version: 1.0.0

### /user/id

#### GET
##### Summary

Get user id.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| auth0_id | query | User's auth0_id | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |

### /github_callback

#### GET
##### Summary

Callback used to catch Github authentification response.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| state | query | User's auth0_id | Yes | string |
| code | query | Auth2 code | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |

### /github_webhook/{action_id}

#### GET
##### Summary

Webhooks allow you to build or set up integrations.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| action_id | path | Action id to perform | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |

### /google_callback

#### GET
##### Summary

Callback used to catch Google authentification response.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| state | query | User's auth0_id | Yes | string |
| code | query | Auth2 code | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |

### /discord_callback

#### GET
##### Summary

Callback used to catch Discord authentification response.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| state | query | User's auth0_id | Yes | string |
| code | query | Auth2 code | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |

### /twitter_callback

#### GET
##### Summary

Callback used to catch Twitter authentification response.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| state | query | User's auth0_id | Yes | string |
| code | query | Auth2 code | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |

### /yammer_callback

#### GET
##### Summary

Callback used to catch Yammer authentification response.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| state | query | User's auth0_id | Yes | string |
| code | query | Auth2 code | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |


### /cronhook_webhook/{action_id}

#### GET
##### Summary

CronHook Webhooks allow you to build or set up integrations.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| action_id | path | Action id to perform | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |

### /services

#### GET
##### Summary

Get all services.

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |

### /services/action

#### GET
##### Summary

List all actions.

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |

### /services/reaction

#### GET
##### Summary

List all reactions.

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |

### /auths

#### GET
##### Summary

Get user id.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| auth0_id | query | User's auth0_id | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |

### /user/auth/create

#### POST
##### Summary

Create new user.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| auth | body | auth body | Yes | object |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |

### /user/auth/delete

#### POST
##### Summary

Create new user.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| auth | body | auth body | Yes | object |

### /user/services/connected

#### POST
##### Summary

Connect to a service.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| service | body | service body | Yes | object |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |

### /user/services/reaction/create

#### POST
##### Summary

Create a reaction from a service.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| reaction | body | reaction body | Yes | object |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |

### /user/services/action/create

#### POST
##### Summary

Create a action from a service.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| action | body | action body | Yes | object |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |

### /user/applets

#### GET
##### Summary

Get all applets.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| auth0_id | query | User's auth0_id | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |

### /user/applets/destroy

#### GET
##### Summary

Get all applets.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| auth0_id | query | User's auth0_id | Yes | string |
| reaction_id | query | Reaction id | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 500 | Invalid Input |

### Models

#### Auth0Id

User's auth0_id

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| Auth0Id | string | User's auth0_id |  |

#### AuthType

Auth type

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| AuthType | string | Auth type |  |

#### ServiceType

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| ServiceType | string |  |  |

#### ActionType

Action type

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| ActionType | string | Action type |  |

#### ReactionType

Reaction type

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| ReactionType | string | Reaction type |  |

--- 

## Mariadb

### Logs for  'root' user

    environment:
      - MYSQL_ROOT_PASSWORD=S3cret
      - MYSQL_DATABASE=area_db

### usage 
in back express active-record documentation
https://npmjs.com/package/mysql-activerecord 

### Prisma 

### Visualisation
https://www.prisma.io/studio

### Commands CLI
https://www.prisma.io/docs/reference/api-reference/command-reference

---
# DEBUG

##### Quick fix
    docker rm -vf $(docker ps -aq)
    docker rmi -f $(docker images -aq)
    docker volume rm $(docker volume ls -q)
    cd BackExpress; npm install
    cd -
    cd webapp; npm install
    cd -

    docker-compose build
    docker-compose up

    ./db-migrate


##### Error starting userland proxy: listen tcp4 0.0.0.0:3306: bind: address already in use
    sudo netstat -nlpt |grep 3306
    sudo service mysql stop
    sudo kill `sudo lsof -t -i:3306`

##### Database

    sudo rm -rf Mariadb/*
    sudo rm -rf prisma/migrations/*
    docker-compose build
    docker-compose up
    docker-compose down || Ctrl+C
    sudo rm -rf Mariadb/*
    docker-compose up
    ./db-migrate

## Services:

- Discord
    * ...

- Gmail
    * ...
    only the following test accounts are authorized to access the service:
    (google does not allow to use any account)
        ainossaison@gmail.com		
        pambastiani@gmail.com		
        soraisv2@gmail.com

- Twitter
    * ...

- Github
    * ...

only the following test accounts are authorized to access the service:
(google does not allow to use any account)

    ainossaison@gmail.com		
    pambastiani@gmail.com		
    soraisv2@gmail.com
