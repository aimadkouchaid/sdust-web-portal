# SDUST Web Portal

A full-stack university portal for **Shandong University of Science and Technology (SDUST)**. It combines a bilingual public website with a role-based dashboard for students, teachers and counselors.

The project is built on plain Java Servlets, JSP and JDBC, with no framework. It shows the full path of a web request: routing and filters, data access, server-side validation, security and responsive front-end design.

![Java](https://img.shields.io/badge/Java-17-007396)
![Jakarta Servlet](https://img.shields.io/badge/Jakarta%20Servlet-6.0-blue)
![MySQL](https://img.shields.io/badge/MySQL-8-4479A1)
![Tomcat](https://img.shields.io/badge/Tomcat-10.1%2B-F8DC75)

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Security](#security)
- [Getting Started](#getting-started)
- [Demo Accounts](#demo-accounts)
- [Project Structure](#project-structure)
- [Limitations and Future Work](#limitations-and-future-work)
- [Author](#author)

---

## Overview

The portal has two parts:

| Part | Audience | Purpose |
|---|---|---|
| **Public website** | Prospective students, visitors | University information, news and announcements, admissions, campus life |
| **Dashboard** | Students, teachers, counselors | Timetables, grades, exams, leave requests, announcements and notifications |

Every page is available in **English and Simplified Chinese** and adapts to phones, tablets and desktops.

---

## Features

### Public Website
- Home, Academics & Research, News & Announcements, Admissions and Campus Life pages
- Content based on official SDUST information: history, colleges, research and admissions
- Public announcements published by counselors appear on the site
- Language switch (English / 中文) on every page, with a translated error page
- Scroll animations, responsive layout and accessible navigation

### Student Dashboard
- **Timetable**: weekly view (Mon–Sun) with week navigation, today highlighting and **PDF export**
- **Grades**: results by semester with automatically calculated GPA and earned credits
- **Exams**: upcoming and past exams with a countdown
- **Leave requests**: submit with an optional attachment, track the status, cancel while pending, and download an approved **leave slip (PDF)**
- **Announcements**: category filters and search
- **Notifications**, profile, contact details and password change

### Teacher Dashboard
- Timetable with PDF export
- **My Courses**: schedule, exams, class averages and student list for each class
- **Grade entry**: numeric scores or graded levels (优 / 良 / 中 / 及格 / 不及格), with a live grade-point preview and a confirmation step. **Grades are final once saved.**
- **Exam scheduling**, with room and student clash detection
- Announcements to one class or to all of the teacher's students

### Counselor Dashboard
- **Leave review**: approve or reject with a comment, filter by status, open attachments
- **My Students**: contact details, GPA, credits and current leave status
- Announcements to the counselor's students, to all teachers, or to the public website

### Cross-Role Workflows
| Action | Result |
|---|---|
| A teacher saves a grade | The student's grades and GPA update, the counselor's student list updates, and the student is notified |
| A student submits a leave request | It appears in the assigned counselor's review queue |
| A counselor approves or rejects it | The student sees the new status and comment, can download the leave slip, and is notified |
| A teacher schedules an exam | The exam appears for every student in the class, who are notified |

---

## Architecture

The application follows a layered MVC structure:

```
Browser
   │  HTTP
   ▼
Filters ── language, authentication and role checks, caching
   │
   ▼
Servlets (controllers) ── validate input, enforce permissions
   │
   ▼
DAO layer ── JDBC with PreparedStatement, transactions
   │
   ▼
MySQL ── schema with constraints and triggers
   │
   ▼
JSP + JSTL views ── rendered with escaped output, then enhanced with jQuery
```

Key design decisions:
- **Business rules are enforced at more than one layer.** For example, "grades are final" is checked in the servlet and also guaranteed by a MySQL trigger, so it holds even if application code is bypassed.
- **Ownership is checked in the SQL itself.** A teacher can only grade their own classes and a counselor can only review their own students' requests, because the queries filter by the logged-in user.
- **Internationalization** uses JSTL `fmt` resource bundles. The language is stored in a cookie and applied by a filter on every request, including error pages.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Front end | JSP, JSTL 3, HTML5, CSS3, jQuery 3.7.1 |
| Back end | Java 17, Jakarta Servlet 6.0, JDBC |
| Database | MySQL 8 |
| Build and server | Maven (WAR packaging), Apache Tomcat 10.1+ / 11, Jetty 12 (development) |
| Libraries | MySQL Connector/J, jBCrypt (password hashing), OpenPDF (PDF generation) |

---

## Security

- Passwords are stored as **bcrypt** hashes.
- Every form that changes data is protected by a **CSRF token**.
- All SQL uses **prepared statements**.
- Output is escaped with `<c:out>` / `fn:escapeXml` to prevent XSS.
- Sessions are cookie-only and **HttpOnly**, with a 30-minute timeout. A new session is created at login to prevent session fixation.
- Login errors never reveal whether an ID exists or which role it has.
- **Role-based access control** applies to every dashboard route and every form action.
- Uploaded files are stored outside the web root under random names, and are only served to their owner and the reviewing counselor.

---

## Getting Started

### Prerequisites
- JDK 17 or newer
- Maven 3.9+
- MySQL 8+
- Apache Tomcat 10.1+ or 11 (Tomcat 9 is not supported, because the project uses the Jakarta namespace)

### 1. Set up the database

As the MySQL root user:

```sql
CREATE USER 'sdust'@'localhost' IDENTIFIED BY 'choose-a-password';
GRANT ALL PRIVILEGES ON webst.* TO 'sdust'@'localhost';
SET PERSIST log_bin_trust_function_creators = ON;
```

The last line lets a non-SUPER user create the schema's triggers.

Load the schema and the sample data:

```bash
mysql -u root -p < sql/schema.sql
mysql -u sdust -p < sql/seed.sql
```

`schema.sql` drops and recreates the `webst` database, so running it again resets all data.

### 2. Configure the connection

Copy the template and fill in your credentials:

```bash
cp src/main/resources/db.properties.example src/main/resources/db.properties
```

```properties
db.url=jdbc:mysql://localhost:3306/webst?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
db.user=sdust
db.password=choose-a-password
```

### 3. Build and run

**Tomcat**
```bash
./deploy.sh
```
The script builds the WAR, deploys it to Tomcat (Homebrew installation, or the one in `TOMCAT_HOME`), starts the server if needed and waits until the site responds.

**Jetty (development)**
```bash
mvn jetty:run
```

**Build only**
```bash
mvn package
```
This produces `target/sdust.war`.

Then open **http://localhost:8080/sdust/**.

---

## Demo Accounts

All demo accounts use the password **`Sdust2026`**. Select the matching role under **Login as**.

| Role | ID | Name |
|---|---|---|
| Student | `202411070169` | Aimad Kouchaid |
| Student | `202411070142`, `202411070155`, `202411070163` | Sample students (class SE 2024-1) |
| Student | `202411070177`, `202411070181`, `202411070186`, `202411070193` | Sample students (class SE 2024-2) |
| Counselor | `C1024` | Zhou Lin (class SE 2024-1) |
| Counselor | `C1025` | Liu Yang (class SE 2024-2) |
| Teacher | `T2031` – `T2045` | Course teachers |

The sample data is set in **semester 2026-2027-1 (November 2026)**.

---

## Project Structure

```
├── pom.xml                       Maven build configuration
├── deploy.sh                     Build and deploy script for Tomcat
├── sql/
│   ├── schema.sql                Tables, constraints and grade triggers
│   └── seed.sql                  Sample data for every page
└── src/main/
    ├── java/edu/sdust/
    │   ├── db/                   JDBC connection management
    │   ├── model/                Domain models
    │   ├── dao/                  Data access objects
    │   ├── web/                  Servlets and filters
    │   └── i18n/                 Translations and localized dates
    ├── resources/
    │   ├── i18n/                 English and Chinese message bundles
    │   └── fonts/                Noto Sans SC for Chinese PDFs
    └── webapp/
        ├── WEB-INF/views/        JSP views by role: public, shared, student, teacher, counselor, error
        ├── WEB-INF/tags/         Reusable JSP tag files
        └── css/, js/, assets/    Styles, scripts and media
```

---

## Limitations and Future Work

- **No administrator role.** Semester dates, users and courses are managed directly in the database.
- **Database content is single-language.** Course names and staff-posted announcements are stored in English. The interface itself is fully bilingual.
- **No online password reset.** Users are asked to contact their counselor.
- Possible extensions: an admin panel, email notifications, course selection, and a REST API for a mobile client.

---

## Author

**Kouchaid Aimad**
Software Engineering, Class of 2024
Shandong University of Science and Technology

Developed as a final project.

> University facts, figures and campus photos are based on the official SDUST websites ([en.sdust.edu.cn](https://en.sdust.edu.cn/), [cie.sdust.edu.cn](http://cie.sdust.edu.cn/)). News stories, sample people and earlier-semester grades are fictional demo data. This is an academic project and is not affiliated with or endorsed by the university.