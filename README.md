# shell-script-Roboshop

# 01 - MySQL

## Verify MySQL is Running
```sh
sudo systemctl status mysqld
```

## MySQL Default Port
```
Port: 3306
```
```sh
ss -ltnp | grep 3306
netstat -lntp | grep 3306
```

## Connect to MySQL Shell Locally
```sh
mysql -h localhost -u root -p
```

## Connect to MySQL Shell Remotely
```sh
mysql -h <server_ip> -P 3306 -u root -p
```

## List Databases
```sql
SHOW DATABASES;
```

## List Tables in a Database
```sql
USE mydatabase;
SHOW TABLES;
```

## Describe Table Schema
```sql
DESCRIBE mytable;
```

## Show CREATE Statement for Table
```sql
SHOW CREATE TABLE mytable\G;
```



# 02 - MongoDB

## Verify MongoDB is Running
```sh
sudo systemctl status mongod
```

## MongoDB Default Port
```
Port: 27017
```

```sh
ss -ltnp | grep 27017
netstat -lntp | grep 27017
```

## Connect to MongoDB Shell
```sh
mongosh
```

```sh
mongosh "mongodb://<ip>:27017"
```

