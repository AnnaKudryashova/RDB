drop table if exists Teacher_Course_Faculty;
drop table if exists Student_Grade;
drop table if exists Student_Unit;
drop table if exists Unit;
drop table if exists Student;
drop table if exists Course;
drop table if exists Teacher;
drop table if exists Faculty;

create table Faculty(
        faculty_id serial primary key,
        faculty_name text
);

create table Course(
        course_id serial primary key,
        course_name text 
);

create table Teacher(
        teacher_id serial primary key,
        last_name text not null,
        first_name text not null,
        birthday date,
        curator_id int,

        constraint fk_teacher_teacher
                foreign key (curator_id)
                references Teacher(teacher_id)
);

create table Student(
        student_id serial primary key,
        student_number text not null,
        last_name text not null,
        first_name text not null,
        gender int not null,
        birthday date
);

create table Unit(
        unit_id serial primary key,
        unit_number text,
        faculty_id int not null,
        
        constraint fk_unit_faculty
                foreign key (faculty_id)
                references Faculty(faculty_id)
);

create table Student_Unit(
        student_unit_id serial primary key,
        unit_id int not null,
        student_id int not null,
        is_head boolean not null,
        
        constraint fk_student_student_unit 
                foreign key (unit_id)
                references Unit(unit_id),

        constraint fk_student_unit_student
                foreign key (student_id)
                references Student(student_id)
);

create table Teacher_Course_Faculty(
        teacher_course_faculty_id serial primary key,
        teacher_id int not null,
        course_id int not null,
        faculty_id int not null,        
        duration numeric(8,2),
        
        constraint fk_teacher_course_faculty_teacher
                foreign key (teacher_id)
                references Teacher(teacher_id),

        constraint fk_teacher_course_faculty_course 
                foreign key (course_id)
                references Course(course_id),

        constraint fk_teacher_course_faculty_faculty 
                foreign key (faculty_id)
                references Faculty(faculty_id)
);

create table Student_grade(
        student_grade_id serial primary key,
        student_id int not null,
        course_id int not null,
        grade int not null,       
        
        constraint fk_student_grade_student
                foreign key (student_id)
                references Student(student_id),

        constraint fk_student_grade_course
                foreign key (course_id)
                references Course(course_id)
);

insert into Faculty
	(faculty_name) 
values	
	('Mathematical'),
	('Physical'),
	('Economic');

insert into Course
	(course_name) 
values	
	('Algebra'),
	('Geometry'),
	('Higher Mathematics'),
	('Optics'),
	('History'),
	('Probability Theory'),
	('Economic Theory');

insert into Teacher
	(last_name, first_name, birthday, curator_id)
values	
	('Petrov', 'Ivan', '19640413', null),
	('Nikitin', 'Sergey', '19610623', null),
	('Ivanov', 'Oleg', '19451001', null),
	('Nosov', 'Maksim', '19721225', 2),
	('Alexeev', 'Alexey', '19690312', null),
	('Danilov', 'Alexandr', '19790422', 1),
	('Sidorov', 'Denis', '19750502', 1),
	('Laptev', 'Andrey', '19710719', null),
	('Steklov', 'Nikita', '19500820', 2),
	('Olenev', 'Igor', '19401025', 3);
        
insert into Student
	(student_number, last_name, first_name, gender, birthday)
values	
	('12', 'Taranov', 'Maksim', 1, '20041212'),
	('23', 'Zhukov', 'Andrey', 1, '20041023'),
	('45', 'Sharapova', 'Anna', 0, '20010107'),
	('67', 'Vlasova', 'Svetlana', 0, '20010308'),
	('89', 'Aliev', 'Iskander', 1, '20010427'),
	('234', 'Kuznetsov', 'Pavel', 1, '20000502'),
	('567', 'Kuznetsova', 'Alla', 0, '20000507'),
	('28', 'Mironov', 'Andrey', 1, '20000528'),
	('13', 'Golubeva', 'Polina', 0, '20000507'),
	('93', 'Orlov', 'Andrey', 1, '20000917'),
	('123', 'Tolstoy', 'Stas', 1, '20040606'),
	('654', 'Ivanov', 'Sergey', 1, '20001207'),
	('987', 'Sidorova', 'Anastasia', 0, '19991124');
        
insert into Unit
	(unit_number, faculty_id) 
values
	('13', 1),
	('14', 1),
	('13', 2),
	('13', 3),
	('15', 2);
        
insert into Student_Unit
	(unit_id, student_id, is_head) 
values
	(1, 1, true),
	(1, 2, false),
	(1, 3, false),
	(2, 4, true),
	(2, 5, false),
	(2, 6, false),
	(2, 7, false),
	(3, 8, true),
	(3, 9, false),
	(4, 10, true),
	(4, 11, false),
	(4, 12, false),
	(5, 13, true);
            
        
insert into Student_grade
	(student_id, course_id, grade) 
values
	(1, 1, 5),
	(1, 2, 4),
	(1, 3, 4),
	(1, 4, 3),
	(1, 7, 5),
	(2, 1, 4),
	(2, 3, 5),
	(2, 6, 3),
	(2, 7, 5),
	(3, 2, 4),
	(3, 3, 4),
	(3, 5, 3),
	(3, 6, 4),
	(4, 1, 5),
	(4, 6, 4),
	(5, 7, 5),
	(5, 4, 4),
	(6, 2, 3),
	(6, 3, 5),
	(6, 7, 4),
	(7, 3, 4),
	(7, 7, 5),
	(7, 4, 4),
	(8, 1, 3),
	(8, 2, 5),
	(8, 7, 4),
	(8, 3, 5),
	(9, 2, 4),
	(10, 1, 4),
	(10, 2, 3),
	(10, 3, 4),
	(10, 6, 3),
	(12, 3, 4);

insert into Teacher_Course_Faculty
	(teacher_id, course_id, faculty_id, duration)
values
	(1, 1, 1, 80),
	(1, 2, 1, 56),
	(1, 3, 2, 90),
	(2, 6, 1, 40),
	(3, 4, 2, 32),           
	(4, 7, 3, 202),
	(5, 3, 1, 86),
	(5, 3, 3, 62),   
	(7, 4, 2, 34),          
	(7, 6, 2, 24),                
	(8, 2, 3, 26),
	(9, 1, 1, 88),   
	(9, 3, 3, 74),       
	(9, 6, 3, 62);     