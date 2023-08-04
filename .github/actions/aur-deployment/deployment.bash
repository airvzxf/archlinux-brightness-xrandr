#!/usr/bin/env bash
set +xve

validate_environment_variable() {
  if [[ -z "${!1}" ]]; then
    echo "ERROR: The environment variable ${1}, needs to be set from Docker."
    exit 1
  else
    echo "${1}: ${!1}"
  fi
}

# Environment variables needs to set from Docker.
validate_environment_variable ENV_PACKAGE_NAME
validate_environment_variable ENV_GITHUB_TAG_VERSION
validate_environment_variable ENV_GITHUB_OWNER
validate_environment_variable ENV_GITHUB_REPOSITORY
validate_environment_variable ENV_SSH_PUBLIC_KEY
validate_environment_variable ENV_SSH_PRIVATE_KEY

# Environment variables set from Dockerfile.
validate_environment_variable ENV_USER_ID
validate_environment_variable ENV_USER_GROUP
validate_environment_variable ENV_USER_PASSWORD
validate_environment_variable ENV_BUILD_PACKAGE
validate_environment_variable ENV_PACKAGE_NAME
validate_environment_variable ENV_USER_HOME

#printenv

# Custom variables
build_package=01-build-package
#package_name='brightness-xrandr'
#version='v1.0.0'
#git_owner='airvzxf'
#git_repository_name="archlinux-${package_name}"

# Custom variables: Auto generated
#github_repository_url="https://github.com/${ENV_GITHUB_OWNER}/${ENV_GITHUB_REPOSITORY}"
url_pkgbuild_file="https://raw.githubusercontent.com/${ENV_GITHUB_OWNER}/${ENV_GITHUB_REPOSITORY}/${ENV_GITHUB_TAG_VERSION}/archlinux-aur/PKGBUILD"
#aur_project="${package_name}-git"

is_production="false"
if [[ -n ${ENV_IS_PRODUCTION} ]]; then
  is_production="${ENV_IS_PRODUCTION}"
fi

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
curl --output PKGBUILD "${url_pkgbuild_file}"
makepkg --log --force
makepkg --printsrcinfo > .SRCINFO
ls -lha .

exit 0
# TODO: Generate the MD5 sum for tar file.
#makepkg --geninteg

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
if [[ ${is_production} == true ]]; then
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
