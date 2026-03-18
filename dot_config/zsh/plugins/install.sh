PLUGINS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plugins"

# Ensure git exists
if ! command -v git &>/dev/null; then
	sudo pacman -S --noconfirm git
fi

# Ensure plugins dir
mkdir -p "$PLUGINS_DIR"

clone_or_pull() {
	local repo_url="$1"
	local target_dir="$2"

	if [[ -d "$target_dir/.git" ]]; then
		git -C "$target_dir" pull --quiet
	else
		git clone --depth 1 "$repo_url" "$target_dir"
	fi
}

# Plugins
clone_or_pull \
	https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
	"$PLUGINS_DIR/fsh"

clone_or_pull \
	https://github.com/zsh-users/zsh-autosuggestions.git \
	"$PLUGINS_DIR/zsh-autosuggestions"

# Theme
THEME_DIR="$PLUGINS_DIR/fsh/themes"

if ! compgen -G "$THEME_DIR/catppuccin-*.ini" >/dev/null; then
	TMP_DIR=$(mktemp -d)

	git clone --depth 1 https://github.com/catppuccin/zsh-fsh.git "$TMP_DIR"

	mkdir -p "$THEME_DIR"
	cp "$TMP_DIR/themes/"catppuccin-*.ini "$THEME_DIR"

	rm -rf "$TMP_DIR"
fi
