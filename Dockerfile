FROM tomcat:latest

RUN rm -f /usr/local/tomcat/webapps/*

COPY target/healthy-hens-1.1.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 80

CMD ["catalina.sh", "run"]
