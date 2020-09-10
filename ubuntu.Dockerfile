FROM ubuntu:focal

RUN apt update && \
    apt install -y --no-install-recommends openssh-server sudo augeas-tools rsync python3 && \
    rm -rf /var/lib/apt/lists/*

RUN adduser --gecos '' --disabled-password ubuntu && \
    echo 'ubuntu:ubuntu' | chpasswd && \
    adduser ubuntu sudo && \
    mkdir -p ~ubuntu/.ssh ~root/.ssh /etc/authorized_keys && chmod 700 ~root/.ssh/ ~ubuntu/.ssh  && chown ubuntu:ubuntu ~ubuntu/.ssh && \
    augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile ".ssh/authorized_keys /etc/authorized_keys/%u"' && \
    augtool 'set /files/etc/ssh/sshd_config/Port "22"' && \
    cp -a /etc/ssh /etc/ssh.cache

EXPOSE 22

COPY entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
