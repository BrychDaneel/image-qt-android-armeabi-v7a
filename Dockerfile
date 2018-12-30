FROM brychdaneel/archlinux-yaourt
MAINTAINER Brychikov Daneel <brychdaneel@mail.ru>

RUN sudo pacman --noconfirm -S \
        jre8-openjdk-headless \
        jdk8-openjdk \
        apache-ant \
        libglvnd \
        sqlite \
        zlib \
        python2 \
        ruby \
        gperf \
        libxslt \
        fontconfig \
        libxtst \
        lib32-gcc-libs \
        lib32-glibc \
        libxrender &&\
    sudo ln -s /usr/bin/python2 /usr/bin/python

RUN yaourt --noconfirm -S \
        android-sdk-build-tools \
        android-sdk-platform-tools \
        android-sdk

RUN yaourt --noconfirm -S android-ndk

RUN yaourt --noconfirm -S android-platform-28

COPY qt-PKGBUILD ./qt-PKGBUILD

#TODO: build openssl from sorce(old version of ndk is required)
RUN git clone --depth=1 https://github.com/PurpleI2P/OpenSSL-for-Android-Prebuilt &&\
    \
    git clone --depth=1  https://aur.archlinux.org/android-armv7a-eabi-qt5.git &&\
    cd android-armv7a-eabi-qt5 &&\
    git checkout dca2b688894a22412f46fe018283ff44657c79f7 &&\
    sudo mv ../qt-PKGBUILD PKGBUILD &&\
    \
    export MAKEFLAGS="-j6" &&\
    makepkg &&\
    sudo pacman -U --noconfirm *.pkg.tar &&\
    \
    cd .. &&\
    rm -R android-armv7a-eabi-qt5 &&\
    rm -R OpenSSL-for-Android-Prebuilt &&\
    sudo ln -s /opt/android-libs/armv7a-eabi/bin/qmake /usr/bin/qmake &&\
    sudo ln -s /opt/android-libs/armv7a-eabi/bin/androiddeployqt /usr/bin/androiddeployqt
