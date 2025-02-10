#!/bin/bash

input="test.rosinstall"

while read -r line
do
if [ "$line" == "- git:" ]; then
	echo "--= New repository found in file: $input =--"
elif [[  $line == *"uri"*  ]]; then
	uri_arr=($line)
	uri=${uri_arr[1]}
	#echo "$uri"
elif [[  $line == *"local-name"*  ]]; then
	local_name_arr=($line)
	local_name=${local_name_arr[1]}
	#echo "$local_name"
elif [[ $line == *"commit"* ]]; then
	commit_arr=($line)
	commit=${commit_arr[2]}
	#echo "$commit"
	https="$(echo $uri | cut -c 1-8)"
	addr="$(echo $uri | cut -c 9-)"
	git clone "${https}${GIT_USER_NAME}:${GIT_ACCESS_TOKEN}@${addr}" $local_name
	cd $local_name
	git checkout $commit
	cd ..
fi
done < "$input"
