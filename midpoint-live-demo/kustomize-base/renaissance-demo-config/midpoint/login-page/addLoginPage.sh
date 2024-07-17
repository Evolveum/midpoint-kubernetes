#!/bin/bash

###########
# Extract file containing the Login page
###########

cp /opt/midpoint/lib/* /mnt/lib/
cd /mnt/lib
unzip -q midpoint.jar -d midpoint2
mkdir /mnt/gui/
adminGuiFile="$(find /mnt/lib -name admin-gui-\*.jar -exec basename \{\} \;)"
cp midpoint2/BOOT-INF/lib/${adminGuiFile} /mnt/gui/
cd /mnt/gui/
unzip -q ${adminGuiFile} -d gui2

###########
# Add the "info block" to the login page
###########

lineNum=$(grep -n "wicket:child" gui2/com/evolveum/midpoint/gui/impl/page/login/AbstractPageLogin.html | cut -d : -f 1)
mv gui2/com/evolveum/midpoint/gui/impl/page/login/AbstractPageLogin.html gui2/com/evolveum/midpoint/gui/impl/page/login/AbstractPageLogin.bck
head -n $(( ${lineNum} - 1 )) gui2/com/evolveum/midpoint/gui/impl/page/login/AbstractPageLogin.bck >gui2/com/evolveum/midpoint/gui/impl/page/login/AbstractPageLogin.html
cat <<EOF >> gui2/com/evolveum/midpoint/gui/impl/page/login/AbstractPageLogin.html
                    <!-- begin changes -->
                    <div class="form-group" style="font-size: 0.85rem; margin-bottom: 0.3rem;">
                        <div class="col-md-4 col-lg-12 text-center">
                            <a href="https://docs.evolveum.com/midpoint/demo/" target="_blank">Live demo documentation</a>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-md-4 col-lg-12 text-center" style="font-size: 0.85rem;">
                            Demo credentials: <strong>administrator</strong> / <strong>IGA4ever</strong>
                        </div>
                    </div>
                    <!-- end changes -->

EOF
tail -n +${lineNum} gui2/com/evolveum/midpoint/gui/impl/page/login/AbstractPageLogin.bck >>gui2/com/evolveum/midpoint/gui/impl/page/login/AbstractPageLogin.html
rm gui2/com/evolveum/midpoint/gui/impl/page/login/AbstractPageLogin.bck

###########
# re-create the archive (jar) with the udated file
###########

apk add zip
cd gui2
zip -0 -r ${adminGuiFile} .
cp -f ${adminGuiFile} /mnt/lib/midpoint2/BOOT-INF/lib/

###########
# Adding file to "set" the package with overlay - the original signature is broken
###########

echo "Login Page update - default demo login information" >/mnt/lib/midpoint2/overlay-info.txt

###########                                                                                                           
# re-create the archive (jar) with the midPoint distribution                                            
###########

cd /mnt/lib/midpoint2
zip -0 -r midpoint.jar .
mv midpoint.jar /mnt/lib/

###########                                                                                                           
# clean up after update process
###########

rm -rf /mnt/gui/${adminGuiFile} /mnt/gui/gui2
rm -rf /mnt/lib/midpoint2
