from flask import Flask, render_template ,request, url_for, redirect, session
import mysql.connector
from flask_session import Session
from datetime import datetime
app=Flask(__name__)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

mydb= mysql.connector.connect(
    host= "localhost",
    user="root",
    password="root",
    database= "TAUFashion_45"
)
cursor= mydb.cursor()


@app.route('/', methods=['GET', 'POST'])
def Connection():
    if request.method == 'POST':
        mail = request.form.get('mail')
        password = request.form.get('password')

        cursor.execute("select Mail, UPassword, UserName from Users ")
        users = cursor.fetchall()

        cursor.execute("select Mail from Users WHERE IsManager='Yes' ")
        managers = cursor.fetchall()

        managers_emails = [manager[0] for manager in managers]


        for i in range(len(users)):
            if users[i][0]==mail and users[i][1] == password:
                session['mail'] = mail
                session['username'] = users[i][2]
                if mail in managers_emails:
                    session['is_manager'] = True
                    return redirect(url_for('manager_page') + "#popup1")
                session['is_manager'] = False
                return redirect(url_for('Home_page') + '#popup6')
        else:
            return render_template("Connection.html", show_popup6=True)
    return render_template("Connection.html", show_popup6=False)

@app.route('/Registration', methods=['GET', 'POST'])
def Registration():
    if request.method == 'POST':
        username = request.form.get('user')
        mail = request.form.get('mail')
        password = request.form.get('password')
        birthdate = request.form.get('age')
        gender = request.form.get('gender')
        faculty = request.form.get('faculty')


        cursor.execute("SELECT COUNT(*) FROM Users WHERE Mail = %s", (mail,))
        result = cursor.fetchone()

        if result[0] > 0:
            return render_template("Registration.html", show_popup1=True)

        cursor.execute(
            "INSERT INTO Users (Mail, Username, BirthDate, UPassword, Gender, Faculty, IsManager) VALUES (%s, %s, %s, %s, %s, %s, %s)",
            (mail, username, birthdate, password, gender, faculty,  'No')
        )
        mydb.commit()
        session['mail'] = mail
        session['username'] = username
        session['is_manager'] = False
        return render_template("Home_page.html", show_popup5=True)

    return render_template("Registration.html", show_popup5=False , show_popup1=False)




@app.route('/Home_page',methods=['GET', 'POST'])
def Home_page():
    if not session.get("mail"):
        return redirect("/")

    cursor.execute("SELECT * FROM Garment WHERE Quantity > 0 ORDER BY Campaign DESC")
    garments = cursor.fetchall()

    garments_list = []
    for garment in garments:
        garments_list.append({
            'CatalogNum': garment[0],
            'name':       garment[1],
            'quantity':   garment[2],
            'price':      garment[3],
            'imagepath':  garment[4],
            'campaign' : garment[5]
        })



    if request.method == 'POST':

        cursor.execute("SELECT COALESCE(MAX(OrderNum), 0) + 1 FROM Transaction")
        new_order_num = cursor.fetchone()[0]
        now = datetime.now()
        current_datetime_str = now.strftime("%Y-%m-%d %H:%M:%S")
        for i in range(len(garments_list)):
            chosen_quantity = int(request.form.get(f"Quantity_{i}"))
            if chosen_quantity >0 :
                new_quantity = garments_list[i]['quantity'] - int(chosen_quantity)
                cursor.execute("UPDATE Garment SET Quantity = %s WHERE CatalogNum = %s",
                               (new_quantity, garments_list[i]['CatalogNum']))
                cursor.execute("INSERT INTO Transaction (OrderNum, OrderQuantity, ODate, Mail, CatalogNum)"
                               " VALUES (%s, %s, %s, %s, %s)",
                               (new_order_num, chosen_quantity, current_datetime_str, session['mail'], garments_list[i]['CatalogNum'] ))

        mydb.commit()


        cursor.execute("SELECT * FROM Garment WHERE Quantity > 0 ORDER BY Campaign DESC")
        garments = cursor.fetchall()

        garments_list = []
        for garment in garments:
            garments_list.append({
                'CatalogNum': garment[0],
                'name':       garment[1],
                'quantity':   garment[2],
                'price':      garment[3],
                'imagepath':  garment[4],
                'campaign': garment[5]

            })
        return render_template("Home_page.html", show_popup=True, garments=garments_list)

    return render_template("Home_page.html", show_popup=False, garments=garments_list)


