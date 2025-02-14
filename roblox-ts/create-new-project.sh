echo "\n"
read -p "Please enter a name for the project: " directory_name
echo "\n"
read -p "Warning: You must have Aftman, Node.js, Visual Studio Code, and Roblox Studio installed on your system for this script to function, would you like to continue? (Y/N): " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" ]]; then
    echo "\n"
else
    echo "\nQuitting..."
    exit 1
fi
read -p "Warning: Any folder with your project name will be PERNAMENTLY DELETED, would you like to continue? (Y/N): " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" ]]; then
    echo "\n"
else                            
    echo "\nQuitting..."                     
    exit 1                                                                                     
fi
echo "Removing Directory If It Exists..."
rm -rf "$directory_name"
echo "\nMaking Directory..."
mkdir "$directory_name"
cd "$directory_name"
aftman init
echo "\n<<< If prompted, please enter \"Y\" on your keyboard to install Rojo >>>\n"
aftman add rojo-rbx/rojo
aftman install
echo "\n<<< Please enter \".\" for the project directory and follow the setup instructions >>>"
npm init roblox-ts
echo "\nMaking Directories..."
mkdir -p assets/{animations,audio,images,models,ui}
mkdir -p assets/ui/{icons,images,sounds}
mkdir -p docs
mkdir -p libs
mkdir -p scripts
mkdir -p src/client/{components,config,interfaces,models,services,systems,ui,utils}
mkdir -p src/client/ui/{components,contexts,hooks,layouts,motion,themes}
mkdir -p src/server/{components,config,interfaces,models,services,systems,utils}
mkdir -p src/shared/{components,config,interfaces,models,remotes,systems,utils}
mkdir -p src/shared/remotes/{events,functions}
mkdir -p src/tests/{client,server,shared}
mkdir -p src/types
echo "\nInstalling @rbxts/services..."
npm i @rbxts/services
echo "\nInstalling @rbxts/t..."
npm i @rbxts/t
echo "\nInstalling @rbxts/testez..."
npm i @rbxts/testez
echo "\nInstalling @rbxts/react..."
npm i @rbxts/react
echo "\nInstalling @rbxts/react-roblox..."
npm i @rbxts/react-roblox
echo "\nInstalling @rbxts/pretty-react-hooks..."
npm i @rbxts/pretty-react-hooks
echo "\nInstalling @rbxts/charm..."
npm i @rbxts/charm
echo "\nInstalling @rbxts/react-charm..."
npm i @rbxts/react-charm
echo "\nInstalling @rbxts/charm-sync..."
npm i @rbxts/charm-sync
echo "\nInstalling @rbxts/ripple..."
npm i @rbxts/ripple
echo "\nMaking Scripts..."
echo "killall -9 \"RobloxStudio\"\nrm -rf \"server.rbxlx\"\nrm -rf \"server.rbxlx.lock\"\nnpm run watch &\nrojo serve &\nrojo build --watch -o server.rbxlx &\nsleep 1\nopen server.rbxlx\nwait" > scripts/start-server.sh
chmod +x scripts/start-server.sh
echo "\n"
read -p "Your Project Is Setup! Once Visual Studio Code opens you can create a new terminal and enter \"./scripts/start-server.sh\" to start Roblox Studio, Rojo Serve, and RobloxTS Watch. Press Enter or Return to continue"
code .
echo "\n"
echo "<<< Project Created! >>>"
