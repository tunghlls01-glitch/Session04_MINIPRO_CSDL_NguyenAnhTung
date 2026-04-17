CREATE DATABASE session04_miniproject;
USE session04_miniproject;

-- bảng sinh viên
CREATE TABLE Students (
	Student_id VARCHAR(20) PRIMARY KEY,
    Student_name VARCHAR(100) NOT NULL,
    Student_email VARCHAR(100) NOT NULL UNIQUE,
    date_of_birth DATE
);			
-- bảng giáo viên
CREATE TABLE Teachers (
	Teacher_id VARCHAR(20) PRIMARY KEY,
    Teacher_name VARCHAR(100) NOT NULL,
    Teacher_email VARCHAR(100) NOT NULL UNIQUE
);
-- bảng khóa học
CREATE TABLE Courses (
	Course_id VARCHAR(20) PRIMARY KEY, 
    Course_name VARCHAR(100) NOT NULL,
    Course_description TEXT NOT NULL,
    number_of_sessions INT NOT NULL,
    teacher_id VARCHAR(20) NOT NULL
);
-- bảng trung gian lưu thông tin sv đăng ký khóa học
CREATE TABLE Enrollments (
	Student_id VARCHAR(20) NOT NULL,
    Course_id VARCHAR(20) NOT NULL,
    Enrollment_date DATE,
    PRIMARY KEY (Student_id, Course_id)
);
-- bảng kết quả học tập
CREATE TABLE Scores (
	Student_id VARCHAR(20) NOT NULL,
    Course_id VARCHAR(20) NOT NULL,
    Interterm_score DECIMAL(4,2) CHECK (Interterm_score >= 0 AND Interterm_score <= 10),
    Final_score DECIMAL(4,2) CHECK (Final_score >= 0 AND Final_score <= 10),
    PRIMARY KEY (Student_id, Course_id)
);
-- N-N student với Enrollment 
ALTER TABLE Enrollments
ADD CONSTRAINT fk_enrollment_student
FOREIGN KEY (Student_id) REFERENCES Students(Student_id);
-- 1-N Course với Enrollment
ALTER TABLE Enrollments 
ADD CONSTRAINT fk_enrollment_course
FOREIGN KEY (Course_id) REFERENCES Courses(Course_id);
-- 1-N Teacher với Course
ALTER TABLE Courses
ADD CONSTRAINT fk_courses_teachers
FOREIGN KEY (Teacher_id) REFERENCES Teachers(Teacher_id);
-- 1-N Student với Score
ALTER TABLE Scores 
ADD CONSTRAINT fk_score_student
FOREIGN KEY (Student_id) REFERENCES Students(Student_id);
-- 1-N Course với Score
ALTER TABLE Scores 
ADD CONSTRAINT fk_score_course
FOREIGN KEY (Course_id) REFERENCES Courses(Course_id);

-- Thêm 5 danh mục vô bảng sinh viên
INSERT INTO Students (Student_id, Student_name, Student_email, date_of_birth)
VALUES 
('SV01', 'Nguyễn Anh Tùng', 'tung@gmail.com', '2007-03-10'),
('SV02', 'Ngô Tiến Khang', 'khang@gmail.com', '2007-09-01'),
('SV03', 'Phan Minh Quang', 'quang@gmail.com', '2007-11-30'),
('SV04', 'Hoàng Đình Trung Dũng', 'dung@gmail.com', '2007-02-20'),
('SV05', 'Phùng Đỗ Việt Hùng', 'hung@gmail.com', '2007-01-09');
-- thêm 5 giảng viên 
INSERT INTO Teachers (Teacher_id, Teacher_name, Teacher_email)
VALUES 
('T01', 'Nguyễn Văn A', 'a@gmail.com'),
('T02', 'Trần Văn B', 'b@gmail.com'),
('T03', 'Lê Văn C', 'c@gmail.com'),
('T04', 'Phạm Văn D', 'd@gmail.com'),
('T05', 'Hoàng Văn E', 'e@gmail.com');
-- Thêm 5 khóa học vô bảng khóa học
INSERT INTO Courses (Course_id, Course_name, Course_description, number_of_sessions, teacher_id)
VALUES 
('C01', 'Cơ sở dữ liệu', 'Học về thiết kế và truy vấn cơ sở dữ liệu', 30, 'T01'),
('C02', 'Lập trình Java', 'Học lập trình hướng đối tượng với Java', 40, 'T02'),
('C03', 'Phát triển Web', 'Xây dựng website với HTML, CSS, JavaScript', 35, 'T03'),
('C04', 'Cấu trúc dữ liệu', 'Học về các cấu trúc dữ liệu và giải thuật', 45, 'T04'),
('C05', 'Trí tuệ nhân tạo', 'Giới thiệu về AI và Machine Learning', 50, 'T05');
-- Thêm dữ liệu đăng ký học cho sinh viên 
INSERT INTO Enrollments (Student_id, Course_id, Enrollment_date)
VALUES
('SV01', 'C01', '2025-01-10'),
('SV01', 'C02', '2025-01-12'),
('SV02', 'C01', '2025-01-11'),
('SV03', 'C03', '2025-01-15'),
('SV04', 'C04', '2025-01-18'),
('SV05', 'C05', '2025-01-20'),
('SV02', 'C02', '2025-01-22'),
('SV03', 'C01', '2025-01-25');
-- Thêm dữ liệu kết quả học tập cho sinh viên 
INSERT INTO Scores (Student_id, Course_id, Interterm_score, Final_score)
VALUES
('SV01', 'C01', 7.5, 8.0),
('SV01', 'C02', 6.0, 7.0),
('SV02', 'C01', 8.5, 9.0),
('SV03', 'C03', 5.5, 6.5),
('SV04', 'C04', 7.0, 7.5),
('SV05', 'C05', 9.0, 9.5),
('SV02', 'C02', 6.5, 7.0),
('SV03', 'C01', 8.0, 8.5);
-- Cập nhật 
-- cập nhật email 1 sinh viên
UPDATE Students 
SET Student_email = 'tunghlls01@gmail.com'
WHERE Student_id = 'SV01';
-- cập nhật mô tả 1 khóa học
UPDATE Courses
SET Course_description = 'Học lập trình hướng đối tượng với Java, bao gồm các khái niệm: class, object,...'
WHERE Course_id = 'C02';
-- cập nhật điểm cuối kì 1 sinh viên
UPDATE Scores 
SET Final_score = 10
WHERE Student_id = 'SV03' AND Course_id = 'C03';
-- xóa
-- Xóa kết quả học tập tương ứng (nếu cần)
DELETE FROM Scores
WHERE Student_id = 'SV03' AND Course_id = 'C03';
-- Xóa một lượt đăng ký học không hợp lệ
DELETE FROM Enrollments 
WHERE Student_id = 'SV03' AND Course_id = 'C03';
/*
Xóa scores trước mới đến Enrollments vì Scores là con của Enrollments phải xóa con trước tránh vi phạm ràng buộc khóa ngoại. 
(Em thấy trong bài làm tuần tự sai nên em đổi lại ạ)
*/

-- Truy vấn
-- Lấy danh sách tất cả sinh viên (Student)
SELECT * FROM Students;
-- Lấy danh sách giảng viên (Teacher)
SELECT * FROM Teachers;
-- Lấy danh sách các khóa học (Course)
SELECT * FROM Courses;
-- Lấy thông tin các lượt đăng ký khóa học (Enrollment)
SELECT * FROM Enrollments;
-- Lấy thông tin các lần đánh giá kết quả (Score)
SELECT * FROM Scores;








