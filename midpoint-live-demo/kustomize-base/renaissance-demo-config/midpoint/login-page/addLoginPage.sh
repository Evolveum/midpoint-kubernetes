#!/bin/bash
cp /opt/midpoint/lib/* /mnt/lib/
cd /mnt/lib
unzip -q midpoint.jar -d midpoint2
mkdir /mnt/gui/
cp midpoint2/BOOT-INF/lib/admin-gui-4.8.4.jar /mnt/gui/
cd /mnt/gui/
unzip -q admin-gui-4.8.4.jar -d gui2
cp -f /mnt/page/AbstractPageLogin.html gui2/com/evolveum/midpoint/gui/impl/page/login/AbstractPageLogin.html
rm -f admin-gui-4.8.4.jar
apk add zip
cd gui2
zip -0 -r admin-gui-4.8.4.jar .
cp -f admin-gui-4.8.4.jar /mnt/lib/midpoint2/BOOT-INF/lib/
echo "Login Page update - default demo login information" >/mnt/lib/midpoint2/overlay-info.txt
cd /mnt/lib
rm midpoint.jar
cd midpoint2
zip -0 -r midpoint.jar .
mv midpoint.jar /mnt/lib/
cd ..
rm -rf midpoint2