@app.route('/manager_page', methods=['GET', 'POST'])
def manager_page():
    if not session.get("mail"):
        return redirect("/")

    cursor.execute("SELECT * FROM Garment")
    garments = cursor.fetchall()

    garments_list = []
    for garment in garments:
        garments_list.append({
            'CatalogNum': garment[0],
            'name':       garment[1],
            'quantity':   garment[2],
            'price':      garment[3],
            'imagepath':  garment[4],
            'campaign':   garment[5]
        })

    if request.method == 'POST':
        new_name = request.form.get('new_item_name')
        new_price = request.form.get('new_item_price')
        new_quantity = request.form.get('new_item_quantity')
        new_image = request.files.get('new_item_image')
        new_item_catalognum = request.form.get('new_item_catalognum')
        have_campaign = request.form.get('have_campaign')

        if new_name or new_price or new_quantity or new_image or new_item_catalognum or have_campaign:
            if not all([new_name, new_price, new_quantity, new_image, new_item_catalognum, have_campaign]):
                return "Please fill all fields for the new garment if you wish to add a new garment.", 400


            existing_catalog_nums = [garment['CatalogNum'] for garment in garments_list]
            if int(new_item_catalognum) in existing_catalog_nums:
                return render_template("manager_page.html", show_popup3=True, garments=garments_list)

            # שמירת התמונה
            imagepath = f'static/images/{new_image.filename}'
            new_image.save(imagepath)
            imagepath1=f'images/{new_image.filename}'

            # הוספת הפריט החדש לבסיס הנתונים
            cursor.execute(
                "INSERT INTO Garment (CatalogNum, GName, Quantity, Price, Imagepath, Campaign) "
                "VALUES (%s, %s, %s, %s, %s, %s)",
                (new_item_catalognum, new_name, int(new_quantity), float(new_price), imagepath1, have_campaign)
            )
            mydb.commit()
            return render_template("manager_page.html", show_popup1=True, garments=garments_list)

        # טיפול בעדכון מלאי

        for garment in garments_list:
            update_quantity = request.form.get(f"update_stock_{garment['CatalogNum']}")
            if update_quantity and update_quantity.isdigit():
                new_quantity = garment['quantity'] + int(update_quantity)
                cursor.execute(
                    "UPDATE Garment SET Quantity = %s WHERE CatalogNum = %s",
                    (new_quantity, garment['CatalogNum'])
                )
                now = datetime.now()
                current_datetime_str = now.strftime("%Y-%m-%d %H:%M:%S")
                cursor.execute("INSERT INTO Updates (Mail, CatalogNum, AddQuantity,UpdateDate)"
                                "VALUES (%s, %s, %s, %s)",
                                 (session['mail'], garment['CatalogNum'], int(update_quantity),current_datetime_str))

        mydb.commit()


        action = request.form.get('action')
        if action == 'home':
            return redirect('/Home_page')
        elif action == 'update':
            return render_template("manager_page.html", show_popup2=True, garments=garments_list)

    cursor.execute("SELECT * FROM Garment")
    garments = cursor.fetchall()

    garments_list = []
    for garment in garments:
        garments_list.append({
            'CatalogNum': garment[0],
            'name':       garment[1],
            'quantity':   garment[2],
            'price':      garment[3],
            'imagepath':  garment[4],
            'campaign':   garment[5]
        })


    return render_template("manager_page.html",show_popup1=False, show_popup2=False ,garments=garments_list)

@app.route('/logout', methods=['GET', 'POST'])
def logout():
    session.clear()
    return redirect("/")



if __name__ == "__main__":
    app.run(debug=True)

