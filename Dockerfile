FROM debian:stable-slim

# Install cfingerd
RUN apt-get update && apt-get install -y cfingerd

# Create user
RUN useradd -m -c "Anish Pallati" -s /bin/zsh apallati

# Copy files into the image
COPY cfingerd.conf /etc/cfingerd.conf
COPY pgpkey.asc /home/apallati/.pgpkey
COPY nouser_banner.txt /etc/cfingerd/nouser_banner.txt

RUN chown apallati:apallati /home/apallati/.pgpkey /etc/cfingerd/nouser_banner.txt

# Expose the finger service port
EXPOSE 79/tcp
CMD ["cfingerd", "-f", "-p", "79"]
