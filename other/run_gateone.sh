
cd /git_wrk || exit 4

trap ctrl-c-func INT

function ctrl-c-func() {
	cd /git_wrk
	test -d "$LOGDIR"   || return
	test "$LOGDIR" = "" && return
	cp -pr GateOne/logs $0 GateOne/run_gateone.py $LOGDIR/
	echo "task env saved at $LOGDIR"
}

SCRIPT=$(pwd)/$0
STAMP=$(date -Iseconds)
STAMP=${STAMP//:/.}
BASE=${0##*/}
BASE=${BASE%.*}
LOGDIR=/git_wrk/logs/${BASE}_${STAMP}
mkdir -p $LOGDIR
LOG=$LOGDIR/batch.log

{
	# run_gateone.py does not install the application's site-packages, so:
	#export PYTHONPATH=/usr/local/zzz/lib/python2.7/site-packages:/usr/local/py27/lib/python2.7/site-packages
	export PYTHONPATH=/usr/local/py27/lib/python2.7/site-packages:/usr/local/zzz/lib/python2.7/site-packages

	export PATH=/usr/local/py27/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

	echo
	echo "*** PATH=$PATH"
	echo "*** PYTHON=$(type python)"
	echo "*** PYTHONPATH=$PYTHONPATH"
	echo

	rm -rf GateOne/logs/*
    mkdir -p GateOne/ssl
    cp -p /media/sf_HostDnloads/gateone_ssl_keys/* GateOne/ssl/

	cd /git_wrk/GateOne || exit 4

	./run_gateone.py

} 2>&1 | tee $LOG

