# https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/
FROM node:lts-alpine@sha256:152270cd4bd094d216a84cbc3c5eb1791afb05af00b811e2f0f04bdc6c473602

SHELL ["/bin/ash", "-euxo", "pipefail", "-c"]

RUN --mount=type=secret,id=github_token \
    GITHUB_TOKEN="$(cat /run/secrets/github_token)" && \
    export GITHUB_TOKEN && \
    set -eux && \
    mkdir -p malware && \
    # ILOVEYOU worm (VBScript)
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Email-Worm/ILOVEYOU.vbs" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/ILOVEYOU.vbs && \
    # PowerShell reverse shell
    wget -q "https://github.com/antonioCoco/ConPtyShell/raw/f5c00d4d37b656092d20447b127eb0774efca96a/Invoke-ConPtyShell.ps1" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Invoke-ConPtyShell.ps1 && \
    # DOS batch file
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Trojan/L0Lz.bat" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/L0Lz.bat && \
    # MS-DOS executable
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Virus/MadMan.exe" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/MadMan.exe && \
    # Melissa macro virus (Word document)
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Virus/Melissa.doc" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Melissa.doc && \
    # XCSSET Mac malware (Mach-O binary)
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Trojan/XCSSETMacMalware/TrojanSpy.MacOS.XCSSET.A.6614978ab256f922d7b6dbd7cc15c6136819f4bcfb5a0fead480561f0df54ca6" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/TrojanSpy.MacOS.XCSSET.A.bin && \
    # DOS executable (COM)
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Virus/Walker.com" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Walker.com && \
    # WannaCry ransomware (Windows PE)
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Ransomware/WannaCry.exe" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/WannaCry.exe && \
    # Zloader banking malware (Excel macro)
    wget -q "https://github.com/Da2dalus/The-MALWARE-Repo/raw/e8ddc517b4ecd80728e0acef1c558fad9a1c888a/Banking-Malware/Zloader.xlsm" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Zloader.xlsm

# linux malware + ransomware for different architectures
RUN --mount=type=secret,id=github_token \
    GITHUB_TOKEN="$(cat /run/secrets/github_token)" && \
    export GITHUB_TOKEN && \
    set -eux && \
    # ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), statically linked, with debug_info, not stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Linux.Trojan.Multiverze/0a5a7008fa1a17c8ee32ea4e2f7e25d7302f9dfc4201c16d793a1d03f95b9fa5.elf.x86" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Linux.Trojan.Multiverze.elf.x86 && \
    # ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Trojan.Mirai/40e8d9d82800728a5f1cfc2c2e156d5ee72fb44c54c26a86cfd35e95ea737e37.elf.x86_64" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Unix.Trojan.Mirai.elf.x86_64 && \
    # ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, Go BuildID=9fdmXJhReUX31Gj9ZEYg/ufudXOOpAambiyMItr13/otwZTTTdWsnO_OuvAAn-/qn6mMLxbKwGft_Ecoum6, stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Malware.Kaiji/3e68118ad46b9eb64063b259fca5f6682c5c2cb18fd9a4e7d97969226b2e6fb4.elf.arm" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Unix.Malware.Kaiji.elf.arm && \
    # ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), statically linked, for GNU/Linux 2.6.16, with debug_info, not stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Trojan.Spike/04d88a0f5ffa8da57cfd9b1ae6e4fd9758610a3de72688516b258b5564735476.elf.arm" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Unix.Trojan.Spike.elf.arm && \
    # ELF 32-bit MSB executable, MIPS, MIPS-I version 1 (SYSV), statically linked, not stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Trojan.Mirai/faa0deaba42ba76192609c5d2f59664e871c7bc68ebb5d99c91bf8ea4ddb8ea5.elf.mips" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Unix.Trojan.Mirai.elf.mips && \
    # ELF 32-bit MSB executable, Motorola m68k, 68020, version 1 (SYSV), statically linked, stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Trojan.Mirai/11242cdb5dac9309a2f330bd0dad96efba9ccc9b9d46f2361e8bf8e4cde543c1.elf.m68k" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Unix.Trojan.Mirai.elf.m68k && \
    # ELF 32-bit MSB executable, PowerPC or cisco 4500, version 1 (SYSV), statically linked, not stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Trojan.Mirai/d5230c95c4af4e1fcddf9660070932b7876a9569dc3a2baedf762abbe37b1ad5.elf.ppc" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Unix.Trojan.Mirai.elf.ppc && \
    # ELF 32-bit MSB executable, SPARC, version 1 (SYSV), statically linked, not stripped
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Trojan.Mirai/190333b93af51f9a3e3dc4186e4f1bdb4f92c05d3ce047fbe5c3670d1b5a87b4.elf.sparc" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Unix.Trojan.Mirai.elf.sparc && \
    # POSIX shell script, ASCII text executable
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Unix.Downloader.Rocke/228ec858509a928b21e88d582cb5cfaabc03f72d30f2179ef6fb232b6abdce97.sh" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Unix.Downloader.Rocke.sh && \
    # Bourne-Again shell script, ASCII text executable
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Txt.Malware.Sustes/0e77291955664d2c25d5bfe617cec12a388e5389f82dee5ae4fd5c5d1f1bdefe.sh" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Txt.Malware.Sustes.sh && \
    # Perl script text executable
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Win.Trojan.Perl/9aed7ab8806a90aa9fac070fbf788466c6da3d87deba92a25ac4dd1d63ce4c44.perl" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Win.Trojan.Perl.perl && \
    # Python script, ASCII text executable, with very long lines (4330), with CRLF line terminators
    wget -q "https://github.com/timb-machine/linux-malware/raw/ca4750299f0090242a3d31da1f8d8764cdb97269/malware/binaries/Py.Trojan.NecroBot/0e600095a3c955310d27c08f98a012720caff698fe24303d7e0dcb4c5e766322.py" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Py.Trojan.NecroBot.py && \
    # Java archive data (JAR)
    wget -q "https://github.com/HonbraDev/fractureiser-samples/raw/221bcc4bf45d5896f8908b21d5a8f3e7fcbc2875/stage-0-infected-DisplayEntityEditor-1.0.4.jar" \
      --header="Authorization: token ${GITHUB_TOKEN}" \
      -O malware/Trojan.Java.Fractureiser.MTB.jar
