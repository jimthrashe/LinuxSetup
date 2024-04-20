#!/bin/bash




########################################################################
#                                                                      #    
#  James Thrasher                                                      #       
#                                                                      #   
#   This script sets up linux operating systems with the tools I like. #
#                                                                      #              
#                                                                      #
########################################################################



#Dependents

format() {
    printf '%s\n' '#############################################################################################################' '{5}'
}

checkos() {
    # Check if /etc/os-release exists
    if [ -f /etc/os-release ]; then
        # Use sed to extract the ID field from /etc/os-release
        os=$(sed -n 's/^ID="\?\([^"]*\)"\?$/\1/p' /etc/os-release)
        # Convert to lowercase for comparison
        os=$(echo "$os" | tr '[:upper:]' '[:lower:]')
    else
        # If /etc/os-release does not exist, set os to "Unknown"
        os="Unknown"
    fi
}
if_Archinstall() {
    # Update package list and upgrade packages
    sudo pacman -Syu
    
    # Remove unused packages (orphans)
    sudo pacman -Rns $(pacman -Qtdq)
    
    # Install required packages
    sudo pacman -S --noconfirm gnome python code macchanger wireshark git binwalk neovim npm go make unzip gcc ripgrep ansible
    sudo pacman -S --noconfirm gnome-tweaks gnome-shell-extensions arcmenu gnome-shell-extension-caffeine gnome-shell-extension-clipboard-indicator gnome-shell-extension-dash-to-panel gnome-shell-extension-just-perfection gnome-shell-extension-tophat gnome-shell-extension-user-themes
}
if_DebianInstall() {
    # Update package list and upgrade packages
    sudo apt update && sudo apt upgrade -y
    
    # Remove unused packages (orphans)
    sudo apt autoremove -y
    
    # Install required packages
    sudo apt install -y python3 git ansible
}



# Function to perform installation if the OS is Ubuntu
if_UbuntuInstall() {
    # Update package list and upgrade packages
    sudo apt update && sudo apt upgrade -y
    
    # Remove unused packages (orphans)
    sudo apt autoremove -y
    
    # Install required packages
    sudo apt install -y python3 git ansible
}



# Function to perform installation if the OS is Fedora
if_FedoraInstall() {
    # Update package list and upgrade packages
    sudo dnf update -y
    
    # Remove unused packages (orphans)
    sudo dnf autoremove -y
    
    sudo dnf clean packages -y

    # Install required packages
    sudo dnf install -y python3 git ansible
}


# Function to check the OS distribution
check_distribution() {
    case "$os" in
        arch)
            echo "This is Arch Linux."
                if_ArchInstall
            ;;
        debian)
            echo "This is Debian."
                if_DebianInstall
            ;;
        ubuntu)
            echo "This is Ubuntu."
                if_UbuntuInstall
            ;;
        fedora)
            echo "This is Fedora."
                if_FedoraInstall
                echo "runing ansible"
                Ansible_ConfiguratorFedora
            ;;
         *)
            echo "Unknown distribution."
            ;;
    esac
}


Ansible_ConfiguratorFedora(){

    ansible-pull -U https://github.com/jimthrashe/LinuxSetup -i Fedora-workstation/inventory
}








main(){

    checkos
    check_distribution
    echo "running ansible"




}

main