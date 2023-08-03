#!/bin/bash
set -xve

package_name="brightness-xrandr"
aur_project="${package_name}-git"
password="a"

ssh_path="/root/.ssh/"
ssh_config="/root/.ssh/config"
ssh_aur_private="/root/.ssh/aur"
ssh_aur_public="/root/.ssh/aur.pub"
user="immortal"
user_home="/home/${user}"
build_path="${user_home}/build/"
deploy_path="${user_home}/AUR/"
aur_package="${GITHUB_WORKSPACE}/archlinux-aur/"

ls -lha "${GITHUB_WORKSPACE}"

ls -lha "${aur_package}"

useradd -m "${user}"
echo -e "${password}\n${password}" | passwd "${user}" &> /dev/null

# Generate the package with the 'makepkg' command.
mkdir -p "${build_path}"
cd "${build_path}"
pwd
ls -lha .

cp "${aur_package}PKGBUILD" "${build_path}"
pwd
ls -lha .

chown -R "${user}":"${user}" "${build_path}"
pwd
ls -lha .

echo "${password}" | su - "${user}" -c "cd ${build_path}; makepkg --log --force; cat *.log"
pwd
ls -lha .
ls -lha src
cat "*.log"

echo "${password}" | su - "${user}" -c "cd ${build_path}; makepkg --printsrcinfo > .SRCINFO; cat .SRCINFO"
pwd
ls -lha .
cat ".SRCINFO"


# Generate and set up the AUR repository.

rm -f "${ssh_config}"
rm -f "${ssh_aur_private}"
rm -f "${ssh_aur_public}"
rm -fR "${deploy_path}"

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

echo "${SSH_PRIVATE_KEY}" > "${ssh_aur_private}"
chmod 0600 "${ssh_aur_private}"

echo "${SSH_PUBLIC_KEY}" > "${ssh_aur_public}"
chmod 0644 "${ssh_aur_public}"

# Wait until the connection of the Internet is available.
curl -f https://aur.archlinux.org/ &> /dev/null

# Test the connection to the AUR server.
#ssh -Tv -4 aur@aur.archlinux.org

cd "${user_home}" || exit
mkdir -p "${deploy_path}"
chown -R "${user}":"${user}" "${deploy_path}"

cd "${deploy_path}" || exit
git clone "ssh://aur@aur.archlinux.org/${aur_project}.git"

cd "${aur_project}" || exit
#cp -f "${aur_package}"* .
chown -R "${user}":"${user}" "${deploy_path}"

pwd
#echo "${password}" | su - "${user}" -c "cd ${aur_package}; makepkg --log --force; cat *.log"
pwd
ls -lha .
ls -lha "${aur_package}"
ls -lha "${deploy_path}"
ls -lha "${deploy_path}/${aur_project}"
#rm -fR "*${package_name}*" pkg src .SRCINFO
pwd
echo "${password}" | su - "${user}" -c "cp ${aur_package}/.SRCINFO ${deploy_path}/${aur_project}.SRCINFO"
pwd

git config user.email "israel.alberto.rv@gmail.com"
git config user.name "Israel Roldan"
git add .
git commit -m "Automatic deployment on $(date) from the official repository in GitHub using CI (Continuous Integration)."
commit_hash=$(git rev-parse HEAD)
git push

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
