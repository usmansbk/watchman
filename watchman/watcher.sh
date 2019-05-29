cwd=$(pwd)
flist=".filels"
plist=".pathls"
for path in $(cat $plist)
do
	cd $path
	for file in *
	do
		line=$(grep ${file##*.} $cwd/$flist)
		IFS=" "
		set $line > /dev/null
		echo $file $2
		echo moving $file to $2
		mv $file $2/$file
	done
	cd $cwd
	echo
done