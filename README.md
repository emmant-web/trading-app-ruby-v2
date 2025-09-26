# Trading App 💹  

**Trading App** is a Ruby on Rails web application that simulates stock trading with role-based access for both **Admins** and **Users**.  
It provides authentication, admin approval, portfolio management, and trading features — all designed with **TailwindCSS** for a modern UI.  

---

## ✨ Features  

### 🔒 Authentication & Authorization  
- Secure signup, login, and logout using **Devise**  
- Role-based access for **Admins** and **Users**  
- **Admin approval/rejection** flow for new users  

### 📊 Admin Features  
- Create new users directly from the admin panel  
- View all registered users  
- Manage pending user approvals  
- View all transactions across all accounts  

### 👤 User Features  
- **Portfolio Page** – View owned stocks and holdings  
- **Trade Page** – Buy and sell stocks easily  
- **Transactions Page** – Track all personal trades and history  

### 🖥️ General Pages  
- Landing page with introduction
- Dedicated login and signup pages

---

## 🛠️ Tech Stack  

- **Backend**: Ruby on Rails  
- **Frontend**: ERB + Tailwind CSS  
- **Authentication**: Devise
- **Pagination**: Kaminari  
- **Search & Filtering**: Ransack  
- **Environment Management**: Dotenv  
- **Database**: PostgreSQL  


---

## 📸 Screenshots  

### 🏠 Landing Page  
First impression of the app with call-to-action. 

![Landing Page](app/assets/images/readme-imgs/landing-page.png)  

### 🔑 User Authentication (Sign Up & Login)  
- Secure signup and login for users  
- New users require admin approval before access  
![User Login](app/assets/images/readme-imgs/sign-up.png)  
![User Signup](app/assets/images/readme-imgs/login.png)   

### 💼 User Portfolio Page  
- Overview of owned stocks and their performance  
![Portfolio Page](app/assets/images/readme-imgs/user/user-portfolio-no-stocks.png)  
![Portfolio Page](app/assets/images/readme-imgs/user/user-portfolio-with-stocks.png)  

### 📈 Trade Page  
- Buy and sell stocks seamlessly  
![Trade Page](app/assets/images/readme-imgs/user/user-buy-sell-stocks-not-searched.png)   
![Trade Page](app/assets/images/readme-imgs/user/user-buy-sell-stocks-searched.png)   


### 📜 User Transactions  
- View personal trading history  
![User Transactions](app/assets/images/readme-imgs/user/user-transactions.png)   


### 📋 Admin Pages 
- Create new users directly  
![Admin Create New Users](app/assets/images/readme-imgs/admin/admin-create-new-user.png)  
- View all users  
![Admin View All Users](app/assets/images/readme-imgs/admin/admin-all-users.png)  
- Manage pending approvals  
![Admin Pending Approvals](app/assets/images/readme-imgs/admin/admin-pending-users.png)  
- View all transactions across accounts  
![Admin View Transactions](app/assets/images/readme-imgs/admin/admin-all-transactions.png)  



## 👥 Developed By

- emmant-web
- josepuzon