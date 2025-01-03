# https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/
FROM --platform=${BUILDPLATFORM} python:3.13-alpine3.21@sha256:657dbdb20479a6523b46c06114c8fec7db448232f956a429d3cc0606d30c1b59 AS build

ARG TARGETARCH
ARG TARGETPLATFORM
ENV XMRIG_VERSION="6.22.2"
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# xmrig
RUN set -eux && \
    # ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), static-pie linked, stripped
    mkdir -p /mnt/xmrig && \
    wget -q "https://github.com/xmrig/xmrig/releases/download/v${XMRIG_VERSION}/xmrig-${XMRIG_VERSION}-linux-static-x64.tar.gz" -O /mnt/xmrig/xmrig-linux-static-x64.tar.gz && \
    tar xvzf /mnt/xmrig/xmrig-linux-static-x64.tar.gz -C /mnt/xmrig/ --strip-components=1 "xmrig-${XMRIG_VERSION}/xmrig"

# Compile own version of xmrig cryptominer
# hadolint ignore=DL3003
# RUN set -eux && \
#     apk add --no-cache automake autoconf cmake g++ gcc git libstdc++ libtool linux-headers make && \
#     git clone --branch "v${XMRIG_VERSION}" https://github.com/xmrig/xmrig && \
#     sed -i \
#       -e "s/\(APP_ID [^\"]*\).*/\1\"myxmrig\"/" \
#       -e "s/\(APP_NAME [^\"]*\).*/\1\"My XMRig\"/" \
#       -e "s/\(APP_DESC [^\"]*\).*/\1\"My XMRig miner\"/" \
#       -e "s/\(APP_VERSION.*\)\"/\1-my-${TARGETARCH}\"/" \
#       xmrig/src/version.h && \
#     mkdir xmrig/build && \
#     cd xmrig/scripts && \
#     ./build_deps.sh && \
#     cd ../build && \
#     cmake .. -DXMRIG_DEPS=scripts/deps -DBUILD_STATIC=ON && \
#     make -j"$(nproc)" && \
#     ../build/xmrig --version && \
#     mv ../build/xmrig /mnt/xmrig/my-xmrig

# EICAR virus test files
RUN set -eux && \
    mkdir -p /mnt/eicar
    # wget -q -P /mnt/eicar https://secure.eicar.org/eicar.com https://secure.eicar.org/eicar.com.txt https://secure.eicar.org/eicarcom2.zip

# windows/macos malware + ransomware for different architectures
RUN set -eux && \
    mkdir -p /mnt/malware && \
    # C source, ASCII text
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Email-Worm/ILOVEYOU.vbs"                                                                                           -O /mnt/malware/ILOVEYOU.vbs && \
    # ASCII text, with very long lines (361)
    wget -q "https://github.com/antonioCoco/ConPtyShell/raw/f5c00d4d37b656092d20447b127eb0774efca96a/Invoke-ConPtyShell.ps1"                                                                                              -O /mnt/malware/Invoke-ConPtyShell.ps1 && \
    # DOS batch file, ASCII text
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Trojan/L0Lz.bat"                                                                                                   -O /mnt/malware/L0Lz.bat && \
    # MS-DOS executable
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Virus/MadMan.exe"                                                                                                  -O /mnt/malware/MadMan.exe && \
    # Composite Document File V2 Document, Little Endian, Os: Windows, Version 4.10, Code page: 1252, Title: Password List for March 26th 1999, Subject: Adult Website Passwords, Author: John Holmes, Keywords: 73 sites in this list, Comments: Password List for March 26th 1999, Template: Normal.dot, Last Saved By: Him, Revision Number: 2, Name of Creating Application: Microsoft Word 8.0, Create Time/Date: Fri Mar 26 11:39:00 1999, Last Saved Time/Date: Fri Mar 26 11:39:00 1999, Number of Pages: 2, Number of Words: 745, Number of Characters: 4249, Security: 0
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Virus/Melissa.doc"                                                                                                 -O /mnt/malware/Melissa.doc && \
    # Mach-O 64-bit x86_64 executable, flags:<NOUNDEFS|DYLDLINK|TWOLEVEL|PIE>
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Trojan/XCSSETMacMalware/TrojanSpy.MacOS.XCSSET.A.6614978ab256f922d7b6dbd7cc15c6136819f4bcfb5a0fead480561f0df54ca6" -O /mnt/malware/TrojanSpy.MacOS.XCSSET.A.bin && \
    # DOS executable (COM)
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Virus/Walker.com"                                                                                                  -O /mnt/malware/Walker.com && \
    # PE32 executable (GUI) Intel 80386, for MS Windows
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Ransomware/WannaCry.exe"                                                                                           -O /mnt/malware/WannaCry.exe && \
    # Microsoft Excel 2007+
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Banking-Malware/Zloader.xlsm"                                                                                      -O /mnt/malware/Zloader.xlsm

