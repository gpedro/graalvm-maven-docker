FROM debian:buster-slim

LABEL maintainer="SoftInstigate <info@softinstigate.com>"

ARG JAVA_VERSION="20.3.0.r11-grl"
ARG MAVEN_VERSION="3.6.3"

ENV SDKMAN_DIR=/root/.sdkman

RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata curl zip unzip build-essential libz-dev zlib1g-dev ca-certificates fontconfig locales \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && curl 'https://get.sdkman.io' | bash \
    && rm -rf /var/lib/apt/lists/* \
    && echo "sdkman_auto_answer=true" > $SDKMAN_DIR/etc/config \
    && echo "sdkman_auto_selfupdate=false" >> $SDKMAN_DIR/etc/config \
    && echo "sdkman_insecure_ssl=true" >> $SDKMAN_DIR/etc/config \
    && chmod +x $SDKMAN_DIR/bin/sdkman-init.sh
RUN bash -c "source $SDKMAN_DIR/bin/sdkman-init.sh \
        && sdk version \
        && sdk install java $JAVA_VERSION \
        && sdk install maven $MAVEN_VERSION \
        && gu install native-image \
        && rm -rf $SDKMAN_DIR/archives/* \
        && rm -rf $SDKMAN_DIR/tmp/*"

WORKDIR /opt/code

# "/root/.sdkman/candidates/maven/current/bin/mvn"

SHELL ["/bin/bash", "-c"]

CMD source /root/.bashrc && mvn