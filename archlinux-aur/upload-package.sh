#!/bin/bash

# Steps:
# First in the main project / git repository needs to create an annotated tag and push it.
# - git tag -a v1.0.0 -m "Release version 1.0.0. Upgraded all the features with dark colors."
# - git push origin --tags
# Then go outside of this project folder and clone the AUR repository after this run this script.
# - git clone ssh://aur@aur.archlinux.org/archlinux-brightness-xrandr-git.git
# - cd archlinux-brightness-xrandr-git/src
# - ./upload-package.sh
# If you are in the AUR repository from your local computer, and you don't know what files are needed, download these:
# - https://raw.githubusercontent.com/airvzxf/archlinux-brightness-xrandr/main/archlinux-aur/PKGBUILD
# - https://raw.githubusercontent.com/airvzxf/archlinux-brightness-xrandr/main/archlinux-aur/upload-package.sh

makepkg -f
rm -fR brightness-xrandr* pkg src .SRCINFO
makepkg --printsrcinfo > .SRCINFO
echo ""

git diff --exit-code
git add .
git status

echo "Write your commit comment: "
read -r COMMENT
git commit -m "${COMMENT}"
echo ""

git push
echo ""