# linux malware + ransomware for different architectures
RUN set -eux && \
    # ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), statically linked, with debug_info, not stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Linux.Trojan.Multiverze/0a5a7008fa1a17c8ee32ea4e2f7e25d7302f9dfc4201c16d793a1d03f95b9fa5.elf.x86" -O /mnt/malware/Linux.Trojan.Multiverze.elf.x86 && \
    # ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Trojan.Mirai/40e8d9d82800728a5f1cfc2c2e156d5ee72fb44c54c26a86cfd35e95ea737e37.elf.x86_64"    -O /mnt/malware/Unix.Trojan.Mirai.elf.x86_64 && \
    # ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, Go BuildID=9fdmXJhReUX31Gj9ZEYg/ufudXOOpAambiyMItr13/otwZTTTdWsnO_OuvAAn-/qn6mMLxbKwGft_Ecoum6, stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Malware.Kaiji/3e68118ad46b9eb64063b259fca5f6682c5c2cb18fd9a4e7d97969226b2e6fb4.elf.arm"      -O /mnt/malware/Unix.Malware.Kaiji.elf.arm && \
    # ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), statically linked, for GNU/Linux 2.6.16, with debug_info, not stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Trojan.Spike/04d88a0f5ffa8da57cfd9b1ae6e4fd9758610a3de72688516b258b5564735476.elf.arm"       -O /mnt/malware/Unix.Trojan.Spike.elf.arm && \
    # ELF 32-bit MSB executable, MIPS, MIPS-I version 1 (SYSV), statically linked, not stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Trojan.Mirai/faa0deaba42ba76192609c5d2f59664e871c7bc68ebb5d99c91bf8ea4ddb8ea5.elf.mips"      -O /mnt/malware/Unix.Trojan.Mirai.elf.mips && \
    # ELF 32-bit MSB executable, Motorola m68k, 68020, version 1 (SYSV), statically linked, stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Trojan.Mirai/11242cdb5dac9309a2f330bd0dad96efba9ccc9b9d46f2361e8bf8e4cde543c1.elf.m68k"      -O /mnt/malware/Unix.Trojan.Mirai.elf.m68k && \
    # ELF 32-bit MSB executable, PowerPC or cisco 4500, version 1 (SYSV), statically linked, not stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Trojan.Mirai/d5230c95c4af4e1fcddf9660070932b7876a9569dc3a2baedf762abbe37b1ad5.elf.ppc"       -O /mnt/malware/Unix.Trojan.Mirai.elf.ppc && \
    # ELF 32-bit MSB executable, SPARC, version 1 (SYSV), statically linked, not stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Trojan.Mirai/190333b93af51f9a3e3dc4186e4f1bdb4f92c05d3ce047fbe5c3670d1b5a87b4.elf.sparc"     -O /mnt/malware/Unix.Trojan.Mirai.elf.sparc && \
    # POSIX shell script, ASCII text executable
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Downloader.Rocke/228ec858509a928b21e88d582cb5cfaabc03f72d30f2179ef6fb232b6abdce97.sh"        -O /mnt/malware/Unix.Downloader.Rocke.sh && \
    # Bourne-Again shell script, ASCII text executable
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Txt.Malware.Sustes/0e77291955664d2c25d5bfe617cec12a388e5389f82dee5ae4fd5c5d1f1bdefe.sh"           -O /mnt/malware/Txt.Malware.Sustes.sh && \
    # Perl script text executable
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Win.Trojan.Perl/9aed7ab8806a90aa9fac070fbf788466c6da3d87deba92a25ac4dd1d63ce4c44.perl"            -O /mnt/malware/Win.Trojan.Perl.perl && \
    # Python script, ASCII text executable, with very long lines (4330), with CRLF line terminators
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Py.Trojan.NecroBot/0e600095a3c955310d27c08f98a012720caff698fe24303d7e0dcb4c5e766322.py"           -O /mnt/malware/Py.Trojan.NecroBot.py && \
    # Java archive data (JAR)
    wget -q "https://github.com/HonbraDev/fractureiser-samples/raw/221bcc4bf45d5896f8908b21d5a8f3e7fcbc2875/stage-0-infected-DisplayEntityEditor-1.0.4.jar"                                                                -O /mnt/malware/Trojan.Java.Fractureiser.MTB.jar

# hadolint ignore=DL3003
RUN set -eux && \
    apk add --no-cache clamav file && \
    freshclam --quiet && \
    wget -qO /tmp/genindex.py https://raw.githubusercontent.com/glowinthedark/index-html-generator/915fc3bfeb735bbeba5b730280a491e2b0c08125/genindex.py && \
    chmod a+x /tmp/genindex.py && \
    for DIR in /mnt/eicar/ /mnt/xmrig/ /mnt/malware/; do \
      cd "${DIR}" && \
      file ./* | tee files.txt && \
      ( clamscan --infected --no-summary . | sed "s@${DIR}@@" | tee clamscan.txt || true ) && \
      /tmp/genindex.py --output-file index.html . ; \
    done

COPY README.md /mnt/

RUN set -eux && \
    # renovate: datasource=pypi depName=grip
    GRIP_VERSION="4.6.2" && \
    pip install --no-cache-dir grip=="${GRIP_VERSION}" && \
    grip /mnt/README.md --export /mnt/index.html

################################################################################

FROM nginxinc/nginx-unprivileged:1.27.3-alpine-slim@sha256:4cb29ac34f4bc0571a0c665aa1104974a0724c5a44597e1b697fe4fea45900cd

# renovate: datasource=docker depName=nginxinc/nginx-unprivileged versioning=docker
LABEL org.opencontainers.image.base.name="nginxinc/nginx-unprivileged:1.27.3-alpine-slim"

COPY --from=build /mnt/ /usr/share/nginx/html/

RUN printf '%s\n' > /etc/nginx/conf.d/health.conf \
    'server {' \
    '    listen 8081;' \
    '    location / {' \
    '        access_log off;' \
    '        add_header Content-Type text/plain;' \
    '        return 200 "healthy\n";' \
    '    }' \
    '}'

USER nginx

# Healthcheck to make sure container is ready
HEALTHCHECK --interval=5m --timeout=3s CMD curl --fail http://localhost:8081 || exit 1
