# SDUST Website
 
A website for **Shandong University of Science and Technology (SDUST)**, built as a final project. It has two parts:
 
- **Public site**: Home, Academics & Research, News & Announcements, Admissions and Campus Life.
- **Dashboard**: a logged-in area for students, teachers and counselors.
Everything is available in **English and Simplified Chinese** and works on phones, tablets and desktops.
 
## Features
 
**Public site**
- University facts, colleges, research labs and admissions information taken from the official SDUST website
- Public announcements (posted by counselors) and campus news
- Language switch (English / 中文) on every page, and a translated error page
**Student dashboard**
- Weekly timetable (Mon–Sun) with week navigation and **PDF download**
- Grades by semester, with GPA on SDUST's 5-point scale
- Exam schedule (upcoming and past)
- Leave requests: submit with an optional attachment, cancel, and download an approved **leave slip as a PDF**
- Announcements with search and category filters
- Notifications bell, profile, contact info and password change
**Teacher dashboard**
- Timetable (with PDF download) and **My Courses**: schedule, exams, class averages and student list for each class
- **Grade entry**: scores or 优/良/中/及格/不及格 grades, with a live grade-point preview. Grades are final once saved.
- Exam scheduling, with room and student clash checks
- Announcements to one class or to all of the teacher's students
**Counselor dashboard**
- Leave review (approve or reject with a comment), with status filters
- **My Students**: contact details, GPA, credits and leave status of the counselor's students
- Announcements to their own students, to all teachers, or public (shown on the public site)
## Tech stack
 
| Part | Technology |
|---|---|
| Pages | JSP + JSTL 3, CSS, jQuery 3.7.1 |
| Backend | Java 17, Jakarta Servlet 6.0 (servlets, filters, JDBC — no framework) |
| Database | MySQL (database `webst`) |
| Build / server | Maven (`war`), Apache Tomcat 10.1+ / 11 (or Jetty 12 through Maven) |
| Libraries | MySQL Connector/J, jBCrypt (password hashing), OpenPDF (PDF files) |
 
## Requirements
 
- JDK 17 or newer
- Maven 3.9+
- MySQL 8+ (tested on the local Homebrew MySQL)
- Apache Tomcat 10.1+ or 11 (Tomcat 9 does **not** work; the project uses the Jakarta namespace)
## Setup
 
### 1. Create the database
 
As the MySQL root user:
 
```sql
CREATE USER 'sdust'@'localhost' IDENTIFIED BY 'choose-a-password';
GRANT ALL PRIVILEGES ON webst.* TO 'sdust'@'localhost';
SET PERSIST log_bin_trust_function_creators = ON;
```
 
The last line is needed because the schema creates triggers (grades are final once entered). Without it, a user without the SUPER privilege gets error 1419.
 
Then load the schema and the sample data:
 
```bash
mysql -u root -p < sql/schema.sql
mysql -u sdust -p < sql/seed.sql
```
 
`sql/schema.sql` **drops and recreates** the `webst` database, so running it again resets all data.
 
### 2. Configure the connection
 
Edit `src/main/resources/db.properties`:
 
```properties
db.url=jdbc:mysql://localhost:3306/webst?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
db.user=sdust
db.password=choose-a-password
```
 
Don't commit real credentials.
 
### 3. Build and run
 
**Option A: Tomcat** (the deploy script finds a Homebrew Tomcat on its own, or uses `TOMCAT_HOME`):
 
```bash
./deploy.sh
# or: TOMCAT_HOME=/path/to/tomcat ./deploy.sh
```
 
It builds the WAR, copies it to Tomcat's `webapps/`, starts Tomcat if needed, and waits until the site answers.
 
**Option B: Jetty through Maven** (stop Tomcat first; both use port 8080):
 
```bash
mvn jetty:run
```
 
**Option C: build only**
 
```bash
mvn package    # creates target/sdust.war
```
 
Then open **http://localhost:8080/sdust/**.
 
## Sample accounts
 
All accounts use the password **`Sdust2026`**. Choose the matching role under "Login as".
 
| Role | ID | Name | Notes |
|---|---|---|---|
| Student | `202411070169` | Aimad Kouchaid | The real student: real 2025-2026-2 grades and 2026-2027-1 timetable |
| Student | `202411070142`, `202411070155`, `202411070163` | Sample students | Class Software Engineering 2024-1, counselor C1024 |
| Student | `202411070177`, `202411070181`, `202411070186`, `202411070193` | Sample students | Class Software Engineering 2024-2, counselor C1025 |
| Counselor | `C1024` | Zhou Lin | Class 2024-1 |
| Counselor | `C1025` | Liu Yang | Class 2024-2 (one student is on leave this week) |
| Teacher | `T2031`–`T2037` | Teachers of the 2026-2027-1 timetable | e.g. `T2032` Qi Liang, `T2036` Dongye Changlei |
| Teacher | `T2040`–`T2045` | Teachers of the 2025-2026-2 courses | Sample teachers |
| Teacher | `T2038`, `T2039` | Teachers of older sample semesters | |
 
The sample data is set around **November 2026** (semester 2026-2027-1, week 13).
 
## Project structure
 
```
pom.xml                  Maven build
deploy.sh                Build and deploy to a local Tomcat
sql/schema.sql           Database schema (tables and grade triggers)
sql/seed.sql             Sample data for every page
src/main/java/edu/sdust/
  db/                    JDBC connections (reads db.properties)
  model/                 Records for users, leave requests, exams, grades, announcements, …
  dao/                   Database access
  web/                   Servlets and filters (login, forms, PDFs, language)
  i18n/                  Texts: translations and localized dates for the dashboard
src/main/resources/
  i18n/                  messages.properties (English) and messages_zh.properties (Chinese)
  fonts/                 Noto Sans SC font for the Chinese PDFs (SIL Open Font License)
src/main/webapp/
  WEB-INF/views/         JSP pages: public/, shared/, student/, teacher/, counselor/, error/
  WEB-INF/tags/          Reusable JSP tags (exam card, announcement card, profile field)
  css/, js/, assets/     Styles, scripts, images, logos and video
```
 
## Notes
 
- **Security:**
  - passwords are stored as bcrypt hashes;
  - every form that changes data carries a CSRF token;
  - sessions are cookie-only and HttpOnly, with a 30-minute timeout;
  - the login page never reveals which IDs exist.
- **Uploads:** leave-request attachments are stored outside the WAR, in `$SDUST_UPLOAD_DIR` or `~/sdust-uploads`.
- **Passwords:** they can't be reset online; users are told to contact their counselor.
- **No admin role:** semester dates, office announcements and make-up/retake exams can only be changed in the database.
- **Content sources:**
  - the facts, figures and campus photos come from the official site [en.sdust.edu.cn](https://en.sdust.edu.cn/) and [cie.sdust.edu.cn](http://cie.sdust.edu.cn/);
  - the news stories, the sample people and the grades of the earlier semesters are sample content.