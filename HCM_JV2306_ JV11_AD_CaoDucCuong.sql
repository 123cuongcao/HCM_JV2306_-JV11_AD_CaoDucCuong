create database test11;
use test11;

create table teacher (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name varchar(100) not null unique,
    phone varchar(50) not null unique,
    email varchar(50) not null unique,
    birthday date not null
);

create table class_room (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name varchar(200) not null,
    total_student int default 0,
    start_date date,
    end_date date,
    constraint check_end_date_gt_start_date CHECK (end_date > start_date)
);

create table teacher_class (
    teacher_id int,
    class_room_id int,
    start_date date,
    end_date date,
    time_slot_start int,
    time_slot_end int,
    foreign key (teacher_id) references teacher(id),
    foreign key (class_room_id) references class_room(id)
);

create table student (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name varchar(150) not null,
    email varchar(100) not null unique,
    phone varchar(50) not null unique,
    gender tinyint not null check (gender IN (1, 2)),
    class_room_id int,
    birthday date not null,
    foreign key (class_room_id) references class_room(id)
);

create table subject (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name varchar(200) not null unique
);

create table mark (
    student_id int not null,
    subject_id int not null,
    score int not null check (score >= 0 and score <= 10),
    foreign key (student_id) references student(id),
    foreign key (subject_id) references subject(id)
);

INSERT INTO teacher (name, phone, email, birthday)
VALUES
    ('John Doe', '123456789', 'john.doe@example.com', '1990-01-01'),
    ('Jane Smith', '987654321', 'jane.smith@example.com', '1985-03-15'),
    ('Bob Johnson', '555123456', 'bob.johnson@example.com', '1982-07-20'),
    ('Alice Brown', '777888999', 'alice.brown@example.com', '1995-12-10'),
    ('Charlie Lee', '333444555', 'charlie.lee@example.com', '1988-06-05')
    ;
    
    INSERT INTO class_room (name, total_student, start_date, end_date)
VALUES
    ('Math Class A', 30, '2023-09-01', '2023-12-15'),
    ('English Class B', 25, '2023-09-05', '2023-12-20'),
    ('Science Class C', 20, '2023-09-10', '2023-12-25'),
    ('History Class D', 35, '2023-09-15', '2023-12-30'),
    ('Art Class E', 18, '2023-09-20', '2024-01-05');

INSERT INTO student (name, email, phone, gender, class_room_id, birthday)
VALUES
    ('Student 1', 'student1@example.com', '151222333', 1, 1, '2005-02-14'),
    ('Student 2', 'student2@example.com', '444555666', 2, 2, '2004-07-22'),
    ('Student 3', 'student3@example.com', '777888999', 1, 3, '2003-11-30'),
    ('Student 4', 'student4@example.com', '128456789', 2, 1, '2006-05-18'),
    ('Student 5', 'student5@example.com', '987654321', 1, 2, '2004-09-10'),
    ('Student 6', 'student6@example.com', '555444333', 2, 3, '2005-03-08'),
    ('Student 7', 'student7@example.com', '999888777', 1, 4, '2003-12-15'),
    ('Student 8', 'student8@example.com', '111222333', 2, 5, '2006-01-25'),
    ('Student 9', 'student9@example.com', '666555444', 1, 2, '2004-08-30'),
    ('Student 10', 'student10@example.com', '333222111', 2, 3, '2005-06-20'),
    ('Student 11', 'student11@example.com', '778888999', 1, 4, '2003-10-05'),
    ('Student 12', 'student12@example.com', '449555666', 2, 5, '2006-02-28'),
    ('Student 13', 'student13@example.com', '888999000', 1, 1, '2004-04-12'),
    ('Student 14', 'student14@example.com', '123456789', 2, 3, '2005-07-18'),
    ('Student 15', 'student15@example.com', '999388777', 1, 5, '2006-04-18');

INSERT INTO subject (name)
VALUES
    ('Mathematics'),
    ('English'),
    ('Science');

INSERT INTO mark (student_id, subject_id, score)
VALUES
    (1, 1, 9),
    (2, 2, 8),
    (3, 3, 7),
    (4, 1, 10),
    (5, 2, 8),
    (6, 3, 6),
    (7, 1, 9),
    (8, 2, 7),
    (9, 3, 8),
    (10, 1, 6),
    (11, 2, 9),
    (12, 3, 8),
    (13, 1, 10),
    (14, 2, 7),
    (15, 3, 8),
    (1, 2, 9),
    (2, 3, 7),
    (3, 1, 8),
    (4, 2, 9),
    (5, 3, 8);
    
    
