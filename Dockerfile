FROM centos:7

# elixir expects utf8.
ENV LANG=en_US.utf8

ENV ERLANG_RPM="https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_23.1-1~centos~7_amd64.rpm"

ENV ELIXIR_VERSION="v1.10.4"
ENV ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz"
ENV ELIXIR_DOWNLOAD_SHA512="844e405cf344539a9d32dc7f1ead0dc1dfb0d70a9ab718269f4e25e5262f611f96346f5be93cf8e34a75c58c6aabb12e8a796c5cb182955922510c270ef169e7"

ENV NODESOURCE="https://rpm.nodesource.com/pub_10.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm"

RUN set -xe \
        && yum install -y ${NODESOURCE} \
	&& yum clean all && yum update -y \
	&& yum install -y rpm-build createrepo epel-release make git lsof openssh-clients which nodejs sox openssl \
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
