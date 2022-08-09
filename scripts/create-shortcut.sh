
#!/bin/bash
option=$1
target=$2

help()
{
printf "\nUsage: shortcut [OPTIONS] [TARGET]"
printf "\nUse this tool to create shortcuts (.desktop files) for you."
printf "\n\nBasic usage:"
printf "\n  -c [program]\t\tCreates a new shortcut using the program as target."
printf "\n  -d\t\tDeletes the shortcut."
printf "\n  -h\t\tPrints this help."
printf "\n"
}

create()
{
executable=$target
fullpath=$(whereis $target |awk '{print $2}')
name=$(man -a $target |grep -A 1 NAME |grep -v NAME |awk '{print $1}')
comment=$(man -a $target |grep -A 1 NAME |grep -v NAME |awk -F'-' '{print $NF}')
description=$(man -a $target |grep -A 1 DESCRIPTION |grep -v DESCRIPTION |awk -F'-' '{print $NF}')

printf "[Desktop Entry]" > /usr/share/applications/$name.desktop
printf "\nName=$name" >> /usr/share/applications/$name.desktop
printf "\nComment=$comment" >> /usr/share/applications/$name.desktop
printf "\nExec=$fullpath" >> /usr/share/applications/$name.desktop
printf "\nIcon=$executable" >> /usr/share/applications/$name.desktop
printf "\nTerminal=false" >> /usr/share/applications/$name.desktop
printf "\nType=Application" >> /usr/share/applications/$name.desktop

}

delete()
{
name=$(man -a $target |grep -A 1 NAME |grep -v NAME |awk '{print $1}')
rm /usr/share/applications/$name.desktop
}

option=$1
case $option
in
    -c) create ;;
    -d) delete ;;
    -h) help ;;
esac
