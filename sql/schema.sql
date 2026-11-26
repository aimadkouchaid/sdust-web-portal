DROP DATABASE IF EXISTS webst;
CREATE DATABASE webst CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE webst;

CREATE TABLE users (
  id VARCHAR(20) PRIMARY KEY,
  password_hash VARCHAR(60) NOT NULL,
  role ENUM('student','teacher','counselor') NOT NULL,
  name VARCHAR(50) NOT NULL,
  gender ENUM('male','female'),
  email VARCHAR(100),
  phone VARCHAR(20),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE colleges (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE majors (
  id INT AUTO_INCREMENT PRIMARY KEY,
  college_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  UNIQUE KEY uq_major (college_id, name),
  FOREIGN KEY (college_id) REFERENCES colleges(id)
);

CREATE TABLE staff (
  staff_id VARCHAR(20) PRIMARY KEY,
  college_id INT,
  title VARCHAR(50),
  office VARCHAR(100),
  FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (college_id) REFERENCES colleges(id)
);

CREATE TABLE students (
  student_id VARCHAR(20) PRIMARY KEY,
  major_id INT NOT NULL,
  counselor_id VARCHAR(20),
  enrollment_year YEAR NOT NULL,
  class_name VARCHAR(50),
  campus ENUM('Qingdao','Tai''an','Jinan') NOT NULL DEFAULT 'Qingdao',
  FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (major_id) REFERENCES majors(id),
  FOREIGN KEY (counselor_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(20) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  credits DECIMAL(3,1) NOT NULL,
  hours SMALLINT,
  nature ENUM('foundation','core','practice','general','elective'),
  attribute ENUM('required','elective') NOT NULL DEFAULT 'required',
  assessment ENUM('exam','assessment') NOT NULL DEFAULT 'exam',
  college_id INT,
  FOREIGN KEY (college_id) REFERENCES colleges(id)
);

CREATE TABLE semesters (
  name VARCHAR(20) PRIMARY KEY,
  start_date DATE NOT NULL,
  weeks TINYINT NOT NULL DEFAULT 18
);

CREATE TABLE course_classes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  teacher_id VARCHAR(20) NOT NULL,
  semester VARCHAR(20) NOT NULL,
  FOREIGN KEY (course_id) REFERENCES courses(id),
  FOREIGN KEY (teacher_id) REFERENCES users(id)
);

CREATE TABLE class_sessions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  class_id INT NOT NULL,
  day_of_week TINYINT NOT NULL,
  start_period TINYINT NOT NULL,
  end_period TINYINT NOT NULL,
  start_week TINYINT NOT NULL DEFAULT 1,
  end_week TINYINT NOT NULL DEFAULT 16,
  location VARCHAR(100),
  FOREIGN KEY (class_id) REFERENCES course_classes(id) ON DELETE CASCADE,
  CHECK (day_of_week BETWEEN 1 AND 7),
  CHECK (end_period >= start_period),
  CHECK (end_week >= start_week)
);

CREATE TABLE enrollments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  class_id INT NOT NULL,
  student_id VARCHAR(20) NOT NULL,
  score DECIMAL(5,2),
  grade_level ENUM('excellent','good','medium','pass','fail'),
  exam_nature ENUM('normal','makeup','retake') NOT NULL DEFAULT 'normal',
  grade_point DECIMAL(3,2),
  graded_at DATETIME,
  UNIQUE KEY uq_enrollment (class_id, student_id),
  FOREIGN KEY (class_id) REFERENCES course_classes(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  CHECK (score IS NULL OR score BETWEEN 0 AND 100)
);

CREATE TABLE exams (
  id INT AUTO_INCREMENT PRIMARY KEY,
  class_id INT NOT NULL,
  exam_type ENUM('midterm','final','makeup') NOT NULL,
  exam_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  location VARCHAR(100) NOT NULL,
  notes VARCHAR(500),
  created_by VARCHAR(20),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_exam_class_type (class_id, exam_type),
  KEY idx_exam_slot (exam_date, start_time),
  FOREIGN KEY (class_id) REFERENCES course_classes(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
  CHECK (end_time > start_time)
);

CREATE TABLE leave_requests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  request_no VARCHAR(20) UNIQUE,
  student_id VARCHAR(20) NOT NULL,
  leave_type ENUM('sick','personal','emergency','officialactivity') NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  destination VARCHAR(100) NOT NULL,
  contact_number VARCHAR(20) NOT NULL,
  reason TEXT NOT NULL,
  attachment_name VARCHAR(255),
  attachment_path VARCHAR(255),
  status ENUM('pending','approved','rejected','cancelled') NOT NULL DEFAULT 'pending',
  submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  reviewer_id VARCHAR(20),
  review_comment TEXT,
  reviewed_at DATETIME,
  KEY idx_leave_student (student_id, status, submitted_at),
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE SET NULL,
  CHECK (end_date >= start_date)
);

CREATE TABLE announcements (
  id INT AUTO_INCREMENT PRIMARY KEY,
  author_id VARCHAR(20),
  department VARCHAR(100) NOT NULL,
  category ENUM('academic','exams','international','student','campus') NOT NULL DEFAULT 'academic',
  title VARCHAR(200) NOT NULL,
  summary VARCHAR(500) NOT NULL,
  body TEXT NOT NULL,
  audience ENUM('all','student','teacher','counselor') NOT NULL DEFAULT 'all',
  published_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_announcement_feed (audience, published_at),
  KEY idx_announcement_author (author_id, published_at),
  FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE announcement_classes (
  announcement_id INT NOT NULL,
  class_id INT NOT NULL,
  PRIMARY KEY (announcement_id, class_id),
  KEY idx_announcement_class (class_id),
  FOREIGN KEY (announcement_id) REFERENCES announcements(id) ON DELETE CASCADE,
  FOREIGN KEY (class_id) REFERENCES course_classes(id) ON DELETE CASCADE
);

CREATE TABLE notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(20) NOT NULL,
  type ENUM('announcement','leave','grade','timetable','exam') NOT NULL,
  title VARCHAR(100) NOT NULL,
  message VARCHAR(255) NOT NULL,
  title_zh VARCHAR(100),
  message_zh VARCHAR(255),
  link VARCHAR(255),
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_notification_user (user_id, is_read, created_at),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

DELIMITER //

CREATE TRIGGER enrollments_grade_insert BEFORE INSERT ON enrollments
FOR EACH ROW
BEGIN
  IF NEW.score IS NULL THEN
    SET NEW.grade_point = NULL, NEW.graded_at = NULL;
  ELSE
    SET NEW.graded_at = NOW(),
      NEW.grade_point = CASE WHEN NEW.score >= 60 THEN ROUND((NEW.score - 50) / 10, 1) ELSE 0 END;
  END IF;
END//

CREATE TRIGGER enrollments_grade_update BEFORE UPDATE ON enrollments
FOR EACH ROW
BEGIN
  IF OLD.score IS NOT NULL AND (NOT (NEW.score <=> OLD.score) OR NOT (NEW.grade_level <=> OLD.grade_level)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Grade is final and cannot be changed';
  END IF;
  IF OLD.score IS NULL AND NEW.score IS NOT NULL THEN
    SET NEW.graded_at = NOW(),
      NEW.grade_point = CASE WHEN NEW.score >= 60 THEN ROUND((NEW.score - 50) / 10, 1) ELSE 0 END;
  ELSE
    SET NEW.grade_point = OLD.grade_point, NEW.graded_at = OLD.graded_at;
  END IF;
END//

DELIMITER ;
