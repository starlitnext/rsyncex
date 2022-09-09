#!/bin/bash

source `dirname $0`/config.sh

usage() {
	echo -e "Usage:\n $0 [-h] [-p 'path.sh'] [-t 'target'] [-u] [-s]"
	echo -e "[-h]: show help"
	echo -e "[-p]: set pathes"
	echo -e "[-t]: set target dir or file, relative path"
	echo -e "[-u]: run upload command"
	echo -e "[-s]: show command"
	exit 1
}

if [[ $# -eq 0 ]]; then
	usage
fi

function set_target() {
	TARGET=$1
	if [ -d $CLIENT_DIR/$TARGET ]; then
		echo "Target is Dir"
		UPLOAD_CMD="rsync $UPLOAD_PARAM $SSH_PARAM $CLIENT_DIR/$TARGET/ $REMOTE_HOST:$SERVER_DIR/$TARGET"
		DOWNLOAD_CMD="rsync $DOWNLOAD_PARAM $SSH_PARAM $REMOTE_HOST:$SERVER_DIR/$TARGET/ $CLIENT_DIR/$TARGET"
	else
		echo "Target is File"
		UPLOAD_CMD="rsync $UPLOAD_PARAM $SSH_PARAM $CLIENT_DIR/$TARGET $REMOTE_HOST:$SERVER_DIR/$TARGET"
		DOWNLOAD_CMD="rsync $DOWNLOAD_PARAM $SSH_PARAM $REMOTE_HOST:$SERVER_DIR/$TARGET $CLIENT_DIR/${TARGET##*/}"
	fi
}

SHOW_CMD=0
CMD=""
while getopts "hp:t:uds" arg; do
	case $arg in
		h)
			usage;;
		p)
			echo "Set path: $OPTARG" 
			source `dirname $0`/$OPTARG
			;;
		t)
			set_target $OPTARG
			echo "Target: $TARGET"
			;;
		u)
			echo "Upload ..."
			CMD=$UPLOAD_CMD
			;;
		d)
			echo "Download ..."
			CMD=$DOWNLOAD_CMD
			;;
		s)
			SHOW_CMD=1
			;;
		?)
			echo "Error: $OPTARG"
			usage;;
	esac
done

if [ $SHOW_CMD -ne 0 ]; then
	echo "REMOTE HOST: $REMOTE_HOST"
	echo "CLIENT DIR: $CLIENT_DIR"
	echo "SERVER DIR: $SERVER_DIR"
	echo "CMD: $CMD"
fi

if [ -n "$CMD" ]; then
	eval $CMD
fi