-- 1. Lấy ra danh sách Student có sắp xếp tăng dần theo Name gồm các cột sau: Id,
-- Name, Email, Phone, Address, Gender, BirthDay, Age (5đ)
select * from student order by name ;

-- 2. Lấy ra danh sách Teacher gồm: Id, Name, Phone, Email, BirthDay, Age,
-- TotalCLass (5đ) 
select id, name,phone,email,birthday,(year(now())-year(birthday)) as age from teacher;

-- 3. Truy vấn danh sách class_room gồm: Id, Name, TotalStudent, StartDate,
-- EndDate khai giảng năm 2023 (5đ) 
select * from class_room ;

-- 4. Cập nhật cột ToalStudent trong bảng class_room = Tổng số Student của mỗi
-- class_room theo Id của class_room(5đ) 
update class_room set total_student = (select count(*) from student where student.class_room_id = class_room.id) where class_room.id in (1,2,3,4,5) ;

-- 5. Tạo View v_getStudentInfo thực hiện lấy ra danh sách Student gồm: Id, Name,
-- Email, Phone, Address, Gender, BirthDay, ClassName, MarksAvg, Trong đó cột
-- MarksAvg hiển thị như sau:
-- 0 < MarksAvg <=5 Loại Yếu
-- 5 < MarksAvg < 7.5 Loại Trung bình
-- 7.5 <= MarksAvg <= 8 Loại GIỏi
-- 8 < MarksAvg Loại xuất sắc
-- (5đ) 


create view v_getStudentInfo as
select s.id,s.name,s.email,s.phone,s.gender,s.birthday,cr.name as class_name,avg(m.score) as average_score,
case
	when avg(m.score) > 0 and avg(m.score) <= 5 then 'Loại Yếu'
	when avg(m.score) > 5 and avg(m.score) < 7.5 then 'Loại Trung Bình'
	when avg(m.score) >= 7.5 and avg(m.score) <= 8 then 'Loại Giỏi'
	else 'Loại Xuất Sắc'
end as Loai
from student s
join mark m on m.student_id = s.id
join class_room cr on cr.id = s.class_room_id
group by s.id;

select * from v_getStudentInfo;

-- 6. View v_getStudentMax hiển thị danh sách Sinh viên có điểm trung bình >= 7.5
-- (5đ)
create view v_getStudentMax as 
select * from v_getStudentInfo  where average_score >=7.5;

-- 7. Tạo thủ tục thêm mới dữ liệu vào bảng class_room (5đ)

delimiter //
create procedure add_class_romm(
in name1 varchar(200) ,
in total_student1 int ,
in start_date1 date,
in end_date1 date) 
begin
insert into class_room(name,total_student,start_date,end_date)
values(name1,total_student1,start_date1,end_date1);
end //
delimiter ;

-- 8. Tạo thủ tục cập nhật dữ liệu trên bảng student (5đ)
delimiter //
create procedure edit_student(
in id1 int,
in name1 varchar(150) ,
in email1 varchar(100) ,
in phone1 varchar(50) ,
in gender1 tinyint ,
in class_room_id1 int,
in birthday1 date 
) 
begin
update student set 
name = name1,
email = email1,
phone = phone1,
gender=gender1,
class_room_id=class_room_id1,
birthday=birthday1 
where id = id1;
end //
delimiter ;
 
 -- 9. Tạo thủ tục xóa dữ liệu theo id trên bảng subject (5đ)
 delimiter //
 create procedure delete_subject(in id1 int )
 begin 
	delete from subject where id = id1l;
 end //
 delimiter ;
 
-- 10.Tạo thủ tục getStudentPaginate lấy ra danh sách sinh viên có phân trang gồm:
-- Id, Name, Email, Phone, Address, Gender, BirthDay, ClassName, Khi gọi thủ tuc
-- truyền vào limit và page (15đ) 

delimiter //
create procedure getStudentPaginate(in limit1 int,in offset1 int)
begin 
	select s.id,s.name,s.phone,s.gender,s.birthday , cr.name from student s join class_room cr on cr.id = s.class_room_id limit offset1,limit1;
end //
delimiter ;
call getStudentPaginate(5,1);
