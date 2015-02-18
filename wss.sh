#!/bin/bash
set -o noglobe

# A POSIX variable
OPTIND=0         # Reset in case getopts has been used previously in the shell.

# Temporary filename pattern
TEMP_FILE_PATTERN="sw_%d.sw"

echo [WSS] Checking parameters...
while [[ $# > 1 ]]; do

	key="$1"

	case $key in
	
		-i|--input)
			input="$2"
			shift
			;;
		
		-w|--width)
			width="$2"
			shift
			;;

		-h|--height)
			height="$2"
			shift
			;;
		
		-o|--order)
			order="$2"
			shift
			;;

		*)
			# unknown option
			;;

	esac

	shift

done

input=( ${input} )
[ ${#input[@]} -eq 0 ] && echo "Missing 'input' argument or no input files match the wildcard"  && exit 1
[ -z $input ]   && echo "Missing 'input' argument"  && exit 1
[ -z $width ]   && echo "Missing 'width' argument"  && exit 1
[ -z $height ]  && echo "Missing 'height' argument" && exit 1
[ -z $order ]   && echo "Missing 'order' argument"  && exit 1

for file in "${input[@]}"; do 
	file_base="${file##*/}"
	file_ext="${file_base##*.}"
	file_name="${file_base%.*}"

	file_dest="${file_name}.out.${file_ext}"

	echo "[WSS] Processing file: ${file_name}.${file_ext} to ${file_dest}"
	
	echo "[WSS]   Splitting..."
	convert -crop "${width}x${height}" +repage "${file}" "${TEMP_FILE_PATTERN}"

	append_command="convert +append"

	IFS=', ' read -a orders <<< "$order"
	for i in "${orders[@]}"; do
		i=$((i - 1))
		tile_file_name=${TEMP_FILE_PATTERN//%d/${i}}
		append_command="${append_command} ${tile_file_name}"
	done
	append_command="${append_command} ${file_dest}"

	echo "[WSS]   Joining..."
	$append_command

	echo "[WSS]   Deleting temporary files..."
	rm -rf ./${TEMP_FILE_PATTERN//%d/*}

	echo "[WSS]   Done."

done
echo "[WSS] All done."