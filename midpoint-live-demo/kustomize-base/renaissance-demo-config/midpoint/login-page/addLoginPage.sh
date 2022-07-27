#!/bin/bash
cp /opt/midpoint/lib/* /mnt/lib/
cd /mnt/lib
unzip -q midpoint.war -d midpoint2
cd midpoint2/WEB-INF/classes/com/evolveum/midpoint/web/page/login/
cp /mnt/page/PageLogin.html .
cd /mnt/lib
rm midpoint.war
apk add zip
cd midpoint2
zip -0 -r midpoint.war .
mv midpoint.war /mnt/lib/
cd ..
rm -rf midpoint2
