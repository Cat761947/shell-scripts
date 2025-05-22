#!/usr/bin/env bash

echo -e "\n"
read -p "Please enter a name for the project: " directory_name
echo -e "\n"
read -p "Warning: You must have Aftman, Node.js, Visual Studio Code, and Roblox Studio installed on your system for this script to function, would you like to continue? (Y/N): " choice
choice=$(echo -e "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" ]]; then
    echo -e "\n"
else
    echo -e "\nQuitting..."
    exit 1
fi
read -p "Warning: Any folder with your project name will be PERNAMENTLY DELETED, would you like to continue? (Y/N): " choice
choice=$(echo -e "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" ]]; then
    echo -e "\n"
else                            
    echo -e "\nQuitting..."                     
    exit 1                                                                                     
fi
echo -e "Removing Directory If It Exists..."
rm -rf "$directory_name"
echo -e "\nMaking Directory..."
mkdir "$directory_name"
cd "$directory_name"
aftman init
echo -e "\n<<< If prompted, please enter \"Y\" on your keyboard to install Rojo >>>\n"
aftman add rojo-rbx/rojo
aftman install
echo -e "\n<<< Please enter \".\" for the project directory and follow the setup instructions >>>"
npm init roblox-ts
echo -e "\nMaking Directories..."
mkdir -p assets/{animations,audio,images,models,ui}
mkdir -p assets/ui/{icons,images,sounds}
mkdir -p docs
mkdir -p libs
mkdir -p scripts
mkdir -p src/client/{components,config,interfaces,classes,services,systems,utils}
mkdir -p src/client/ui/{animations,atoms,components,hooks,layouts,themes}
mkdir -p src/server/{components,config,interfaces,classes,services,systems,utils}
mkdir -p src/shared/{components,config,interfaces,classes,remotes,systems,utils}
mkdir -p src/shared/remotes/{events,functions}
mkdir -p src/tests/{client,server,shared}
mkdir -p src/types
echo -e "\nInstalling @rbxts/services..."
npm i @rbxts/services
echo -e "\nInstalling @rbxts/t..."
npm i @rbxts/t
echo -e "\nInstalling @rbxts/testez..."
npm i @rbxts/testez
echo -e "\nInstalling @rbxts/react..."
npm i @rbxts/react
echo -e "\nInstalling @rbxts/react-roblox..."
npm i @rbxts/react-roblox
echo -e "\nInstalling @rbxts/pretty-react-hooks..."
npm i @rbxts/pretty-react-hooks
echo -e "\nInstalling @rbxts/charm..."
npm i @rbxts/charm
echo -e "\nInstalling @rbxts/react-charm..."
npm i @rbxts/react-charm
echo -e "\nInstalling @rbxts/charm-sync..."
npm i @rbxts/charm-sync
echo -e "\nInstalling @rbxts/ripple..."
npm i @rbxts/ripple
echo -e "\nMaking Scripts..."
cat <<EOL > scripts/start-server.sh
#!/usr/bin/env bash

echo -e "Killing studio..."
killall -9 "RobloxStudio"

echo -e "Deleting Old Build..."
rm -rf "server.rbxlx"
rm -rf "server.rbxlx.lock"

echo -e "Compiling..."
npm run build
echo -e "Building..."
rojo build -o server.rbxlx
echo -e "Starting Studio..."
open server.rbxlx

sleep 1

echo -e "Starting Compiler Watcher..."
npm run watch &
sleep 1
echo -e "Starting Build Watcher..."
rojo build --watch -o server.rbxlx &
sleep 1
echo -e "Serving..."
rojo serve &
wait
EOL
chmod +x scripts/start-server.sh
echo -e "\n"
read -p "Your Project Is Setup! Once Visual Studio Code opens you can create a new terminal and enter \"./scripts/start-server.sh\" to start Roblox Studio, Rojo Serve, and RobloxTS Watch. Press Enter or Return to continue"
code .
echo -e "\n"
echo -e "<<< Project Created! >>>"
