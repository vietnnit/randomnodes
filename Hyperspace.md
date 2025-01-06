## Run HyperSpace on VPS

Install Docker if it is not there, if it is there you can skip it.
```
apt install docker.io -y
```
Pull Docker Image
```
docker pull ubuntu:22.04
```
Run Docker Container
```
docker run -it --name aios ubuntu:22.04
exit
docker container start aios
```
Enter the Container
```
docker container exec -it aios /bin/bash
```

Update Docker Ubuntu dan Install HyperSpace
```
cd && apt update && apt upgrade && apt install curl tmux -y
curl https://download.hyper.space/api/install | bash
source /root/.bashrc
```
Create Screen
```
screen -S aios
```
Start aios
```
aios-cli start
```
After running, CTRL + A then D

Login
```
aios-cli hive login
```
Select Tier
```
aios-cli hive select-tier 5
```
Add Models
```
aios-cli models add hf:TheBloke/Mistral-7B-Instruct-v0.1-GGUF:mistral-7b-instruct-v0.1.Q4_K_S.gguf
```
Backup Pubkey + Privkey
```
aios-cli hive whoami
```
Connect aios
```
aios-cli hive connect
```

Check Points
```
aios-cli hive points
```
Done, Buy me Coffee!
