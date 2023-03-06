import mysql.connector as mysql

HOST = "x.x.x.x"
DATABASE = "database"
USER = "remote-user"
PASSWORD = "password"

db_connection = mysql.connect(host=HOST, 
                              database=DATABASE, 
                              user=USER, 
                              password=PASSWORD)

print("Connected to:", db_connection.get_server_info())