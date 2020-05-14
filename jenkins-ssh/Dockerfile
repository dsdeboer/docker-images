FROM debian:buster-slim
LABEL MAINTAINER="Duncan de Boer <duncan@charpand.nl>"

ARG version=7.4
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_AGENT_HOME=/var/lib/${user}
ARG PHP_CONFIG_DIR=/etc/php/${version}

RUN groupadd -g ${gid} ${group} \
    && useradd -d "${JENKINS_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}"

RUN apt-get update \
    && apt-get full-upgrade -qy  \
    && apt-get install -qy wget gnupg2 gpg ca-certificates apt-utils apt-transport-https lsb-release \
    && apt-get install -qy git unzip

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php${version}.list \
    && apt-get update -qy \
    && apt-get install -qy openssh-server argon2 openjdk-11-jdk postgresql-client-12

RUN sed -i /etc/ssh/sshd_config \
    -e 's/#PermitRootLogin.*/PermitRootLogin no/' \
    -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
    -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
    -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
    -e 's/#LogLevel.*/LogLevel INFO/' && \
    mkdir /var/run/sshd

RUN apt-get install -qy php${version} php${version}-cli php${version}-xml php${version}-mbstring php${version}-curl php${version}-zip \
    php${version}-pgsql php${version}-intl php${version}-bz2 php${version}-bcmath php${version}-pcov \
    php${version}-json \
    && apt-get remove apache2* -yq \
    && apt-get -qy autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/src \
    && apt-get clean

RUN echo 'date.timezone = "Europe/Amsterdam"' >> ${PHP_CONFIG_DIR}/cli/conf.d/19-datetime.ini

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

USER jenkins
VOLUME ["ComposerCache:/var/lib/jenkins/.composer", "PhpunitCache:/var/lib/jenkins/symfony-bridge/.phpunit", ${JENKINS_AGENT_HOME}]
RUN mkdir -p /var/lib/jenkins/.composer && chown -R jenkins:jenkins /var/lib/jenkins/.composer
USER root
COPY setup-sshd /usr/local/bin/setup-sshd
RUN chmod +x /usr/local/bin/setup-sshd

ENV SYMFONY_PHPUNIT_DIR /var/lib/jenkins/symfony-bridge/.phpunit

EXPOSE 22

ENTRYPOINT ["/usr/local/bin/setup-sshd"]
