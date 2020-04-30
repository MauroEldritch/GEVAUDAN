#BASE
FROM debian:stretch-slim
RUN apt update && \
apt install -y \
glusterfs-server=3.8.8-1

#CLEANUP
RUN apt -y purge php-dev build-essential gcc g++ && apt-get -y autoremove
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin

#OS Configurations
RUN mkdir /mnt/gluster_volume
RUN chmod 777 /mnt/gluster_volume
CMD 	/etc/init.d/glusterfs-server start && \
	echo 'PS1="\u@$(hostname -i):\w# "' >> /root/.bashrc && \
	sleep infinity
