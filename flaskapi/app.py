from flask import Flask, flash,render_template,jsonify,  request, redirect, url_for, session,flash
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re

app = Flask(__name__)
  
app.secret_key = 'xyzsdfg'
  
app.config['MYSQL_HOST'] = '10.29.8.22'
app.config['MYSQL_USER'] = 'chaitanya'
app.config['MYSQL_PASSWORD'] = 'chaitanya'
app.config['MYSQL_DB'] = 'user'
  
mysql = MySQL(app)
  
@app.route('/')
@app.route('/login', methods =['GET', 'POST'])
def login():
    mesage = ''
    if request.method == 'POST' and 'email' in request.form and 'password' in request.form:
        email = request.form['email']
        password = request.form['password']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM users WHERE email = % s AND password = % s', (email, password))
        account = cursor.fetchone()
        if account:
            session['loggedin'] = True
            session['userid'] = account['userid']
           # session['name'] = account['name']
            session['email'] = account['email']
            mesage = "success"
            return jsonify([mesage])
        else:
            mesage = 'Please enter correct email / password !'
            print("Unsucessful") 
            #flash("You are successfully login into the Flask Application")
    return  jsonify(mesage)
  
@app.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('userid', None)
    session.pop('email', None)
    return redirect(url_for('login'))
  
@app.route('/register', methods =['GET', 'POST'])
def register():
    mesage = ''
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form and 'email' in request.form :
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM users WHERE email = % s', (email, ))
        account = cursor.fetchone()
        if account:
            mesage = "Account already exists"
        #elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
            #mesage = "Invalid email address !"
        elif not username or not password or not email:
            mesage = "Please fill out the form !"
        else:
            cursor.execute('INSERT INTO users VALUES (NULL, % s, % s, % s)', (username, email, password ))
            mysql.connection.commit()
            mesage = "Registered"
    #elif request.method == 'POST':
       # mesage = 'Please fill out the form !'
    return  jsonify([mesage])
    
if __name__ == "__main__":
    app.run()