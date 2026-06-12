# 🎓 College Lost and Found Portal

A full-stack Java EE web application for managing lost and found items on a college campus. Built with Java Servlets, JSP, JDBC, MySQL, and Apache Tomcat following the **MVC architecture**.

---

## 🚀 Features

| Module | Features |
|--------|----------|
| **Auth** | Register with USN, Login, Logout, BCrypt passwords |
| **Dashboard** | Stats overview, My reports, My claims, Quick links |
| **Lost Items** | Report, Browse, Search, Filter by category |
| **Found Items** | Report, Browse, Search, Filter by category |
| **Claim System** | Submit claim with proof, Owner approve/reject, Auto-status update |
| **Admin Panel** | Stats, Manage users (enable/disable/delete), Approve/delete posts, Resolve claims |
| **Security** | BCrypt hashing, Session management, Role-based access |

---

## 🛠 Technology Stack

| Layer | Technology |
|-------|-----------|
| Frontend | HTML5, CSS3, Bootstrap 5, Font Awesome 6, Vanilla JavaScript |
| Backend | Java 11, Java Servlets (javax.servlet 4), JSP |
| Database | MySQL 8+ with JDBC |
| Security | jBCrypt (password hashing) |
| File Upload | Apache Commons FileUpload |
| Build | Apache Maven 3 |
| Server | Apache Tomcat 9 |

---

## 📁 Project Structure

```
CollegeLostFound/
├── pom.xml
├── sql/
│   └── schema.sql                         ← Database initialization
└── src/main/
    ├── java/com/lostfound/
    │   ├── model/                         ← POJOs (User, Admin, LostItem, FoundItem, ClaimRequest)
    │   ├── dao/                           ← JDBC Data Access Objects
    │   └── servlet/                       ← MVC Controllers
    └── webapp/
        ├── WEB-INF/web.xml                ← Servlet deployment descriptor
        ├── jsp/                           ← JSP View pages (12 pages)
        ├── css/style.css                  ← Global dark-mode stylesheet
        ├── js/main.js                     ← Frontend interactivity
        └── images/uploads/               ← Uploaded item images (runtime)
```

---

## ⚙️ Setup Instructions

### Prerequisites
- **JDK 11+** — [Download](https://www.oracle.com/java/technologies/downloads/)
- **Apache Maven 3.6+** — [Download](https://maven.apache.org/download.cgi)
- **MySQL 8.0+** — [Download](https://dev.mysql.com/downloads/mysql/)
- **Apache Tomcat 9.0+** — [Download](https://tomcat.apache.org/download-90.cgi)

---

### Step 1 — Set Up the Database

Open MySQL and run the schema script:

```bash
mysql -u root -p < sql/schema.sql
```

Or open the file in MySQL Workbench and execute it. This will:
- Create the `college_lost_found` database
- Create all 5 tables with indexes and foreign keys
- Insert demo admin and 3 demo student accounts
- Insert sample lost/found items and a claim request

---

### Step 2 — Configure Database Connection

Edit [`DBConnection.java`](src/main/java/com/lostfound/dao/DBConnection.java):

```java
private static final String DB_URL      = "jdbc:mysql://localhost:3306/college_lost_found?useSSL=false&serverTimezone=Asia/Kolkata";
private static final String DB_USER     = "root";        // ← your MySQL username
private static final String DB_PASSWORD = "root";        // ← your MySQL password
```

---

### Step 3 — Build the WAR File

```bash
cd CollegeLostFound
mvn clean package
```

This produces `target/CollegeLostFound.war`.

---

### Step 4 — Deploy to Tomcat

```bash
# Copy the WAR to Tomcat's webapps directory
cp target/CollegeLostFound.war /path/to/apache-tomcat-9.x/webapps/

# Start Tomcat
/path/to/apache-tomcat-9.x/bin/startup.sh      # Linux/macOS
/path/to/apache-tomcat-9.x/bin/startup.bat      # Windows
```

---

### Step 5 — Access the Application

Open your browser and navigate to:

```
http://localhost:8080/CollegeLostFound
```

---

## 🔑 Default Credentials

### Admin
| Field | Value |
|-------|-------|
| URL | `http://localhost:8080/CollegeLostFound/admin-login` |
| Username | `admin` |
| Password | `admin@123` |

> ⚠️ **Change the admin password immediately after first login!**

### Demo Students
| USN | Password |
|-----|----------|
| `1RV20CS001` | `student@123` |
| `1RV20EC045` | `student@123` |
| `1RV20ME012` | `student@123` |

---

## 📐 Database Schema

```
users           ──┐
                  ├──< lost_items
                  ├──< found_items ──< claim_requests >── users
admins            └── (admin login)
```

### Tables
| Table | Purpose |
|-------|---------|
| `users` | Student/staff accounts |
| `admins` | Admin accounts (separate table) |
| `lost_items` | Lost item reports with status tracking |
| `found_items` | Found item reports with status tracking |
| `claim_requests` | Ownership claims with approve/reject workflow |

---

## 🔄 Application Flow

```
Register → Login → Dashboard
                ├── Report Lost Item → Browse Lost Items → Item Detail
                ├── Report Found Item → Browse Found Items → Item Detail → Claim
                └── My Claims (status tracking)

Admin Login → Admin Panel
           ├── Dashboard (stats)
           ├── Manage Users (enable/disable/delete)
           ├── Manage Lost Items (approve/delete)
           ├── Manage Found Items (approve/delete)
           └── Manage Claims (approve/reject)
```

---

## 🛡️ Security Notes

- Passwords are hashed using **BCrypt** (cost factor 10) — never stored in plaintext
- Session invalidation on logout
- Admin and user sessions are isolated
- SQL injection prevention via `PreparedStatement`
- File upload validated for type and size (max 5 MB)
- Unique filenames via `UUID` for uploaded images

---

## 🧩 Extending the Application

1. **Email Notifications** — Add JavaMail to `pom.xml` and send email on claim approval
2. **Pagination** — Add `LIMIT`/`OFFSET` to DAO queries and pass page number through servlets
3. **Real-time Notifications** — Add WebSocket support for live claim updates
4. **Password Reset** — Add forgot-password flow with email token
5. **Image Compression** — Use Thumbnailator library to resize uploads before saving

---

## 📝 Known Limitations

- Image uploads are stored on the server filesystem; use cloud storage (S3, Cloudinary) for production
- No email verification on registration
- Session-based auth (stateful); consider JWT for API-first approach

---

## 📄 License

This project is intended for educational use. Free to use and modify.
