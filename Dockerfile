FROM centos:7

# elixir expects utf8.
ENV LANG=en_US.utf8

ENV ERLANG_RPM="http://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_23.2.3-1~centos~7_amd64.rpm"

ENV ELIXIR_VERSION="v1.11.3"
ENV ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz"
ENV ELIXIR_DOWNLOAD_SHA512="4962bb9fcf5f4190a8da22a3e42df5b4e521d73771f6a067edb482b911b0f9fbd2883841d06d94ae4ad6b1db2f61f691e5de4c118c722a16f95830c67ce3e45b"

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
