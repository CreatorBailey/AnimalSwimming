# 🐾 Animal Swim Module for FiveM

Make animals swim properly and naturally in water! This lightweight client-side script prevents animal peds (like dogs) from drowning or ragdolling in water, applying smooth upward force and preserving immersion when players use animal models.

---

## ✨ Features

- ✅ Detects if the player is using an animal ped
- 🌊 Applies dynamic float behavior in deep and shallow water
- ❤️ Prevents animal drowning by restoring health
- 🧍‍♂️ Disables ragdoll in water, re-enables on land
- 🔄 Smooth transitions and force control for natural movement
- 🔁 Automatic on player load

---

## 🧠 How It Works

When a player loads into the server, the script checks if their ped is an animal (`GetPedType(ped) == 28`). If so, it applies buoyancy logic every 200ms when the player is in water and not in a vehicle. It prevents drowning, sinking, and bouncing too high in the water, giving a much more realistic feel for roleplay scenarios involving dogs or other animals.

---

## 📂 Installation

1. **Download or clone the resource** into your `resources` folder:


2. **Add the resource to your server config** (`server.cfg`):


3. **Supports QBCore or ESX out of the box.**  
The script listens for:
- `QBCore:Client:OnPlayerLoaded`
- or `esx:playerLoaded` (you can easily switch by editing the event)

---

## 🛠️ Configuration

No config is needed for default behavior.  
If you want to add custom ped checks (e.g., specific animal models), modify the `IsPlayerAnimal()` function in `client.lua`.

---

## 💡 Notes

- Script is fully client-side.
- This does **not** modify or interfere with normal peds or vehicles.
- Great for K9 RP, wildlife servers, or animal mods.

---

## 📸 Preview

Coming soon!

---

## 📃 License

This project is open-source under the MIT License.  
Feel free to contribute or fork for your own community!

---

## 👨‍💻 Credits

Developed by Cloutmatic  
For support or questions, contact me on the FiveM forums under Gatorsman98 or Join Our New Discord!

https://discord.gg/RQQyRpg2vB
