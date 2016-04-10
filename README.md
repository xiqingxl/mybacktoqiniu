给 ./backuptoqiniu.sh 添加执行权限

chmod +x backuptoqiniu.sh

执行 ./backuptoqiniu.sh 开始备份上传

利用 cron 定时执行，以下示例为每天凌晨02:00执行备份，请确认脚本路径

crontab -e

进入 cron 编辑，按 i 进入编辑模式，在最后输入以下内容

0 2 * * * /yourpath/backuptoqiniu.sh

按 esc 键，输入 :wq，回车保存文件，正常会出如下提示：

crontab: installing new crontab
