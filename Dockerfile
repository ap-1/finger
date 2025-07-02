FROM debian:stable-slim

# Install cfingerd and inetutils-inetd (provides inetd)
RUN apt-get update && \
    apt-get install -y cfingerd inetutils-inetd && \
    rm -rf /var/lib/apt/lists/*

# Create user
RUN useradd -m -c "Anish Pallati" -s /bin/zsh apallati

# Copy files into the image
COPY cfingerd.conf /etc/cfingerd.conf
COPY pgpkey.asc /home/apallati/.pgpkey
COPY nouser_banner.txt /etc/cfingerd/nouser_banner.txt

RUN chown apallati:apallati /home/apallati/.pgpkey /etc/cfingerd/nouser_banner.txt

# Add inetd configuration
COPY inetd.conf /etc/inetd.conf

# Expose finger port
EXPOSE 79

# Run inetd in the foreground
CMD ["inetd", "-d"]
