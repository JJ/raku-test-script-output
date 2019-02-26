FROM jjmerelo/test-perl6:latest
LABEL version="1.0" maintainer="JJ Merelo <jjmerelo@GMail.com>"

# Add openssl
RUN apk update && apk upgrade \
    && zef install Test::Script::Output

# Will run this
ENTRYPOINT perl6 -v && zef test .

# Repeating mother's env
ENV PATH="/root/.rakudobrew/bin:${PATH}"

