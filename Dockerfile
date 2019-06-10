FROM erlang:21.3.1

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.9.0-rc.0" \
	LANG=C.UTF-8

RUN set -xe \
	&& apt-get update \
	&& apt-get -y install lsof rpm createrepo \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
	&& ELIXIR_DOWNLOAD_SHA512="7f263a8f43ffa464ac38388682057f565ca49258c48deea1fed0acfa2c178f544f76fa6fa666c98d4dad7b7ea5cc63e5dd234f00045b80b7547553dc0db2a786" \
	&& curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
	&& echo "$ELIXIR_DOWNLOAD_SHA512  elixir-src.tar.gz" | sha512sum -c - \
	&& mkdir -p /usr/local/src/elixir \
	&& tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
	&& rm elixir-src.tar.gz \
	&& cd /usr/local/src/elixir \
	&& make install clean \
	&& useradd -ms /bin/bash cirunner \
        && mkdir /builds && chown cirunner:cirunner /builds

USER cirunner

CMD ["iex"]

