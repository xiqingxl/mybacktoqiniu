#!/bin/bash
#Author:ZhangGe
#Des:Backup database and webfile.
#Date:2014-8-28
TODAY=`date +%u`

if [ -z $1 ];then
        echo Needed Usage arguments. Please Use --help to get more infomation.
        exit 1
fi

if [ "$1" == "db" ];then
        domain=$2
        dbname=$3
        mysqluser=$4
        mysqlpd=$5
        back_path=$6
        test -d $back_path || (mkdir -p $back_path || echo "$back_path not found! Please CheckOut Or feedback to zhangge.net..." && exit 2)
        cd $back_path
        mysqldump -u$mysqluser -p$mysqlpd $dbname>$back_path/$domain\_db_$TODAY\.sql
        test -f $back_path/$domain\_db_$TODAY\.sql || (echo "MysqlDump failed! Please CheckOut Or feedback to zhangge.net..." && exit 2)
        zip --version >/dev/null && zip -m $back_path/$domain\_db_$TODAY\.zip $domain\_db_$TODAY\.sql || tar cvzf $back_path/$domain\_db_$TODAY\.tar.gz $domain\_db_$TODAY\.sql --remove-files

elif [ "$1" == "file" ];then
        domain=$2
        site_path=$3
        back_path=$4
        test -d $site_path || (echo "$site_path not found! Please CheckOut Or feedback to zhangge.net..." && exit 2)
        test -d $back_path || (mkdir -p $back_path || echo "$back_path not found! Please CheckOut Or feedback to zhangge.net..." && exit 2)
        test -f $back_path/$domain\_$TODAY\.zip && rm -f $back_path/$domain\_$TODAY\.zip
        zip --version >/dev/null && zip -9r $back_path/$domain\_$TODAY\.zip $site_path || tar cvzf $back_path/$domain\_$TODAY\.tar.gz $site_path

elif [ "$1" == "--help" ];then
        clear
        echo =====================================Help infomation=========================================
        echo 1. Use For Backup database:
        echo The \$1 must be \[db\]
        echo \$2: \[domain\]
        echo \$3: \[dbname\]
        echo \$4: \[mysqluser\]
        echo \$5: \[mysqlpassword\]
        echo \$6: \[back_path\]
        echo
        echo For example:./backup.sh db zhangge.net zhangge_db zhangge 123456 /home/wwwbackup/zhangge.net
        echo
        echo 2. Use For Backup webfile:
        echo The \$1 must be [\file\]:
        echo \$2: \[domain\]
        echo \$3: \[site_path\]
        echo \$4: \[back_path\]
        echo
        echo For example:./backup.sh file zhangge.net /home/wwwroot/zhangge.net /home/wwwbackup/zhangge.net
        echo =====================================End of Hlep==============================================
        exit 0
else
        echo "Error!Please Usage --help to get help infomation!"
        exit 2
fi
