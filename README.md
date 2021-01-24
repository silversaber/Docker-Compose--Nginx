# Nginx docker image

## 1. Purpose

Used by loadbalance for own server, provide index.html for link to other pages

---

## 2. Other service's images


### Docker-Build
- https://github.com/silversaber/Docker-Compose--Builder

### Transmission
- https://github.com/silversaber/Docker-Compose--Transmission

### Jenkins
- https://github.com/silversaber/Docker-Compose--Jenkins

----
## 3. Receive environment
    
    - USERNAME: User name when use http basic login
    - USERPWD: User pwd when use http basic login
    - USERNAME2: // same, but the other user
    - USERPWD2: // same here
    - SubDomain: prev domain or the other domain
    - PrimaryDomain: current domain
