#/bin/bash

movie=$(lsdvd /dev/sr0 | grep "Disc Title" | cut -c 12-)
echo $movie
mkdir $movie
cd $movie
#faketime '2024-08-1 10:30:00' makemkvcon --minlength=960 mkv disc:0 all ./
#makemkvcon --minlength=960 mkv disc:0 all ./
HandBrakeCLI --input /dev/sr0 --title 1 --output out.mkv --format av_mkv --audio 1 --all-subtitles --encoder nvenc_h265 --aencoder copy --quality 23
#newFile=$(find . -type f -printf '%s %p\n' | sort -nr | head -1 | cut -d ' ' -f 2 | cut -c 3-)
#echo $newFile
mv "out.mkv" "$movie.mkv"
eject
#ffmpeg -i "$movie" -vcodec hevc_nvenc -preset slow -crf 20 -acodec aac "$movie.mkv"



