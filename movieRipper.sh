#/bin/bash

movie=$(lsdvd /dev/sr0 | grep "Disc Title" | cut -c 12-)
echo $movie
mkdir $movie
cd $movie
faketime '2024-04-1 10:30:00' makemkvcon --minlength=960 mkv disc:0 all ./  #I use libfaketime here so I dont need to put up with makemkv key nonsense
newFile=$(find . -type f -printf '%s %p\n' | sort -nr | head -1 | cut -d ' ' -f 2 | cut -c 3-)
echo $newFile
mv $newFile $movie
eject
ffmpeg -i $movie -vcodec libx265 -preset slow -crf 20 -acodec aac $movie.mkv

rm $movie


