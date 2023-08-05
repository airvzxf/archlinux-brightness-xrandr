#!/usr/bin/env bash
set +xv
set -e

# -------------- #
# Bash functions #
# -------------- #

# Check if the environment variable was set from Docker. Otherwise, exit.
validate_environment_variable() {
  if [[ -z ${!1} ]]; then
    echo "ERROR: The environment variable ${1}, needs to be set from Docker."
    exit 1
  else
    echo "${1}: ${!1}"
  fi
}

# --------------------- #
# Environment variables #
# --------------------- #

# Environment variables needs to set from Docker.
validate_environment_variable ENV_GITHUB_OWNER
validate_environment_variable ENV_GITHUB_REPOSITORY
validate_environment_variable ENV_PACKAGE_ARCHITECTURES
validate_environment_variable ENV_PACKAGE_DEPENDENCIES
validate_environment_variable ENV_PACKAGE_DESCRIPTION
validate_environment_variable ENV_PACKAGE_INFORMATION
validate_environment_variable ENV_PACKAGE_LICENSES
validate_environment_variable ENV_PACKAGE_NAME
validate_environment_variable ENV_PACKAGE_PGPS
validate_environment_variable ENV_PACKAGE_RELEASE
validate_environment_variable ENV_PACKAGE_VERSION
validate_environment_variable ENV_SSH_PRIVATE_KEY
validate_environment_variable ENV_SSH_PUBLIC_KEY

# Environment variables which are optional to set from Docker.
echo "ENV_PACKAGE_SOURCES: ${ENV_PACKAGE_SOURCES}"
echo "ENV_PACKAGE_SOURCE_GITHUB: ${ENV_PACKAGE_SOURCE_GITHUB}"
echo "ENV_GITHUB_TAG_VERSION_PREFIX: ${ENV_GITHUB_TAG_VERSION_PREFIX}"
echo "ENV_GITHUB_TAG_VERSION_SUFFIX: ${ENV_GITHUB_TAG_VERSION_SUFFIX}"

# Environment variables set from Dockerfile.
validate_environment_variable ENV_USER_GROUP
validate_environment_variable ENV_USER_HOME
validate_environment_variable ENV_USER_ID

# Variables auto-generated. The order could affect the operation.
AUTO_GITHUB_TAG_VERSION="${ENV_GITHUB_TAG_VERSION_PREFIX}${ENV_PACKAGE_VERSION}${ENV_GITHUB_TAG_VERSION_SUFFIX}"
AUTO_GITHUB_REPOSITORY_UID="${ENV_GITHUB_OWNER}/${ENV_GITHUB_REPOSITORY}"
AUTO_GITHUB_URL="https://github.com/${AUTO_GITHUB_REPOSITORY_UID}"
AUTO_PACKAGE_SOURCES_GIT="${ENV_GITHUB_REPOSITORY}-${ENV_PACKAGE_VERSION}.tar.gz::${AUTO_GITHUB_URL}/archive/refs/tags/${AUTO_GITHUB_TAG_VERSION}.tar.gz"
AUTO_SOURCE_DOWNLOADED="${ENV_GITHUB_REPOSITORY}-${ENV_PACKAGE_VERSION}"
AUTO_PACKAGE_SOURCES=""
if [[ -n ${ENV_PACKAGE_SOURCE_GITHUB} ]]; then
  AUTO_PACKAGE_SOURCES+="'${AUTO_PACKAGE_SOURCES_GIT}'"
fi
if [[ -n ${ENV_PACKAGE_SOURCES} ]]; then
  if [[ -n ${ENV_PACKAGE_SOURCE_GITHUB} ]]; then
    AUTO_PACKAGE_SOURCES+=" "
  fi
  AUTO_PACKAGE_SOURCES+="${ENV_PACKAGE_SOURCES}"
fi

echo "AUTO_GITHUB_TAG_VERSION: ${AUTO_GITHUB_TAG_VERSION}"
echo "AUTO_GITHUB_REPOSITORY_UID: ${AUTO_GITHUB_REPOSITORY_UID}"
echo "AUTO_GITHUB_URL: ${AUTO_GITHUB_URL}"
echo "AUTO_PACKAGE_SOURCES_GIT: ${AUTO_PACKAGE_SOURCES_GIT}"
echo "AUTO_PACKAGE_SOURCES: ${AUTO_PACKAGE_SOURCES}"
echo "AUTO_SOURCE_DOWNLOADED: ${AUTO_SOURCE_DOWNLOADED}"

