#!/bin/bash
cp /opt/midpoint/lib/* /mnt/lib/
cd /mnt/lib
unzip -q midpoint.jar -d midpoint2
mkdir /mnt/gui/
cp midpoint2/BOOT-INF/lib/admin-gui-4.7.jar /mnt/gui/
cd /mnt/gui/
unzip -q admin-gui-4.7.jar -d gui2
cp -f /mnt/page/AbstractPageLogin.html gui2/com/evolveum/midpoint/gui/impl/page/login/AbstractPageLogin.html
rm -f admin-gui-4.7.jar
apk add zip
cd gui2
zip -0 -r admin-gui-4.7.jar .
cp -f admin-gui-4.7.jar /mnt/lib/midpoint2/BOOT-INF/lib/
cd /mnt/lib
rm midpoint.jar
cd midpoint2
zip -0 -r midpoint.jar .
mv midpoint.jar /mnt/lib/
cd ..
rm -rf midpoint2
