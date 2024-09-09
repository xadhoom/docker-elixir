FROM quay.io/rockylinux/rockylinux:9

# elixir expects utf8.
ENV LANG=en_US.utf8

ENV ERLANG_VERSION=26.2.5.3
ENV ERLANG_DOWNLOAD_URL="https://github.com/rabbitmq/erlang-rpm/releases/download/v${ERLANG_VERSION}/erlang-${ERLANG_VERSION}-1.el9.x86_64.rpm"
ENV ERLANG_DOWNLOAD_SHA512="50bdc9b3fbc4fd93713261bf5ce065ef4822107b4d55f03d4a6ce2fd2b5bac4c968378d1fcbfc6eef664c849dc429817ffd9a031f70cbc12d34fdf93c3a68e1c"

ENV ELIXIR_VERSION="v1.14.5"
ENV ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz"
ENV ELIXIR_DOWNLOAD_SHA512="589482fb080eb9f71319b7927312ee255dab0376a8fb781533bc97b6a75dd71ec43cd022bb2eff12eca205cdeaf9a6d629f754c555c17cd6222e05912ff3d960"

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
