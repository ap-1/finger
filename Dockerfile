FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Download cfingerd source
RUN wget http://www.infodrom.org/projects/cfingerd/download/cfingerd-1.4.3.tar.gz && \
    tar xzf cfingerd-1.4.3.tar.gz

WORKDIR /build/cfingerd-1.4.3

# Enable DAEMON_MODE
RUN sed -i 's|/\* #define DAEMON_MODE \*/|#define DAEMON_MODE|' src/config.h

# Build cfingerd
RUN make && make install

# Cleanup
WORKDIR /
RUN rm -rf /build

# Create user
RUN useradd -m -c "Anish Pallati" -s /bin/zsh apallati

# Copy files into the image
COPY cfingerd.conf /etc/cfingerd.conf
COPY pgpkey.asc /home/apallati/.pgpkey
COPY nouser_banner.txt /etc/cfingerd/nouser_banner.txt

RUN chown apallati:apallati /home/apallati/.pgpkey /etc/cfingerd/nouser_banner.txt

# Run cfingerd
EXPOSE 79
CMD ["cfingerd", "-d"]
