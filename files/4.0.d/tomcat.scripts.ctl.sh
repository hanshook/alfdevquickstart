#!/bin/sh

CATALINA_HOME=<INSTALL_DIR>/tomcat
TOMCAT_BINDIR=<INSTALL_DIR>/tomcat/bin
JRE_HOME=<JAVA_HOME>
CATALINA_PID=<INSTALL_DIR>/tomcat/temp/catalina.pid
export CATALINA_PID
TOMCAT_STATUS=""
ERROR=0
PID=""

start_tomcat() {
    is_tomcat_running
    RUNNING=$?
    if [ $RUNNING -eq 1 ]; then
        echo "$0 $ARG: tomcat (pid $PID) already running"
    else
	rm -f $CATALINA_PID
	export JAVA_OPTS="$DEBUG_OPTS -XX:MaxPermSize=512m -Xms128m -Xmx1024m -XX:-DisableExplicitGC -Dalfresco.home=<INSTALL_DIR> -Dcom.sun.management.jmxremote -Dsun.security.ssl.allowUnsafeRenegotiation=true"
	export JAVA_HOME=$JRE_HOME
	$TOMCAT_BINDIR/startup.sh 
	if [ $? -eq 0 ];  then
            echo "$0 $ARG: tomcat started"
	else
            echo "$0 $ARG: tomcat could not be started"
            ERROR=1
	fi
    fi
}

daemon_tomcat() {
    export JAVA_OPTS="$DEBUG_OPTS -XX:MaxPermSize=512m -Xms128m -Xmx1024m -XX:-DisableExplicitGC -Dalfresco.home=<INSTALL_DIR> -Dcom.sun.management.jmxremote -Dsun.security.ssl.allowUnsafeRenegotiation=true"
    export JAVA_HOME=$JRE_HOME
    $TOMCAT_BINDIR/catalina.sh run
}

stop_tomcat() {
#    $TOMCAT_BINDIR/shutdown.sh 300 -force 
# Faster shutdown /HH
    $TOMCAT_BINDIR/shutdown.sh 60 -force 
    if [ $? -eq 0 ]; then
        echo "$0 $ARG: tomcat stopped"
        if [ -f $CATALINA_PID ] ; then
           rm $CATALINA_PID
         fi
        sleep 3
    else
        echo "$0 $ARG: tomcat could not be stopped"
        ERROR=2
    fi
}

get_pid() {
    PID=""
    PIDFILE=$1
    # check for pidfile
    if [ -f $PIDFILE ] ; then
        PID=`cat $PIDFILE`
    fi
}

get_tomcat_pid() {
    get_pid $CATALINA_PID
    if [ ! $PID ]; then
        return
    fi
}

is_service_running() {
    PID=$1
    if [ "x$PID" != "x" ] && kill -0 $PID 2>/dev/null ; then
        RUNNING=1
    else
        RUNNING=0
    fi
    return $RUNNING
}

is_tomcat_running() {
    get_tomcat_pid
    is_service_running $PID
    RUNNING=$?
    if [ $RUNNING -eq 0 ]; then
        TOMCAT_STATUS="tomcat not running"
    else
        TOMCAT_STATUS="tomcat already running"
    fi
    return $RUNNING
}

if [ "x$1" = "xstart" ]; then
    start_tomcat
    sleep 2
elif [ "x$1" = "xdaemon" ]; then
    daemon_tomcat
elif [ "x$1" = "xstop" ]; then
    stop_tomcat
    sleep 2
elif [ "x$1" = "xstatus" ]; then
    is_tomcat_running
    echo $TOMCAT_STATUS
fi

exit $ERROR
