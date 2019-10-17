FROM ubuntu:18.04
RUN sed -i'' 's/archive\.ubuntu\.com/us\.archive\.ubuntu\.com/' /etc/apt/sources.list && \
apt-get update -y --fix-missing && apt-get install -y tcpdump telnet iproute2 dnsutils time tcptraceroute inetutils-ping inetutils-traceroute curl build-essential gnupg2 jq git openssl wget netcat ca-certificates apt-transport-https lsb-release \
software-properties-common dirmngr python3 python3-pip ruby ruby-dev && \
update-ca-certificates && \
# install azure cli
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" >> /etc/apt/sources.list.d/azure-cli.list && \
apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv --keyserver packages.microsoft.com --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF && \
apt-get update -y --fix-missing && apt-get install -y azure-cli && \
# install powershell
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb && dpkg -i packages-microsoft-prod.deb && \
apt-get update -y --fix-missing && apt-get install -y powershell && \
# install rubygems
wget https://rubygems.org/rubygems/rubygems-3.0.2.zip && unzip rubygems-3.0.2.zip && ruby -C rubygems-3.0.2 setup.rb && \
# install uaac
/bin/bash -l -c "gem install cf-uaac" && \
# install bosh
wget -O /usr/local/bin/bosh https://github.com/cloudfoundry/bosh-cli/releases/download/v5.5.0/bosh-cli-5.5.0-linux-amd64 && chmod +x /usr/local/bin/bosh && \
# install cf
curl -k -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&source=github" | tar -zx && mv cf /usr/local/bin && chmod +x /usr/local/bin/cf && \
# install pivnet
wget -O /usr/local/bin/pivnet https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.59/pivnet-linux-amd64-0.0.59 && chmod +x /usr/local/bin/pivnet && \
# install om
wget -O /usr/local/bin/om-linux https://github.com/pivotal-cf/om/releases/download/1.0.0/om-linux && chmod +x /usr/local/bin/om-linux && ln -s /usr/local/bin/om-linux /usr/local/bin/om && \
# install mc
wget -O /usr/local/bin/mc https://dl.minio.io/client/mc/release/linux-amd64/mc && chmod +x /usr/local/bin/mc && \
# install fly
wget -O /usr/local/bin/fly https://github.com/concourse/concourse/releases/download/v4.2.3/fly_linux_amd64 && chmod +x /usr/local/bin/fly && \
# install credhub cli
wget -O ./credhub.tgz https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.2.0/credhub-linux-2.2.0.tgz && tar -xvf credhub.tgz && mv ./credhub /usr/local/bin/ && \
# install kubectl
curl -k -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && mv kubectl /usr/local/bin/kubectl && \
# install bbr
wget -O /usr/local/bin/bbr https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases/download/v1.5.1/bbr-1.5.1-linux-amd64 && chmod +x /usr/local/bin/bbr && \
# install pks cli
pivnet login --api-token REPLACE_ME && pivnet download-product-files -p pivotal-container-service -r 1.4.0 -i 358374 -d /usr/local/bin/ && mv /usr/local/bin/pks-linux-amd64* /usr/local/bin/pks && chmod +x /usr/local/bin/pks && \
# install awscli
pip3 install --upgrade awscli && apt-get remove -y gnupg2 build-essential apt-transport-https lsb-release software-properties-common dirmngr && rm -rf /var/lib/apt/lists/*