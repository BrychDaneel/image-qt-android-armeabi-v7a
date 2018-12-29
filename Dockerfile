FROM base/archlinux
RUN echo "[multilib]"  >>/etc/pacman.conf &&\
    echo "Include = /etc/pacman.d/mirrorlist"  >>/etc/pacman.conf &&\
    pacman -Syu &&\
    pacman -S --noconfirm base-devel git sudo &&\
    echo "%wheel      ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers &&\
    useradd -m -g users -G lp,power,storage,wheel -s /bin/bash develop &&\
    echo -e "develop\ndevelop" | passwd develop
USER develop
WORKDIR /home/develop
RUN git clone https://aur.archlinux.org/package-query.git &&\
    cd package-query &&\
    yes | makepkg -s &&\
    sudo pacman -U --noconfirm *.pkg.tar.xz &&\
    cd .. &&\
    rm -R package-query &&\
    git clone https://aur.archlinux.org/yaourt.git &&\
    cd yaourt &&\
    yes | makepkg -s &&\
    sudo pacman -U --noconfirm *.pkg.tar.xz &&\
    cd .. &&\
    rm -R yaourt
RUN sudo pacman --noconfirm -S \
    apache-ant \
    libgl \
    sqlite \
    zlib \
    python2 \
    ruby \
    gperf \
    libxslt \
    fontconfig &&\
    sudo ln -s /usr/bin/python2 /usr/bin/python
RUN yaourt --noconfirm -S \
    jre8-openjdk-headless \
    android-sdk-build-tools \
    android-sdk-platform-tools \
    android-sdk \
    android-platform-22 \
    android-ndk
RUN git clone https://github.com/openssl/openssl &&\
    git clone https://aur.archlinux.org/android-armv7a-eabi-qt5.git &&\
    cd android-armv7a-eabi-qt5 &&\
    git checkout dca2b688894a22412f46fe018283ff44657c79f7
COPY qt-PKGBUILD android-armv7a-eabi-qt5/PKGBUILD
RUN cd android-armv7a-eabi-qt5 &&\
    export MAKEFLAGS="-j6" &&\
    makepkg &&\
    sudo pacman -U --noconfirm *.pkg.tar.xz &&\
    cd .. &&\
    rm -R android-armv7a-eabi-qt5