# TODO: Figure out a solution for send multiple values in the Environment variables.
# ENV_PACKAGE_ARCHITECTURES
# - x86_64
# - ...
# ENV_PACKAGE_LICENSES
# - GPL3
# - ...
# ENV_PACKAGE_DEPENDENCIES
# - bash
# - xorg-xrandr
# - grep
# - coreutils
# - sed
# - bc
# AUTO_PACKAGE_SOURCES
# - 'ENV_GITHUB_REPOSITORY-ENV_PACKAGE_VERSION.tar.gz::AUTO_GITHUB_URL/archive/refs/tags/ENV_GITHUB_TAG_VERSION_PREFIX.tar.gz'
# - ...
# ENV_PACKAGE_SOURCES
# - 'hello.bash'
# - ...
# AUTO_PACKAGE_SUMS
# - SKIP
# - ...
# ENV_PACKAGE_PGPS
# - 63ADA633FE7468630D9BC56175530B8B9F74CF3A # PGP: Israel Roldan (airvzxf) <israel.alberto.rv@gmail.com>, https://github.com/airvzxf.gpg
# - ...
# AUTO_SOURCE_DOWNLOADED
# - ENV_GITHUB_REPOSITORY-ENV_PACKAGE_VERSION
# ENV_PACKAGE_INFORMATION
# - # Maintainer: Israel Roldan <israel.alberto.rv@gmail.com>
# - # ...

#printenv

# ---------------- #
# Custom variables #
# ---------------- #

# Custom variables.
build_package=01-build-package

# Custom variables: auto-generated.
ssh_path="${ENV_USER_HOME}/.ssh"
ssh_config="${ssh_path}/config"
ssh_aur_private="${ssh_path}/aur"
ssh_aur_public="${ssh_path}/aur.pub"
url_pkgbuild_file="https://raw.githubusercontent.com/${AUTO_GITHUB_REPOSITORY_UID}/${AUTO_GITHUB_TAG_VERSION}/archlinux-aur/PKGBUILD"
#aur_project="${package_name}-git"

# Path variables
#user="immortal"
#user_home="/home/${user}"
#make_package_path="${user_home}/makepkg/"
#repository_path="${user_home}/repository/"
#deploy_path="${user_home}/AUR/"
##aur_package="${GITHUB_WORKSPACE}/archlinux-aur/"

# ----------- #
# Basic setup #
# ----------- #

set -ve

# TODO: Remove all the below commands.
sleep 2
ls -lha /github/workspace
sleep 2
echo "[safe]" | tee -a /github/workspace/.gitconfig
sleep 2
echo "    directory = /github/workspace" | tee -a /github/workspace/.gitconfig
sleep 2
cat /github/workspace/.gitconfig
sleep 2
git describe --long --tags --all || true
sleep 2
git describe --long || true
sleep 2
git log -n 3 || true
sleep 2
git name-rev --tags --name-only "$(git rev-parse HEAD)" || true
sleep 2
git rev-parse HEAD || true
sleep 2
git show-ref --tags -d || true
sleep 2
git show-ref --tags || true
sleep 2
git status || true
sleep 2
git symbolic-ref -q --short HEAD || true
sleep 2
git tag --list || true
sleep 2
git tag --points-at HEAD || true
sleep 2
git tag -n || true
sleep 2
git tag || true
sleep 2

# Go to the user home directory.
cd "${ENV_USER_HOME}" || exit 1

# ----------------- #
# Build the package #
# ----------------- #

# Create directory and enter to it.
mkdir --parents "${build_package}"
cd "${build_package}" || exit 1
#curl --output PKGBUILD "${url_pkgbuild_file}"

# Replace the variables in the PKGBUILD file.
sed --in-place 's|ENV_PACKAGE_INFORMATION|'"${ENV_PACKAGE_INFORMATION}"'|g' PKGBUILD
sed --in-place 's|ENV_PACKAGE_NAME|'"${ENV_PACKAGE_NAME}"'|g' PKGBUILD
sed --in-place 's|ENV_PACKAGE_VERSION|'"${ENV_PACKAGE_VERSION}"'|g' PKGBUILD
sed --in-place 's|ENV_PACKAGE_RELEASE|'"${ENV_PACKAGE_RELEASE}"'|g' PKGBUILD
sed --in-place 's|ENV_PACKAGE_DESCRIPTION|'"${ENV_PACKAGE_DESCRIPTION}"'|g' PKGBUILD
sed --in-place 's|ENV_PACKAGE_ARCHITECTURES|'"${ENV_PACKAGE_ARCHITECTURES}"'|g' PKGBUILD
sed --in-place 's|ENV_PACKAGE_LICENSES|'"${ENV_PACKAGE_LICENSES}"'|g' PKGBUILD
sed --in-place 's|ENV_PACKAGE_DEPENDENCIES|'"${ENV_PACKAGE_DEPENDENCIES}"'|g' PKGBUILD
sed --in-place 's|ENV_PACKAGE_PGPS|'"${ENV_PACKAGE_PGPS}"'|g' PKGBUILD
sed --in-place 's|AUTO_GITHUB_URL|'"${AUTO_GITHUB_URL}"'|g' PKGBUILD
sed --in-place 's|AUTO_PACKAGE_SOURCES|'"${AUTO_PACKAGE_SOURCES}"'|g' PKGBUILD
sed --in-place 's|AUTO_SOURCE_DOWNLOADED|'"${AUTO_SOURCE_DOWNLOADED}"'|g' PKGBUILD

