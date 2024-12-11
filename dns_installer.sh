#!/bin/bash

# Update package lists and install necessary packages
echo "Updating package lists..."
sudo apt update -y

# Create the dnschanger script
echo "Creating dnschanger script..."
cat << 'EOF' > ~/bin/dnschanger
#!/bin/bash

# Function to set DNS for Shecan
set_shecan_dns() {
    echo "Configuring DNS for Shecan..."
    sudo bash -c 'cat <<EOF > /etc/systemd/resolved.conf
[Resolve]
DNS=178.22.122.100 127.0.0.53
Domains=~shecan.ir
EOF'
    sudo systemctl restart systemd-resolved
    echo "Shecan DNS configured."
}

# Function to set DNS for 403.online
set_403_online_dns() {
    echo "Configuring DNS for 403.online..."
    sudo bash -c 'cat <<EOF > /etc/systemd/resolved.conf
[Resolve]
DNS=10.202.10.202 127.0.0.53
Domains=~403.online
EOF'
    sudo systemctl restart systemd-resolved
    echo "403.online DNS configured."
}

# Function to remove existing DNS entries
remove_old_dns() {
    echo "Removing old DNS entries..."
    sudo bash -c 'cat <<EOF > /etc/systemd/resolved.conf
[Resolve]
EOF'
}

# Check user input for domain selection
if [ "$1" == "shecan" ]; then
    remove_old_dns
    set_shecan_dns
elif [ "$1" == "403" ]; then
    remove_old_dns
    set_403_online_dns
else
    echo "Usage: $0 {shecan|403}"
fi
EOF

# Make the dnschanger script executable
chmod +x ~/bin/dnschanger

# Add ~/bin to PATH if it's not already there
if ! echo "$PATH" | grep -q "$HOME/bin"; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
fi

echo "dnschanger installation complete!"
echo "You can now use it by running: dnschanger shecan or dnschanger 403"
