echo Making leds executable...
make
echo Copying ledscape config...
cp ledscape-config.json /etc
echo Making service install script executable...
chmod +x install-service.sh
echo Run install-service.sh to make ledsd start on boot...