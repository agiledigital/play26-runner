#
# Play 2.6 Runner Image
# Docker image with tools and scripts installed to support the running of a Play Framework 2.6 server
# Expects build artifacts mounted at /home/runner/artifacts
#

FROM frolvlad/alpine-oraclejdk8
MAINTAINER Agile Digital <info@agiledigital.com.au>
LABEL Description=" Docker image with tools and scripts installed to support the running of a Play Framework 2.6 server" Vendor="Agile Digital" Version="0.1"

# Install libsodium so that applications can use the kalium crypto library.
RUN apk add --update --no-cache git bash tzdata libsodium
RUN addgroup -S -g 10000 runner
RUN adduser -S -u 10000 -h $HOME -G runner runner

COPY tools /home/runner/tools
RUN chmod +x /home/runner/tools/run.sh

EXPOSE 9000

# We need to support Openshift's random userid's
# Openshift leaves the group as root. Exploit this to ensure we can always write to them
# Ensure we are in the the passwd file
RUN chmod g+w /etc/passwd
RUN chgrp -Rf root /home/runner && chmod -Rf g+w /home/runner
ENV RUNNER_USER runner

USER runner

ENTRYPOINT ["/home/runner/tools/run.sh"]
