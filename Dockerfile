FROM centos:7

# elixir expects utf8.
ENV LANG=en_US.utf8

ENV ERLANG_RPM="https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_21.3.8.14-1~centos~7_amd64.rpm"

ENV ELIXIR_VERSION="v1.10.2"
ENV ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz"
ENV ELIXIR_DOWNLOAD_SHA512="a1d1c7847fc8135865d063c6e014bee970066ba07f979f308bec456a732f5366a9343631239965d1caeeaea5cdb644f35185fdfb23f18fcc8c6735a7e3256c0f"

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

ENTRYPOINT ["/tini", "-v", "--", "/app/bin/docker-entrypoint.sh"]

USER cirunner

CMD ["iex"]
