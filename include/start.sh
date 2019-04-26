#!/bin/bash
# Add jobs and start cron
addCronJob()
{
        JOBEXISTS=`crontab -l | grep -F "$1"`
        if [[ -z $JOBEXISTS ]]
        then
                (crontab -l; echo "$1") | crontab
                echo "Added cron job: $1"
        else
                echo "Cron job already exists: $1"
        fi
}

# Get each rss feed url
for feed in $RSS_FEEDS
do
	addCronJob "*/$RSS_REFRESH_TIME * * * * flock /mnt/usenetpost/rss.lock -c '/mnt/usenetpost/fetchrss.py \"$feed\"'"
done

# Cleanup jobs
addCronJob "0 5 * * * /usr/bin/find /mnt/usenetpost/logs -mtime +14 -type f -delete"
addCronJob "0 5 * * * /usr/bin/find /mnt/usenetpost/watch -mtime +2 -type f -delete"
addCronJob "0 5 * * * /usr/bin/find /mnt/usenetpost/uploads -mtime +2 -type f -delete"

# Create directories 
mkdir /mnt/usenetpost/logs
mkdir /mnt/usenetpost/watch
mkdir /mnt/usenetpost/downloads
mkdir /mnt/usenetpost/uploads

echo "Starting Cron..."
cron -f &

# Modify config variables
echo "Configuring GoPostStuff..."
sed -i "s/^From=ENTERME/From=$USENET_POST_AS/" /mnt/usenetpost/GoPostStuff.conf
sed -i "s/^DefaultGroup=ENTERME/DefaultGroup=$USENET_POST_GROUP/" /mnt/usenetpost/GoPostStuff.conf
sed -i "s/^Address=ENTERME/Address=$USENET_SERVER/" /mnt/usenetpost/GoPostStuff.conf
sed -i "s/^Port=ENTERME/Port=$USENET_PORT/" /mnt/usenetpost/GoPostStuff.conf
sed -i "s/^Username=ENTERME/Username=$USENET_USERNAME/" /mnt/usenetpost/GoPostStuff.conf
sed -i "s/^Password=ENTERME/Password=$USENET_PASSWORD/" /mnt/usenetpost/GoPostStuff.conf
sed -i "s/^TLS=ENTERME/TLS=$USENET_TLS/" /mnt/usenetpost/GoPostStuff.conf

# Start rtorrent
echo "Starting rtorrent..."
tmux new-session -s rtorrent "rtorrent"

