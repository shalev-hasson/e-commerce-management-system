# E-Commerce Management System

A web-based e-commerce management system developed as part of an academic project.  
The system allows users to register, log in, browse a dynamic clothing catalog, place orders, and manage inventory through a MySQL database.

## Overview

The application supports two main user flows:

- **Customer flow:** registration, login, product browsing, and order placement.
- **Manager flow:** inventory management, adding new products, uploading product images, and tracking stock updates.

The project focuses on backend logic, relational database integration, user session management, and operational workflows related to product catalog, orders, and inventory management.

## Features

- User registration and login
- Session-based authentication
- Role-based access for regular users and managers
- Dynamic product catalog loaded from a MySQL database
- Order processing and stock quantity updates
- Manager dashboard for adding new garments
- Product image upload and catalog display
- Inventory update tracking
- Relational database design for users, products, transactions, and inventory updates

## Technologies Used

- **Backend:** Python, Flask
- **Database:** MySQL, SQL
- **Frontend:** HTML, CSS
- **Session Management:** Flask-Session
- **Development Environment:** PyCharm

## Database Structure

The application uses a relational MySQL database named `TAUFashion_45`, including the following main tables:

- **Users** - stores user details, login credentials, and manager permissions
- **Garment** - stores product catalog data, including item name, price, quantity, image path, and campaign status
- **Transaction** - stores customer orders and purchased item quantities
- **Updates** - tracks inventory updates performed by managers

## Project Structure

```text
Group_45/
│
├── main.py
├── SQLscript_45.sql
│
├── templates/
│   ├── Connection.html
│   ├── Registration.html
│   ├── Home_page.html
│   └── manager_page.html
│
├── static/
│   ├── styles.css
│   └── images/
│
└── README.md
```

## How to Run the Project

1. Clone the repository:

```bash
git clone <repository-url>
cd e-commerce-management-system
```

2. Install the required packages:

```bash
pip install -r requirements.txt
```

3. Create the MySQL database using the provided SQL script:

```bash
mysql -u root -p < SQLscript_45.sql
```

4. Update the database connection settings in `main.py` according to your local MySQL configuration.

5. Run the Flask application:

```bash
python main.py
```

6. Open the application in your browser:

```text
http://127.0.0.1:5000
```

## Demo Data

The SQL script includes sample users and product data for demonstration purposes.  
Some users are defined as managers and can access the manager dashboard.

## Notes

This project was developed as an academic web application and demonstrates practical implementation of:

- Web application development
- SQL database design and integration
- User authentication and session management
- Role-based permissions
- Inventory and transaction management
- Data-driven operational workflows
