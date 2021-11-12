from ubuntu:20.04

RUN apt-get update
RUN apt-get install -y git python3 make python3-distutils curl jq
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3 get-pip.py
RUN rm get-pip.py

ADD ./requirements.txt /client/requirements.txt
WORKDIR client
RUN pip install -r requirements.txt

ENV DEBIAN_FRONTEND=noninteractive
RUN apt install -y default-jdk maven
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PYTHONPATH=/client

COPY bin/openapi-generator-cli.jar /opt/openapi-generator-cli.jar

ENV GOPATH=/go/
RUN apt-get update && apt-get install -y golang ca-certificates

RUN apt-get purge golang* -y
RUN apt-get install -y wget
RUN wget https://golang.org/dl/go1.17.2.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.2.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

ENTRYPOINT ["sh", "scripts/entrypoint.sh"]
CMD ["/bin/bash"]