# Replace the variables in the PKGBUILD file.
AUTO_PACKAGE_SUMS="$(makepkg --geninteg 2> /dev/null)"
AUTO_PACKAGE_SUMS="${AUTO_PACKAGE_SUMS// /}"
AUTO_PACKAGE_SUMS="${AUTO_PACKAGE_SUMS//$'\n'/ }"
sed --in-place 's|md5sums=(AUTO_PACKAGE_SUMS)|'"${AUTO_PACKAGE_SUMS}"'|g' PKGBUILD

# Display the PKGBUILD file.
cat PKGBUILD

# Analyze the PKGBUILD file.
namcap --info PKGBUILD
namcap --info PKGBUILD | grep --quiet '[WE]:' && {
  echo "ERROR: The package builder file (PKGBUILD) needs improvements."
  exit 1
}

# Build the package and check it.
makepkg --log --check

# Generate the source information file.
makepkg --printsrcinfo > .SRCINFO

# TODO: Remove this command.
ls -lha .

# ------------------- #
# Set up AUR SSH keys #
# ------------------- #

set -xve

cd "${ENV_USER_HOME}" || exit 1

# TODO: Remove these commands.
pwd
ls -lha .

# Remove the AUR SSH keys.
rm --force "${ssh_aur_private}"
rm --force "${ssh_aur_public}"

# Create the SSH directory.
mkdir --parents "${ssh_path}"
chmod 0700 "${ssh_path}"
cd "${ssh_path}" || exit 1

# TODO: Remove these commands.
pwd
ls -lha .

# If the SSH configuration file not exists, it creates one.
if [ ! -f "${ssh_config}" ]; then
  touch "${ssh_config}"
fi

# TODO: Remove these commands.
pwd
ls -lha .

# If the AUR is not in the configuration file, then added it.
if ! grep --ignore-case "Host aur.archlinux.org" &> /dev/null < "${ssh_config}"; then
  (
    echo "Host aur.archlinux.org"
    echo "  IdentityFile ${ssh_aur_private}"
    echo "  User aur"
    echo "  StrictHostKeyChecking no"
  ) >> "${ssh_config}"
fi

# TODO: Remove these commands.
cat "${ssh_config}"

# Added the AUR SSH private key.
echo "${ENV_SSH_PRIVATE_KEY}" > "${ssh_aur_private}"
chmod 0600 "${ssh_aur_private}"

# Added the AUR SSH public key.
echo "${ENV_SSH_PUBLIC_KEY}" > "${ssh_aur_public}"
chmod 0644 "${ssh_aur_public}"

# TODO: Remove these commands.
pwd
ls -lha .

# --------------------------- #
# Check AUR server connection #
# --------------------------- #

# Wait until the connection of the Internet is available.
curl --fail https://aur.archlinux.org/ &> /dev/null

# Test the connection to the AUR server.
#ssh -Tvvv -4 aur@aur.archlinux.org

exit 0
# --------------------- #
# Environment variables #
# --------------------- #

# Generate and set up the AUR repository.
cd "${user_home}" || exit 1
rm --force --recursive "${deploy_path}"
mkdir -p "${deploy_path}"
chown -R "${user}":"${user}" "${deploy_path}"

cd "${deploy_path}" || exit 1
git clone "ssh://aur@aur.archlinux.org/${aur_project}.git"

cd "${aur_project}" || exit 1
cp "${aur_package}.SRCINFO" "${deploy_path}${aur_project}/.SRCINFO"
chown -R "${user}":"${user}" "${deploy_path}"

git config --global --add safe.directory "${deploy_path}${aur_project}"
git status

git config user.email "israel.alberto.rv@gmail.com"
git config user.name "Israel Roldan"
git add .
git commit -m "Automatic deployment on '$(date)' from the official repository in GitHub using CI."
commit_hash=$(git rev-parse HEAD)
if [[ "${ENV_IS_PRODUCTION}" = "true" ]]; then
  git push
fi

cd "${user_home}" || exit 1
rm --force "${ssh_config}"
rm --force "${ssh_aur_private}"
rm --force "${ssh_aur_public}"
rm --force --recursive "${deploy_path}"

# --------------------- #
# Environment variables #
# --------------------- #

echo "# ------------------------------------------------"
echo "# SUCCESS DEPLOYMENT"
echo "# ------------------------------------------------"
echo "Review this link to check the commit in the AUR"
echo "https://aur.archlinux.org/cgit/aur.git/commit/?h=${aur_project}&id=${commit_hash}"
