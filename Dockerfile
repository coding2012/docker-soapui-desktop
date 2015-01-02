FROM dockerfile/chrome

ADD http://downloads.sourceforge.net/project/soapui/soapui/4.6.4/SoapUI-4.6.4-linux-bin.tar.gz \
 /root/SoapUI-4.6.4-linux-bin.tar.gz
RUN apt-get update && \
 apt-get install -y default-jre
RUN apt-get install -y  default-jdk
RUN apt-get install -y  autocutsel
RUN apt-get install -y  leafpad
RUN apt-get install -y  firefox
ENV DISPLAY :1

ENV USER root
RUN mkdir /root/.vnc && chmod 700 /root/.vnc
COPY passwd /root/.vnc/
RUN chmod 600 /root/.vnc/passwd

WORKDIR /root

RUN tar -xf SoapUI-4.6.4-linux-bin.tar.gz
RUN mv SoapUI-4.6.4 soapui
# Define default command.
COPY soapui-settings.xml /root/soapui/soapui-settings.xml
COPY soapui.desktop /root/Desktop/soapui.desktop
CMD (USER=root vncserver :1 -geometry 1280x800 -depth 24) && autocutsel -fork \
 && sh soapui/bin/soapui.sh \
 && bash