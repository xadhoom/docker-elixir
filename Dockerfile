FROM quay.io/centos/centos:7

# elixir expects utf8.
ENV LANG=en_US.utf8

ENV ERLANG_VERSION=24.1.7

ENV ELIXIR_VERSION="v1.11.4"
ENV ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz"
ENV ELIXIR_DOWNLOAD_SHA512="5dc940a31a31ae1c1537f874c15e58311cc0b0452f61e923bdfde0a5cfef3d8003eb3e85be320eb0acfb7bc0c0c0dc8ac965dec6727257c244048268fbf38ceb"

ENV NODESOURCE="https://rpm.nodesource.com/pub_10.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm"

RUN set -xe \
	&& yum clean all && yum update -y \
	&& yum install -y yum-plugin-copr \
	&& yum copr enable -y mbrancaleoni/erlang \
	&& yum install -y ${NODESOURCE} \
	&& yum install -y rpm-build createrepo epel-release make git lsof openssh-clients which nodejs sox openssl mariadb \
	&& yum groups mark install "Development Tools" \
	&& yum groups mark convert "Development Tools" \
	&& yum groupinstall -y "Development Tools" \
	&& yum install -y "erlang-${ERLANG_VERSION}" \
	&& yum copr disable -y mbrancaleoni/erlang \
	&& curl -fSL -o elixir-src.tar.gz "${ELIXIR_DOWNLOAD_URL}" \
	&& echo "${ELIXIR_DOWNLOAD_SHA512}  elixir-src.tar.gz" | sha512sum -c - \
	&& mkdir -p /usr/local/src/elixir \
	&& tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
	&& rm elixir-src.tar.gz \
	&& cd /usr/local/src/elixir \
	&& make install clean \
	&& useradd -ms /bin/bash cirunner \
	&& mkdir /builds && chown cirunner:cirunner /builds

USER cirunner

CMD ["iex"]
