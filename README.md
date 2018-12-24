README
======

Web-FTP - General Information
-----------------------------
This is a Web-ftp manager GUI. 


Requirements
------------

Web-FTP script requires PHP 5.x and up and with user feature. You'll need a MySQL Database with MySQLi support.
To use it with MySQL database you have to install a MySQL server or a container separatelly! Help here https://hub.docker.com/_/mysql
This connects to a FTP server (separated server or container).

Installation
------------
docker run -d --name web-ftp \
-e MYSQL_SERVER=ftp -e MYSQL_DATABASE=ftp-db -e MYSQL_USER=ftp_user -e MYSQL_PASSWORD=Ftp \
thomaskraswoski/web-ftp

So far, it doesn't give a installation routine or something else, it's only copying the files on your webserver and replace the information of the MySQL Database.
And at least, you must replace "mysql_config_my.php" with "mysql_config.php" in login.php, register.php and user.php. There are out-commented lines under the actual line, you only must delete the above one and uncomment the under one.

Documentation
-------------

soon...
