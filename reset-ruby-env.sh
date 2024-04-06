#!/bin/bash

# Step 1: Uninstall all Ruby versions managed by rbenv
echo "Uninstalling all Ruby versions installed via rbenv..."
if command -v rbenv >/dev/null; then
    for version in $(rbenv versions --bare); do
        rbenv uninstall -f "$version"
    done
else
    echo "rbenv not found. Skipping Ruby versions uninstallation."
fi

# Step 2: Remove rbenv and its plugins
echo "Removing rbenv and its plugins..."
if [ -d "${HOME}/.rbenv" ]; then
    rm -rf "${HOME}/.rbenv"
fi

# Step 3: Uninstall Bundler
echo "Uninstalling Bundler..."
if gem list bundler --installed > /dev/null; then
    gem uninstall bundler -ax
else
    echo "Bundler not found. Skipping uninstallation."
fi

# Step 4: Clean up rbenv shims and versions from PATH in bash_profile, bashrc, and zshrc
echo "Cleaning up PATH and rbenv initializations from shell configuration files..."
for file in .bash_profile .bashrc .zshrc; do
    if [ -f "${HOME}/${file}" ]; then
        sed -i '' '/rbenv init -/d' "${HOME}/${file}"
        sed -i '' '/\.rbenv\/bin/d' "${HOME}/${file}"
    fi
done

# Optional Step 5: Uninstall system Ruby (Not recommended)
# Note: Uninstalling the system Ruby can lead to system instability on MacOS, as some system applications rely on it.
# We recommend skipping this step unless you are certain about the implications.
# echo "Attempting to uninstall system Ruby... (Not recommended)"
# sudo rm -rf /System/Library/Frameworks/Ruby.framework
# echo "Note: This step is risky and could affect system stability."

# Step 6: Cleanup any residual gem installations in the home directory
echo "Cleaning up any residual gem installations in the home directory..."
if [ -d "${HOME}/.gem" ]; then
    rm -rf "${HOME}/.gem"
fi

echo "Environment cleanup is complete. Please restart your terminal."
