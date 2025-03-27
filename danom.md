# 🚀 **DANOM WORKER NODE**  
- What is Danom ?
- Danom is a revolutionary project designed to simplify AI adoption for businesses, developers, and enthusiasts by offering powerful pre-trained AI models that can be accessed effortlessly through APIs. By leveraging the Hugging Face API, users no longer need to worry about training models, managing AI infrastructure, or dealing with complex machine-learning frameworks. Instead, they can focus on innovation, creativity, and problem-solving, using AI as an easily accessible tool.

![image](https://github.com/user-attachments/assets/009ccea5-d7c3-48b2-bf9a-e32433c23113)

## 🛠 **Follow This Steps First**  
- Create Account : https://huggingface.co/join
- Verify Email
- Go To Profile
- Setting > Access Token
- Click + Create New Token
- Create Name > Create Token
- Copy API ( Will use if it for later)

### 🔹 **Step 1: Update & Install Dependencies**  
Run the following command:  
```bash
sudo apt update && sudo apt install -y wget curl tar screen
```

### 🔹 **Step 2: Install DonamV5**  
```bash
wget https://github.com/DanomSite/release/releases/download/v5/DanomV5.tar.gz && tar -xvzf DanomV5.tar.gz
cd Danom
```

### 🔹 **Step 3: Install Testnet Danom**  
```bash
curl -fsSL 'https://testnet.danom.site/install.sh' | bash
```

### 🔹 **Step 4: Replace Wallet and API**  
- 0xYOUR_WALLET_ADDRESS = Wallet Address with 0x
- YOUR_POOL_LIST = API huggingface 

```bash
echo '{"wallet": "0xYOUR_WALLET_ADDRESS", "pool_list": "YOUR_POOL_LIST"}' > wallet_config.json
```

### 🔹 **Step 5: Create Screen**  
```bash
screen -S danom
```

### 📌 **Step 6: Run Danom**  
```bash
./danom
```

### ✅ **Detached Screen:**  
Press `CTRL + A + D` to exit the screen session.  



➡️ If you have collected enough, claim NOM with no fee: [https://testnet.danom.site/](https://testnet.danom.site/)

➡️ Market to swap NOM to MON: Ambient Monad [Swap](https://monad.ambient.finance/trade/market/chain=0x279f&tokenA=0x43e52cbc0073caa7c0cf6e64b576ce2d6fb14eb8&tokenB=0x0000000000000000000000000000000000000000) 

➡️ Docs on running a worker: https://testnet.danom.site/docs/how-it-work/howitwork

✅ Note: Soon, it will be possible to swap to DANOM Mainnet (new wallet required).

Let me know if you need any refinements! 🚀


🎉 **DONE! Your Danom Testnet set up successfully!** 🚀  

---
