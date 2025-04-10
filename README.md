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

# 03 - Redis

## Verify Redis is Running
```sh
sudo systemctl status redis
```

## Redis Default Port
```
Port: 6379
```
```sh
ss -ltnp | grep 6379
netstat -lntp | grep 6379
```

## Connect to Redis CLI Locally
```sh
redis-cli
```

## Connect to Redis CLI Remotely
```sh
redis-cli -h <server_ip> -p 6379
```

## Enable Remote Access
1. Edit the Redis configuration:
   ```sh
   sudo sed -i 's/^bind .*/bind 0.0.0.0/' /etc/redis/redis.conf
   ```
2. Restart Redis:
   ```sh
   sudo systemctl restart redis
   ```

## Basic Tests in Redis CLI
After connecting to `redis-cli`, you can perform the following checks:

1. **Ping the server**  
   ```sh
   redis-cli ping
   ```
   Expect `PONG`.

2. **Check server info**  
   ```sh
   redis-cli info
   ```
   Displays general information, including memory usage, clients, persistence, and more.

3. **Test key set/get**  
   ```sh
   redis-cli set testkey "hello"
   redis-cli get testkey
   ```
   Should return `hello`.

4. **Test list operations**  
   ```sh
   redis-cli rpush testlist "one" "two" "three"
   redis-cli lrange testlist 0 -1
   ```
   Should return:
   ```
   1) "one"
   2) "two"
   3) "three"
   ```

5. **Check connected clients**  
   ```sh
   redis-cli client list
   ```

6. **Check slow logs**  
   ```sh
   redis-cli slowlog get 10
   ```

7. **Monitor real-time commands** (useful for debugging)  
   ```sh
   redis-cli monitor
   ```
   Press <kbd>Ctrl+C</kbd> to stop.

8. **Clean up test data**  
   ```sh
   redis-cli del testkey
   redis-cli del testlist
   ```


# 04 - RabbitMQ

## Verify RabbitMQ is Running
```sh
sudo systemctl status rabbitmq-server
```

## RabbitMQ Default Ports
```
AMQP Port: 5672
Management UI Port: 15672
```
```sh
ss -ltnp | grep 5672
ss -ltnp | grep 15672
netstat -lntp | grep 5672
netstat -lntp | grep 15672
```

## Connect to RabbitMQ CLI
```sh
rabbitmqctl status
```

## List Users
```sh
rabbitmqctl list_users
```

## Add a RabbitMQ User
```sh
rabbitmqctl add_user roboshop roboshop123
```

## Set Permissions for a User
```sh
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
```

## Enable Management Plugin
```sh
sudo rabbitmq-plugins enable rabbitmq_management
sudo systemctl restart rabbitmq-server
```

## Access Management UI
Open a browser and go to:
```
http://<server_ip>:15672
```
Login with your RabbitMQ user credentials.

## Connectivity Details
- **Firewall**: Ensure ports 5672 and 15672 are open.
  ```sh
  sudo firewall-cmd --permanent --add-port=5672/tcp
  sudo firewall-cmd --permanent --add-port=15672/tcp
  sudo firewall-cmd --reload
  ```
- **SELinux**: If enforcing, allow RabbitMQ network traffic:
  ```sh
  sudo setsebool -P nis_enabled 1
  ```
- **Test Connectivity**: From a remote host:
  ```sh
  telnet <server_ip> 5672
  nc -zv <server_ip> 5672
  ```
- **Erlang Cookie**: For clustering, ensure `/var/lib/rabbitmq/.erlang.cookie` is identical on all nodes and has permissions `400`.
- **Virtual Hosts**: List and create vhosts:
  ```sh
  rabbitmqctl list_vhosts
  rabbitmqctl add_vhost my_vhost
  ```
- **User Permissions on Vhost**:
  ```sh
  rabbitmqctl set_permissions -p my_vhost roboshop ".*" ".*" ".*"
  ```

## Troubleshooting
- **Logs**: Check logs for errors:
  ```sh
  sudo tail -f /var/log/rabbitmq/rabbit@$(hostname).log
  sudo tail -f /var/log/rabbitmq/rabbit@$(hostname)-sasl.log
  ```
- **Service Status**: Re-run `rabbitmqctl status` to verify node health.
- **Memory Alarms**: List and reset alarms:
  ```sh
  rabbitmqctl list_alarms
  rabbitmqctl clear_alarms
  ```
- **File Descriptors**: Increase limits if you see `fd_alloc_limit` warnings. Edit `/etc/security/limits.conf`:
  ```
  rabbitmq soft nofile 65536
  rabbitmq hard nofile 65536
  ```
- **Plugin Issues**: Verify plugins:
  ```sh
  rabbitmq-plugins list
  ```
- **Erlang Cookie Mismatch**: If clustering fails, ensure the cookie file content and permissions match.
- **Node Not Starting**: Check for port conflicts, correct ownership of `/var/lib/rabbitmq`, and available disk space.
- **Reset to Defaults**: If misconfigured, reset:
  ```sh
  sudo systemctl stop rabbitmq-server
  sudo rm -rf /var/lib/rabbitmq/mnesia/
  sudo systemctl start rabbitmq-server
  ```

