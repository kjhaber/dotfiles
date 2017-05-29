# Install Rust:
#(see https://rustup.rs/)
curl https://sh.rustup.rs -sSf | sh

# Also include zsh completions
rustup completions zsh > ~/.zsh/completion/_rustup
rustup component add rust-src

# install rust tools
cargo install rustfmt
cargo install racer

