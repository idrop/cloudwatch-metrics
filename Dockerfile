FROM amazon/aws-cli:2.1.24
RUN yum install jq -y
COPY bin/check.sh /opt/resource/check
COPY bin/in.sh /opt/resource/in
COPY bin/out.sh /opt/resource/out
COPY bin/config.sh /opt/resource/config
RUN chmod +x /opt/resource/check /opt/resource/in /opt/resource/out /opt/resource/config
RUN rm -rf /tmp/*
CMD ["--version"]