#!/usr/bin/env bash
set +xve

# Check if the environment variable was set from Docker. Otherwise, exit.
validate_environment_variable() {
  if [[ -z ${!1} ]]; then
    echo "ERROR: The environment variable ${1}, needs to be set from Docker."
    exit 1
  else
    echo "${1}: ${!1}"
  fi
}

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

# Custom variables.
build_package=01-build-package

# Custom variables: auto-generated.
#github_repository_url="https://github.com/${ENV_GITHUB_OWNER}/${ENV_GITHUB_REPOSITORY}"
url_pkgbuild_file="https://raw.githubusercontent.com/${AUTO_GITHUB_REPOSITORY_UID}/${AUTO_GITHUB_TAG_VERSION}/archlinux-aur/PKGBUILD"
#aur_project="${package_name}-git"

# Path variables
#ssh_path="/root/.ssh"
#ssh_config="${ssh_path}/config"
#ssh_aur_private="${ssh_path}/aur"
#ssh_aur_public="${ssh_path}/aur.pub"
#user="immortal"
#user_home="/home/${user}"
#make_package_path="${user_home}/makepkg/"
#repository_path="${user_home}/repository/"
#deploy_path="${user_home}/AUR/"
##aur_package="${GITHUB_WORKSPACE}/archlinux-aur/"

set -xve

# Download the PKGBUILD and build it.
mkdir --parents "${build_package}"
cd "${build_package}"
#curl --output PKGBUILD "${url_pkgbuild_file}"

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

AUTO_PACKAGE_SUMS="$(makepkg --geninteg 2> /dev/null)"
AUTO_PACKAGE_SUMS="${AUTO_PACKAGE_SUMS// /}"
AUTO_PACKAGE_SUMS="${AUTO_PACKAGE_SUMS//$'\n'/ }"
sed --in-place 's|md5sums=(AUTO_PACKAGE_SUMS)|'"${AUTO_PACKAGE_SUMS}"'|g' PKGBUILD

namcap -i PKGBUILD
namcap -i PKGBUILD | grep --quiet '[WE]:' && {
  echo "ERROR: The package builder file (PKGBUILD) needs improvements."
  exit 1
}

makepkg --log --check
makepkg --printsrcinfo > .SRCINFO
ls -lha .

cat PKGBUILD
exit 0

# Create the AUR SSH keys.
rm -f "${ssh_config}"
rm -f "${ssh_aur_private}"
rm -f "${ssh_aur_public}"

mkdir -p "${ssh_path}"
chmod 0700 "${ssh_path}"

if [ ! -f "${ssh_config}" ]; then
  touch "${ssh_config}"
fi

if ! grep -i "Host aur.archlinux.org" &> /dev/null < "${ssh_config}"; then
  (
    echo "Host aur.archlinux.org"
    echo "  IdentityFile ${ssh_aur_private}"
    echo "  User aur"
    echo "  StrictHostKeyChecking no"
  ) >> "${ssh_config}"
fi

echo "${ENV_SSH_PRIVATE_KEY}" > "${ssh_aur_private}"
chmod 0600 "${ssh_aur_private}"

echo "${ENV_SSH_PUBLIC_KEY}" > "${ssh_aur_public}"
chmod 0644 "${ssh_aur_public}"

# Wait until the connection of the Internet is available.
curl -f https://aur.archlinux.org/ &> /dev/null

# Test the connection to the AUR server.
#ssh -Tvvv -4 aur@aur.archlinux.org

# Generate and set up the AUR repository.
cd "${user_home}" || exit
rm -fR "${deploy_path}"
mkdir -p "${deploy_path}"
chown -R "${user}":"${user}" "${deploy_path}"

cd "${deploy_path}" || exit
git clone "ssh://aur@aur.archlinux.org/${aur_project}.git"

cd "${aur_project}" || exit
cp "${aur_package}.SRCINFO" "${deploy_path}${aur_project}/.SRCINFO"
chown -R "${user}":"${user}" "${deploy_path}"

git config --global --add safe.directory "${deploy_path}${aur_project}"
git status

git config user.email "israel.alberto.rv@gmail.com"
git config user.name "Israel Roldan"
git add .
git commit -m "Automatic deployment on '$(date)' from the official repository in GitHub using CI."
commit_hash=$(git rev-parse HEAD)
if [[ -n ${ENV_IS_PRODUCTION} ]]; then
  git push
fi

cd "${user_home}" || exit
rm -f "${ssh_config}"
rm -f "${ssh_aur_private}"
rm -f "${ssh_aur_public}"
rm -fR "${deploy_path}"

echo "# ------------------------------------------------"
echo "# SUCCESS DEPLOYMENT"
echo "# ------------------------------------------------"
echo "Review this link to check the commit in the AUR"
echo "https://aur.archlinux.org/cgit/aur.git/commit/?h=${aur_project}&id=${commit_hash}"
