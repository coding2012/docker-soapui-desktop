FROM dockerfile/chrome

RUN apt-get update && \
 apt-get install -y default-jre
RUN apt-get install -y  default-jdk
RUN apt-get install -y  autocutsel
RUN apt-get install -y  leafpad
RUN apt-get install -y  firefox
RUN apt-get install -y  pgadmin3
ENV DISPLAY :1
RUN useradd --create-home --shell /bin/bash --user-group --groups adm,sudo qa
RUN echo "password\npassword\n\n" | passwd qa
USER qa
ENV USER qa
ENV HOME /home/qa
WORKDIR /home/qa

RUN mkdir /home/qa/.vnc && chmod 700 /home/qa/.vnc
RUN echo "password\npassword\n\n" | vncpasswd

RUN chmod 600 /home/qa/.vnc/passwd

USER root
ADD SoapUI-4.6.4-linux-bin.tar.gz /home/qa/
RUN mv SoapUI-4.6.4 soapui
# Define default command.
COPY soapui-settings.xml /home/qa/soapui/soapui-settings.xml
COPY soapui.desktop /home/qa/Desktop/soapui.desktop
COPY pgadmin.desktop /home/qa/Desktop/pgadmin.desktop
COPY chrome.desktop /home/qa/Desktop/chrome.desktop
COPY pgadmin3.config /home/qa/.pgadmin3
COPY pgpass.config /home/qa/.pgpass
COPY workspace.xml /home/qa/TestPBE-workspace.xml

RUN chown qa:qa /home/qa -R
RUN chmod 0400 /home/qa/.pgpass
USER qa

CMD (vncserver :1 -geometry 1280x760 -depth 24); \
 (sleep 8; autocutsel -fork; /home/qa/soapui/bin/soapui.sh); \
 tail -f /dev/null