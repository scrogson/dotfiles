GITHUB_ENTERPRISE_DOMAIN=github.example.com

# Allows you to use hub(1) with your GitHub Enterprise
# account without setting it globally in your ~/.gitconfig.
# Example: `ghe clone username/repo`
function ghe() {
  GITHUB_HOST=$GITHUB_ENTERPRISE_DOMAIN git $*
}

# Setup an existing repo to use GitHub Enterprie exclusively
function ghe-setup() {
  git config --add hub.host $GITHUB_ENTERPRISE_DOMAIN
}
