FROM quay.io/rockylinux/rockylinux:9

# elixir expects utf8.
ENV LANG=en_US.utf8

ENV ERLANG_VERSION=24.2.1
ENV ERLANG_DOWNLOAD_URL="https://github.com/rabbitmq/erlang-rpm/releases/download/v${ERLANG_VERSION}/erlang-${ERLANG_VERSION}-1.el9.x86_64.rpm"
ENV ERLANG_DOWNLOAD_SHA512="297fd37bf1d2518f4a9ec38534d03332b0e804131aa5dd2ee69d69cbb4dacff3ebc279e8305eb4be53843e9c113276fc4574ba8505b07f406b98f546aefb176e"

ENV ELIXIR_VERSION="v1.13.2"
ENV ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz"
ENV ELIXIR_DOWNLOAD_SHA512="62fe42a9c3439d1fcba31ce4f9b0e489e6ad71417dc7de200b1651cd61a1fc5c433b1b9e0ecc293a5e5c279da47c909df45253193f6b4a8253043e07def05bc4"

RUN set -xe \
	&& dnf clean all && dnf update -y \
	&& dnf install -y langpacks-en glibc-all-langpacks rpm-build createrepo systemd-rpm-macros make git lsof openssh-clients which openssl yajl \
	&& dnf groupinstall -y "Development Tools" \
	&& curl -fSL -o erlang.rpm "${ERLANG_DOWNLOAD_URL}" \
	&& echo "${ERLANG_DOWNLOAD_SHA512}  erlang.rpm" | sha512sum -c - \
	&& dnf install -y erlang.rpm \
	&& rm erlang.rpm \
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
