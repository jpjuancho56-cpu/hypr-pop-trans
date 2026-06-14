# hypr-pop-trans 🌐🚀

A lightweight, sticky, and floating translation pop-up window tailored for **Hyprland** and the **HyDE project** ecosystem. 

It captures your current selection or clipboard text in Wayland, translates it instantly using `translate-shell`, and displays it in a dedicated, floating terminal window that stays fixed across all workspaces.

---

## ✨ Features

* **Instant Translation:** Translates whatever text you have highlighted/selected immediately.
* **Sticky & Floating Window:** The pop-up window stays pinned (`sticky`) in your preferred corner across all workspaces.
* **Ultra Lightweight:** Uses native Wayland tools and terminal instances—no heavy electron apps or background daemons.
* **Future-proof:** Built with expansion in mind (Text-to-Speech support coming soon).

## 🛠️ Requirements

Make sure you have the following dependencies installed on your Arch Linux system:

```bash
sudo pacman -S wl-clipboard translate-shell mpv
```

## 🚀 Installation & Setup
1. Clone the Repository

Clone this repository and enter the directory:
Bash

git clone [https://github.com/YOUR_USERNAME/hypr-translate.git](https://github.com/YOUR_USERNAME/hypr-translate.git)
cd hypr-translate

2. Run the Automated Installer

The included script will automatically place the translator executable in your local path and append the proper rules and keybindings to your HyDE configuration files safely:
Bash

chmod +x install.sh
./install.sh

3. Reload Hyprland

Press SUPER + Shift + R (or run hyprctl reload) to apply the new configuration.
## 📖 Usage

    Select any text anywhere on your screen (web browser, PDF, document, text editor).

    Press SUPER + ALT + T.

    The floating pop-up will appear in the top-right corner showing the translation.

    Press any key inside the window to close it when you're done.

## 📄 License

This project is licensed under the MIT License.