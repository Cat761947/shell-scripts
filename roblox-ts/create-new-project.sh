echo "\n"
read -p "Please enter a name for the project: " directory_name
echo "\n"
read -p "Warning: You must have Aftman and Node.js installed on your system for this script to function, would you like to continue? (Y/N): " choice
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
mkdir scripts
echo "\nInstalling @rbxts/services..."
npm i @rbxts/services
echo "\nInstalling @rbxts/t..."
npm i @rbxts/t
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
echo "killall -9 \"RobloxStudio\"\nrm -rf \"server.rbxlx\"\nrm -rf \"server.rbxlx.lock\"\nrojo build --watch -o server.rbxlx &\nnpm run watch &\nrojo serve &\nsleep 1\nopen server.rbxlx\nwait" > scripts/start-server.sh
chmod +x scripts/start-server.sh
echo "\n"
read -p "Your Project Is Setup! Once Visual Studio Code opens you can create a new terminal and enter \"./scripts/start-server.sh\" to start Roblox Studio, Rojo Serve, and RobloxTS Watch. Press Enter or Return to continue"
code .
echo "\n"
echo "<<< Project Created! >>>"
