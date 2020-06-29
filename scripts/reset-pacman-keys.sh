rm -r /etc/pacman.d/gnupg
rm -r /root/.gnupg
gpg --refresh-keys
pacman-key --init
pacman-key --populate
pacman-key --refresh-keys