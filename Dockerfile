FROM centos:7

# elixir expects utf8.
ENV LANG=en_US.utf8

ENV ERLANG_RPM="https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_21.3.8.2-1~centos~7_amd64.rpm"

ENV ELIXIR_VERSION="v1.9.0"
ENV ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz"
ENV	ELIXIR_DOWNLOAD_SHA512="3ecdbb2565cdaf51d6119b5dba42b4b180484aea96e9fe1f85febfb7c3f185b869aab94a22b5052dd84073be1a50ecb97d76dd1bc87f7fdc38a12cff65d2caf6"

RUN set -xe \	
	&& yum clean all && yum update -y \
	&& yum install -y rpm-build createrepo epel-release make git lsof \
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
