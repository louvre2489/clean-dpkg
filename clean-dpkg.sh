USER=$(whoami)

if [ ${USER} -ne "root" ]
then
  echo "Please use with sudo"
  exit 1
fi

LATEST=$(dpkg --list | grep -E -o "linux-image-[0-9]+\.[0-9]+\.[0-9]+-[0-9]+-generic" | grep -o -E "[0-9]+\.[0-9]+\.[0-9]+-[0-9]+" | uniq | sort -n -r | head -1)

TARGETS=$(dpkg --list | grep -E -o "linux-image-[0-9]+\.[0-9]+\.[0-9]+-[0-9]+-generic" | grep -o -E "[0-9]+\.[0-9]+\.[0-9]+-[0-9]+" | uniq | grep -E -v ${LATEST})

for pkg_ver in ${TARGETS}
do
  for pkg_prefix in linux-headers- linux-image-
  do
    apt autoremove --purge -y ${pkg_prefix}${pkg_ver}*
  done
done

update-grub
