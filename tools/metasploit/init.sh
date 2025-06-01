#!/bin/bash

echo '------------------------------------------------'
echo '[+] ---------------------- Initializing postgres'
echo '------------------------------------------------'
msfdb init

echo '-------------------------------------------'
echo '[+] ---------------------- Initializing tor'
echo '-------------------------------------------'
service tor start

# optional
#echo '------------------------------------------'
#echo '[+] ---------------------- Configuring tor'
#echo '------------------------------------------'
#bash -c "/torctl.sh start"

#echo '-----------------------------------------------'
#echo '[+] ---------------------- Downloading exploits'
#echo '-----------------------------------------------'
#python3 /sploitctl.py -f 0 -XR

#echo '------------------------------------------------'
#echo '[+] ---------------------- Downloading wordlists'
#echo '------------------------------------------------'
#python3 /wordlistctl.py fetch -l WORDLIST -g {usernames,passwords,discovery,fuzzing,misc} -b /usr/share/wordlists

echo '----------------------------------------'
echo '[+] ---------------------- loading shell'
echo '----------------------------------------'
tmux new-session "msfconsole"
