FROM centos:7

# elixir expects utf8.
ENV LANG=en_US.utf8

ENV ERLANG_RPM="https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_21.3.8.2-1~centos~7_amd64.rpm"

ENV ELIXIR_VERSION="v1.9.1"
ENV ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz"
ENV ELIXIR_DOWNLOAD_SHA512="4cfc672d3a2d02e044ffa305ae2986658a431a264b7e06b0fde1773d8d062bde27ea06f0d31433107ef8bfdf6e931c75c6a39de81bc54b275e06edbe0cc87bda"

RUN set -xe \	
	&& yum clean all && yum update -y \
	&& yum install -y rpm-build createrepo epel-release make git lsof openssh-clients which\
	&& yum groups mark install "Development Tools" \
	&& yum groups mark convert "Development Tools" \
	&& yum groupinstall -y "Development Tools" \
	&& yum install -y "${ERLANG_RPM}" \
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
