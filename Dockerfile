FROM openjdk:8-jdk-alpine

RUN apk update && apk add ca-certificates wget 

RUN wget http://apache.mirrors.nublue.co.uk//jmeter/binaries/apache-jmeter-3.2.tgz
RUN tar -xvf apache-jmeter-3.2.tgz
WORKDIR apache-jmeter-3.2

ENV p_server=payara
ENV p_port=8080
ENV p_site=/Payara-Soak-Tests-1.0-SNAPSHOT
ENV p_users=30
ENV p_loops=3
ENV p_ramp_up_secs=15
ENV p_response_timeout=8000

COPY persons.csv /Config/persons.csv

COPY SoakTests.jmx /Config/SoakTests.jmx

ENTRYPOINT bin/jmeter \
           -Jp_personfile=/Config/persons.csv \
           -Jp_server=$p_server \
           -Jp_port=$p_port \
           -Jp_site=$p_site \
           -Jp_users=$p_users \
           -Jp_loops=$p_loops \
           -Jp_ramp_up_secs=$p_ramp_up_secs \
           -Jp_response_timeout=$p_response_timeout \
           -n -t /Config/SoakTests.jmx -l /Data/results.jtl
