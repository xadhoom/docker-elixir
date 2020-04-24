FROM centos:7

# elixir expects utf8.
ENV LANG=en_US.utf8

ENV ERLANG_RPM="https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_22.3.2-1~centos~7_amd64.rpm"

ENV ELIXIR_VERSION="v1.9.4"
ENV ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz"
ENV ELIXIR_DOWNLOAD_SHA512="c97b93c7438efd7215408525a3b9f2935a1591cce3da3eb31717282d06aff94e8e3d22c405bac40c671bcfe8e73f3dd1ada315f53dee73ceef0bfe2a7c27e86d"

ENV NODESOURCE="https://rpm.nodesource.com/pub_10.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm"

RUN set -xe \
        && yum install -y ${NODESOURCE} \
	&& yum clean all && yum update -y \
	&& yum install -y rpm-build createrepo epel-release make git lsof openssh-clients which nodejs \
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
