if status is-interactive
# Commands to run in interactive sessions can go here
end

# User-installed binaries (fish does not source /etc/profile or ~/.bashrc)
fish_add_path $HOME/.local/bin $HOME/.opencode/bin $HOME/.cargo/bin
