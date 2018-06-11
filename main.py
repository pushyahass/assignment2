from datetime import date

from flask import Flask,render_template, request
import csv
import os
import mysql.connector
app = Flask(__name__)

mydb = mysql.connector.connect(host='localhost', user='root', passwd='', db='cloud')
#cur = mydb.cursor()
cur = mydb.cursor(buffered=True)
reader = csv.reader(open('static/all_month.csv', 'r'))
for row in reader:
    insstmt = "INSERT INTO earthquake (time1,latitude,longitude,depth,mag,magType,nst,gap,dmin,rms,net,id,updated,place,type1,horizontalerror,deptherror,magerror,magnst,status,locationsource,magsource) VALUES (%s, %s, %s ,%s ,%s ,%s ,%s ,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
    to_db = [row[0], row[1], row[2], row[3], row[4], row[5],row[6],row[7],row[8],row[9],row[10],row[11],row[12],row[13],row[14],row[15],row[16],row[17],row[18],row[19],row[20],row[21]]
    cur.execute(insstmt, to_db)
mydb.commit()

APP_ROOT = os.path.dirname(os.path.abspath(__file__))


@app.route('/')
def index():
    return render_template('index.html')


@app.route("/upload", methods=['POST'])
def upload():
    loc = os.path.join(APP_ROOT, 'static/')
    print(loc)

    if not os.path.isdir(loc):
        os.mkdir(loc)

    for file in request.files.getlist("file"):
        print(file)
        filename = file.filename
        dest_loc = "/".join([loc, filename])
        print(dest_loc)
        file.save(dest_loc)

    return render_template("success.html")


@app.route("/magnitude", methods=['POST'])
def magnitude():
    mag = request.form['magnitude']
    cur.execute("SELECT place,Date_Format(time1,'%m/%d/%Y') FROM earthquake WHERE mag> %s", (mag,))
    #count = cur.execute("SELECT count(*) FROM earthquake WHERE mag> %s", (mag,))
    #print(count[0])
    rows = cur.fetchall()
    return render_template("magnitude.html", mag_rows=rows)


@app.route("/mag_range", methods=['POST'])
def mag_range():
    from_mag = request.form['from_mag']
    to_mag = request.form['to_mag']
    from_date = request.form['from_date']
    to_date = request.form['to_date']
    cur.execute("SELECT place,Date_Format(time1,'%m/%d/%Y') FROM earthquake WHERE mag>= %s and mag <= %s and time1 between %s and %s ",(from_mag, to_mag, from_date, to_date),)
    rows = cur.fetchall()
    return render_template("mag_range.html", mag_rows=rows)


@app.route("/location", methods=['POST'])
def location():
    loc = request.form['loc']
    kms = request.form['kms']
    cur.execute("DROP VIEW IF EXISTS quake")
    cur.execute("CREATE VIEW quake as (select place,time1,TRIM(SUBSTRING(place,(LOCATE(',', place) +1))) as location,SUBSTRING(place, 1, LOCATE('k', place) - 1) as kms from earthquake)")
    cur.execute("select place, Date_Format(time1,'%m/%d/%Y') from quake where location LIKE %s and kms <=%s", (loc, kms,))
    rows = cur.fetchall()
    return render_template("mag_range.html", mag_rows=rows)


@app.route("/night", methods=['POST'])
def night():
    cur.execute("DROP VIEW IF EXISTS quaketime")
    cur.execute("CREATE VIEW quaketime as (select place,time1,mag,DATE_FORMAT(time1,'%H:%i:%s') as timeofquake from earthquake)")
    cur.execute("select count(place) from quaketime where mag>4.0 and (timeofquake >'20:00:00' or timeofquake <'4:00:00') ")
    countofquakes = cur.fetchall()

    cur.execute("select count(place) from quaketime where mag>4.0 and (timeofquake <'20:00:00' or timeofquake >'4:00:00')" )
    countofquakes1 = cur.fetchall()
    countofquakes.append(countofquakes1)
    return render_template("night.html", count=countofquakes)


if __name__ == '__main__':
    app.run()
