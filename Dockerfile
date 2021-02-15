FROM amazon/aws-cli:2.1.24
RUN yum install jq -y
COPY bin /opt/resource
RUN chmod +x /opt/resource/check /opt/resource/in /opt/resource/out
RUN rm -rf /tmp/*
ENTRYPOINT [ "/bin/bash" ]
