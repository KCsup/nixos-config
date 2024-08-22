# nixos-config
My NixOS Config.

# Installing
```
cd ~ && git clone https://github.com/KCsup/nixos-config.git && mv nixos-config .nixconf
```
## WSL Install Steps
1. Install and enable WSL
```
wsl --install --no-distribution
```
2. Download the [NixOS WSL latest release](https://github.com/nix-community/NixOS-WSL/releases/latest)
3. Import NixOS with the downloaded tarball in powershell
```
wsl --import NixOS $env:USERPROFILE\NixOS\ nixos-wsl.tar.gz
```
Note: If there are spaces in your Windows username folder (ex. `C:\Users\User Name\`), change directories into your user folder and run the following command.
```
wsl --import NixOS .\NixOS\ nixos-wsl.tar.gz
```
4. Open NixOS in WSL
```
wsl -d NixOS
```
5. Exit WSL and set NixOS as the default distribution
```
wsl -t NixOS
wsl -s NixOS
```
6. Follow the steps to [change the default user](https://nix-community.github.io/NixOS-WSL/how-to/change-username.html) to the user specified in `flake.nix`
7. Clone and build the config in the default user's home
