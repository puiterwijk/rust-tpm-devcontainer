FROM fedora:latest

ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="false"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN dnf install -y glibc-langpack-en glibc-locale-source && \
    localedef -i en_US -f UTF-8 en_US.UTF-8

COPY library-scripts/*.sh /tmp/library-scripts/
COPY dbus-policy.conf /etc/dbus-1/system.d/

RUN dnf install -y \
	tpm2-tss-devel tpm2-abrmd tpm2-tools \
	swtpm swtpm-tools \
	rust clippy cargo rls \
	llvm llvm-devel clang pkg-config \
	dbus-daemon

RUN bash /tmp/library-scripts/common-redhat.sh "$INSTALL_ZSH" "$USERNAME" "$USER_UID" "$USER_GID" "$UPGRADE_PACKAGES" "$true"

RUN mkdir /var/lib/tpmstate && \
    swtpm_setup --tpm2 \
        --tpmstate /var/lib/tpmstate \
        --createek --allow-signing --decryption --create-ek-cert \
        --create-platform-cert \
        --display && \
    chown -Rv vscode:vscode /var/lib/tpmstate
