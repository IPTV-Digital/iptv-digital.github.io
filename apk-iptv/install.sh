#!/data/data/com.termux/files/usr/bin/bash
if [ ! -f "tivimate.apk" ];then
        echo menyiapkan instalasi 
	pkg update -y &> /dev/null
        pkg install unzip -y &> /dev/null
	echo download data..
	curl -O https://raw.githubusercontent.com/ariev7xx/tivimate/main/data.zip &> /dev/null
	echo mengekstrak data..
	unzip -o data.zip &> /dev/null
	rm data.zip &> /dev/null
fi

if ! command -v adb &> /dev/null
then
	echo installing adb...
	pkg update -y &> /dev/null
	pkg install android-tools -y &> /dev/null
fi

adb kill-server &> /dev/null
adb devices &> /dev/null
echo masukan ip device:
read IP
adb connect $IP &> /dev/null
echo jika muncul popup fingerprint izinkan. lalu enter
read aja
adb kill-server &> /dev/null
adb devices &> /dev/null
res=$(adb connect $IP | cut -d' ' -f1)

if [ "$res" = "connected" ]; then
	echo "Connected"
	echo menguninstall tivimate lama..
	adb uninstall ar.tvplayer.tv &> /dev/null
	echo menginstall patch..
	adb install hook.apk &> /dev/null
	echo silahkan restore saat muncul popup
	adb restore ar.tvplayer.tv.ab &> /dev/null
	echo setelah restore selesai tekan enter
	read anu
	echo menyelesaikan instalasi..
	adb  install -r tivimate.apk &> /dev/null
	echo instalasi selesai

echo "patch host file , device root. y/n?"
adb shell su -v &> /dev/null
read anu

if [ "$anu" = "y" ]; then
adb shell su -c mount -o rw,remount / &> /dev/null
adb shell su -c mount -o rw,remount /system &> /dev/null
adb push host /data/local/tmp/hosts &> /dev/null
adb shell su -c cp /data/local/tmp/hosts /system/etc/hosts &> /dev/null
adb shell su -c mount -o ro,remount / &> /dev/null
adb shell su -c mount -o ro,remount /system &> /dev/null
echo done
else
echo "install dns66 for non-root"
adb install dns66.apk &> /dev/null
echo done
echo "agar premium permanen, buka dns66 dulu lalu start, baru buka tivimate"
fi


else
	echo "No connected"
	exit 1
fi

rm install.sh
