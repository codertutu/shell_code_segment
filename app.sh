#!/bin/bash -le
#processname: spring-boot  project

cd /data/
app=/data/springboot/admin/pay-web-admin.jar


function start(){
    PID=`ps aux | grep ${app} | grep -v grep | grep java | awk '{print $2}'`
    if [ ${PID} ];then
        echo "${app} 正在运行，请不要复制启动"
    else
        echo "开始启动 spring-boot 项目: ${app}"
        nohup java -jar -Xms512m -Xmx512m -Xss512k -Dspring.profiles.active=test ${app} --eureka.client.service-url.defaultZone=http://gaia:zijin2017@10.200.155.61:30000/eureka 2>&1 &
    fi
}
function stop(){
    PID=`ps aux | grep ${app} | grep -v grep | grep java | awk '{print $2}'`
    if [ ${PID} ];then
        echo "开始停止spring-boot 项目: ${app}!!!"
        kill ${PID}
        sleep 5
        PID2=`ps aux | grep ${app} | grep -v grep | grep java | awk '{print $2}'`
        if [ ${PID2} ];then
            echo "${app}没有停止成功，现在强制停止 ${app}"
            kill -9 ${PID}
        fi
    else
        echo "${app} 没有启动"
    fi
}

function status(){
    if [ ${PID} ];then
        echo "Tomcat is running ..."
    else
        echo "Tomcat is not exist!!!"
    fi
}

function restart(){
        stop
        start
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|status}"
        exit 1
esac

exit 0
