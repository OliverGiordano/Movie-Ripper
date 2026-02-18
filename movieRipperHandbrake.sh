#!/bin/bash
if [ "$1" == "-h" ]; then
	echo argument is the server the video will be sent to, if there are no arguments, the video will remain local
	exit 0
fi
moviePath=$(diskutil list external | cut -d ' ' -f1)
if [ ! -e "$moviePath" ]; then # drives are mapped to symlinks, so we use -e 
	echo "$moviePath"
	echo "movie not found, exiting"
	exit 1
fi
echo Movie found at path "$moviePath"
movie=$(diskutil info "$moviePath" | grep "Volume Name" | awk -F': *' '{print $2}') #this is apple specific for grabbing movie name
echo "$movie"
mkdir "$movie"
cd "$movie" || exit 1
HandBrakeCLI -i "/Volumes/$movie/VIDEO_TS" -R 48  --audio-fallback av_aac --all-audio --all-subtitles --preset="H.265 Apple VideoToolbox 2160p 4K" --main-feature -o ./out.mkv #you will need to switch the encoder and volume from which u grab the movie
if [ ! "$(echo $?)" -eq 0 ]; then
	echo "file read error"
	exit 2
fi
mv "out.mkv" "$movie.mkv"
drutil tray eject
#ssh ubuntu-server mkdir -p /home/oliver/Videos/Movies/"$movie" # if u are saving the movies locally you can stop here 
#rsync -a -P "$movie.mkv" ubuntu-server:/home/oliver/Videos/Movies/"$movie"/
if [ "$1" = "" ]; then
	exit 0
fi
rsync -a -P "$movie.mkv" "$1":/home/oliver/Videos/Movies/"$movie"/
#ffmpeg -i "$movie" -vcodec hevc_nvenc -preset slow -crf 20 -acodec aac "$movie.mkv"
