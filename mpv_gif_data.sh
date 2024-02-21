#!/bin/bash

meta="metadata-default.yml"
level1="  "
level2="    "
level3="      "
level4="        "
level5="          "

_timestamp () {
  h=$(bc <<< "${1}/3600")
  m=$(bc <<< "(${1}%3600)/60")
  s=$(bc <<< "${1}%60")
  printf "%02d:%02d:%06.3f" "$h" "$m" "$s"
}

get_file_name () {
  file_name="$1"
  echo "$file_name" | xclip -selection clipboard && notify-send "copied $file_name"
  printf -- "---\n" >> "$meta"
  printf "video: $file_name\n" >> "$meta"
  printf "clips:\n" >> "$meta"
  #printf "video:\n" >> "$meta"
  #printf "${level1}name: $file_name\n" >> "$meta"
  #printf "${level1}scene:\n" >> "$meta"
}

copy_start_stamp () {
  stamp=$(_timestamp "$1")
  echo "$1" | xclip -selection clipboard && notify-send "copied $stamp"
  printf -- "- s: '$stamp'\n" >> "$meta"
  #printf "${level1}- clip:\n" >> "$meta"
  #printf "${level3}s: '$stamp'\n" >> "$meta"
}

copy_end_stamp () {
  stamp=$(_timestamp "$1")
  echo "$stamp" | xclip -selection clipboard && notify-send "copied $stamp"
	printf "${level1}e: '$stamp'\n" >> "$meta"
  #printf "${level3}e: '$stamp'\n" >> "$meta"
}

crop_sq () {
	sq="${1}"
	arr=$(echo "${sq##@mpv_crop_script_asscropper_crop:crop=}" |\
		tr -d '[[:alpha:]]' | tr -d '=' | sed 's/:/,/g')
  echo "[$arr]" | xclip -selection clipboard && notify-send "[$arr]"
  printf "${level1}crop: [$arr]\n" >> "$meta"
}

for i in "$@"; do
  case $i in
    s)
      copy_start_stamp "$2"
    shift;;
    d)
      copy_end_stamp "$2"
    shift;;
    v)
      get_file_name "$2"
    shift;;
    n)
      crop_sq "$2"
    shift;;
  esac
done
