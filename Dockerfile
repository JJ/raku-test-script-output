FROM jjmerelo/test-perl6:latest
LABEL version="1.0" maintainer="JJ Merelo <jjmerelo@GMail.com>"

COPY META6.json .

RUN apk update && apk upgrade \
    && zef install --deps-only . \
    && mkdir -p lib/Test/Script

COPY lib/Test/Script/Output.pm6 lib/Test/Script/Output.pm6

RUN zef install .

# Will run this
ENTRYPOINT perl6 -v && zef test .

# Repeating mother's env
ENV PATH="/root/.rakudobrew/bin:${PATH}"

