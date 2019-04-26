FROM ubuntu

MAINTAINER papersackpuppet

# Install packages
RUN apt-get update && apt-get install -y cron rtorrent par2 rar python2.7 python-setuptools tmux
python -m pip install pymongo
RUN python /usr/lib/python2.7/dist-packages/easy_install.py feedparser

# Add files
ADD include /mnt/usenetpost
ADD include/.rtorrent.rc /mnt/usenetpost/.rtorrent.rc

# Set environment variables
ENV HOME /mnt/usenetpost

# RSS Feeds to watch, space delimited
ENV RSS_FEEDS ENTERME

# Time in minutes to refresh the rss feed
ENV RSS_REFRESH_TIME 3

# Usenet connection info. TLS can be on or off
ENV USENET_SERVER ENTERME
ENV USENET_PORT ENTERME
ENV USENET_TLS on
ENV USENET_USERNAME ENTERME
ENV USENET_PASSWORD ENTERME

# Groups to post the files to, comma delimited
ENV USENET_POST_GROUP ENTERME

# The user to post the files as
ENV USENET_POST_AS ENTERME

# Run stuff
CMD ["/mnt/usenetpost/start.sh"]
