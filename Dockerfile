FROM centos:7

# system update
RUN yum -y update && yum clean all

# set locale
RUN yum reinstall -y glibc-common && yum clean all

RUN unlink /etc/localtime
RUN ln -s /usr/share/zoneinfo/Japan /etc/localtime

# editor install
RUN yum install -y vim && yum clean all

# httpd install
RUN yum -y install wget
RUN yum -y install httpd
COPY ./httpd.conf /etc/httpd/conf/httpd.conf

# git install
RUN yum -y install git

# PHP7.2 install(epel remiリポジトリを作成 remiリポジトリ経由でインストール)
RUN yum -y install epel-release
RUN rpm -ivh  http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
# -yをつけないと""Your transaction was saved"エラー発生、--enablerepo=remi-php72オプションでバージョン指定(デフォルトだと5.4になる)
RUN yum -y install --enablerepo=epel,remi,remi-safe,remi-php72 php php-common php-opcache php-mbstring php-xdebug php-mysql php-mysqlnd php-zip php-pdo php-cli php-intl php-xml
RUN curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer

CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
EXPOSE 80

RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG="ja_JP.UTF-8" \
        LANGUAGE="ja_JP:ja" \
        LC_ALL="ja_JP.UTF-8"
