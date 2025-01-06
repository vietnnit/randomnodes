## Run HyperSpace on VPS

### Step:1 Install Docker if it is not there, if it is there you can skip it.
```
apt install docker.io -y
```
### Step:2 Pull Docker Image
```
docker pull ubuntu:22.04
```
### Step:3 Run Docker Container
```
docker run -it --name aios ubuntu:22.04
exit
docker container start aios
```
### Step:4 Enter the Container
```
docker container exec -it aios /bin/bash
```

### Step:5 Update Docker Ubuntu dan Install HyperSpace
```
cd && apt update && apt upgrade && apt install curl screen -y
curl https://download.hyper.space/api/install | bash
source /root/.bashrc
```
### Step:6 Create Screen
```
screen -S aios
```
### Step:7 Start aios
```
aios-cli start
```
After running, CTRL + A then D

### Step:8 Login
```
aios-cli hive login
```
### Step:9 Select Tier
```
aios-cli hive select-tier 5
```
### Step:10 Add Models
```
aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf
```
### Step:11 Backup Pubkey + Privkey
```
aios-cli hive whoami
```
### Step:12 Connect aios
```
aios-cli hive connect
```

- Check Points
```
aios-cli hive points
```
- CTRL + A then D to exit docker 

Done, Buy me Coffee!
