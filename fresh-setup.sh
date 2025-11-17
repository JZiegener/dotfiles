#!/bin/sh

# Function to handle the user choice and call appropriate scripts
initialize_system() {
    clear
    echo "Select the type of system you want to initialize:"
    echo "1. User Session"
    echo "2. Virtual Machine"
    echo "3. Metal - CLI Only"
    echo "4. Metal - Desktop"
    echo "5. Exit"
    read -p "Enter your choice [1-5]: " choice

    case $choice in
        1)
            echo "Initializing User Session..."
            wget https://raw.githubusercontent.com/JZiegener/dotfiles/refs/heads/main/install/fresh-user-session.sh | sh
            
            echo "Install Complete."
            exit 0
            ;;
        2)
            echo "Initializing Virtual Machine..."
            wget https://raw.githubusercontent.com/JZiegener/dotfiles/refs/heads/main/install/fresh-user-session.sh | sh
            wget https://raw.githubusercontent.com/JZiegener/dotfiles/refs/heads/main/install/fresh-vm-console-install.sh | sh
            
            echo "Install Complete."
            exit 0
            ;;
        3)
            echo "Initializing Metal - CLI Only..."
            
            wget https://raw.githubusercontent.com/JZiegener/dotfiles/refs/heads/main/install/fresh-user-session.sh | sh
            wget https://raw.githubusercontent.com/JZiegener/dotfiles/refs/heads/main/install/fresh-vm-console-install.sh | sh
            ~/repos/dotfiles/install/fresh-metal-console.sh

            echo "Install Complete."
            exit 0
            ;;
        4)
            echo "Initializing Metal - Desktop..."
            
            wget https://raw.githubusercontent.com/JZiegener/dotfiles/refs/heads/main/install/fresh-user-session.sh | sh
            wget https://raw.githubusercontent.com/JZiegener/dotfiles/refs/heads/main/install/fresh-vm-console-install.sh | sh
            ~/repos/dotfiles/install/fresh-metal-console-install.sh
            ~/repos/dotfiles/install/fresh-metal-desktop-install.sh

            echo "Install Complete."
            exit 0
            ;;
        5)
            echo "Exiting script. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option! Please select a valid option [1-5]."
            ;;
    esac
}

# Main loop to continuously show the menu until the user decides to exit
while true; do
    initialize_system
done
