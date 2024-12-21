date "+Compiled: %Y/%m/%d %H:%M:%S" > version.txt
rm ../LEDrums.love
zip -9 -r -x\.git/* ../LEDrums.love .