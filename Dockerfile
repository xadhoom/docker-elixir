FROM erlang:21.3.1

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.9.0-rc.0" \
	LANG=C.UTF-8

RUN set -xe \
	&& apt-get update \
	&& apt-get -y install lsof \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
	&& ELIXIR_DOWNLOAD_SHA512="bc50c7f766196d961e26c912ead53257b95c421cfab81c6cf58d5ae4f3e3b646ea262f75e31d23de66761e8e1aacaa42fca42b110869f08428881b748095e2d6" \
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

