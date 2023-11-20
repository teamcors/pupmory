FROM ubuntu:20.04

ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64/
RUN apt-get update -y \
&& apt-get install -y software-properties-common \
&& add-apt-repository ppa:deadsnakes/ppa \
&& apt-get install -y locales \
&& apt-get install openjdk-17-jdk -y \
&& apt-get install python3-pip -y \
&& pip install konlpy \
&& export JAVA_HOME \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i '/ko_KR.UTF-8/s/^# //g' /etc/locale.gen \
&& locale-gen
ENV LANG ko_KR.UTF-8  
ENV LANGUAGE ko_KR:en  
ENV LC_ALL ko_KR.UTF-8   

LABEL org.opencontainers.image.source https://github.com/HamaHama-Dev/pupmory

ARG JAR_FILE=/backend/build/libs/*.jar
ARG WC_FILE=/backend/src/main/python/wcloud.py

ENV DB_URL=
ENV DB_USERNAME=
ENV DB_PASSWORD=
ENV MAIL_USERNAME=
ENV MAIL_PASSWORD=
ENV GPT_KEY=
ENV AWS_REGION=
ENV S3_BUCKET=
ENV S3_ACCESS_KEY=
ENV S3_SECRET_KEY=
ENV JWT_SECRET=
COPY ${JAR_FILE} app.jar
COPY ${WC_FILE} wcloud.py
ENTRYPOINT [ \
    "java", \
    "-Dspring.datasource.url=${DB_URL}", \
    "-Dspring.datasource.username=${DB_USERNAME}", \
    "-Dspring.datasource.password=${DB_PASSWORD}", \
    "-Dspring.mail.username=${MAIL_USERNAME}", \
    "-Dspring.mail.password=${MAIL_PASSWORD}", \
    "-Dchatgpt.api-key=${GPT_KEY}", \
    "-Dcloud.aws.region.static=${AWS_REGION}", \
    "-Dcloud.aws.s3.bucket=${S3_BUCKET}", \
    "-Dcloud.aws.s3.credentials.accessKey=${S3_ACCESS_KEY}", \
    "-Dcloud.aws.s3.credentials.secretKey=${S3_SECRET_KEY}", \
    "-Djwt.secret=${JWT_SECRET}", \
    "-jar", \
    "/app.jar", \
    "-web -webAllowOthers -tcp -tcpAllowOthers -browser -ifNotExists" \
    ]