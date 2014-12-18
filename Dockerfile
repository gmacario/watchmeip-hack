FROM ubuntu:14.04

RUN sudo apt-get update
RUN sudo apt-get -y install motion

# Configure motion
RUN mkdir -p /root/.motion
#RUN cp /etc/motion/motion.conf /root/.motion
ADD configure-motion.awk /root/
RUN awk -f /root/configure-motion.awk /etc/motion/motion.conf >/root/.motion/motion.conf

# DEBUG
RUN diff -uw /etc/motion/motion.conf /root/.motion/motion.conf || true

RUN mkdir -p /tmp/motion
VOLUME ["/tmp/motion"]

ENTRYPOINT ["motion"]
#ENTRYPOINT ["motion", "-s"]
EXPOSE 8080 8081
CMD [""]
