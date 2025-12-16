1. --Add information about a new teacher to the database and indicate that Nikitin is their curator.
INSERT INTO Teacher (last_name, first_name, curator_id)
VALUES ('X', 'Y', (select teacher_id from teacher where last_name = 'Nikitin'));

2.-- Add data that the new teacher from the first task gives a course on Algebra at the Mathematical faculty for 100 hours.


3. --Increase the duration of the "Probability Theory" course by 1.5 times.

4. --Change the unit head in the unit 14 from Svetlana Vlasova to Pavel Kuznetsov.

5. --Delete information about the teacher with the last name Petrov from the database (you need to delete information from all tables that refer to the record containing information about the teacher).

6. --Increase the grade in higher mathematics by 1 point for all students of the Economic faculty.

7. --Ensure that any course is taught by no more than two teachers on a faculty. If a course is taught by more than two teachers, leave the courses with shorter durations.


/*
1. Add information about a new teacher to the database 
and indicate that Nikitin is their curator. 
*/

select * from teacher 
where last_name = 'Nikitin'
--1 insert names, update curator
--2 insert with query or subquery (scalar)
 
insert into teacher (last_name, first_name, curator_id)
values ('x', 'y', (select teacher_id from teacher where last_name = 'Nikitin'))
 
insert into teacher (last_name, first_name, curator_id) 
select 'x1', 'y1', teacher_id
from teacher
where last_name = 'Nikitin'

/*
2. Add data that the new teacher from the first task 
gives a course on Algebra at the Mathematical faculty for 100 hours.
*/
 
insert into teacher_course_faculty(teacher_id, course_id, faculty_id, duration)
values
(
	(select teacher_id from teacher where last_name = 'x'),--teacher_id
	(select course_id from course where course_name = 'Algebra'),--course_id
	(select faculty_id from faculty where faculty_name = 'Mathematical'),--faculty_id
	100
)

select * from teacher_course_faculty
select teacher_course_faculty_id, last_name, teacher.teacher_id, course_name, faculty_name, duration from teacher_course_faculty
join teacher using(teacher_id)
join course using (course_id)
join faculty using (faculty_id)

delete from teacher_course_faculty where teacher_course_faculty_id > 16
 
--incorrect
insert into teacher_course_faculty(teacher_id, course_id, faculty_id, duration)
select teacher_id, course_id, faculty_id, 96
from teacher_course_faculty tcf
inner join teacher t
  using (teacher_id)
inner join course c
  using (course_id)
inner join faculty f
  using(faculty_id)
where last_name = 'x'
  and course_name = 'Algebra'
  and faculty_name = 'Mathematical'

-- this query works the same as incorrect one above (for me)
insert into teacher_course_faculty(teacher_id, course_id, faculty_id, duration)
select teacher_id, course_id, faculty_id, 98
from teacher t, course c, faculty f
where last_name = 'x'
  and course_name = 'Algebra'
  and faculty_name = 'Mathematical'
returning teacher_course_faculty_id;
 
/*
3. Increase the duration of the "Probability Theory" course by 1.5 times.
*/
 
select * from course
select * from teacher_course_faculty 
where course_id = 6
 
update teacher_course_faculty as tcf
set duration = duration * 1.5
from course as c
where tcf.course_id = c.course_id
  and course_name = 'Probability Theory'
returning teacher_course_faculty_id
 
/*
4. Change the unit head in the unit 14 from Svetlana Vlasova to Pavel Kuznetsov.
*/
 
select * from student where last_name = 'Vlasova' or last_name = 'Kuznetsov'
select * from student_unit
select * from unit
 
update student_unit as su
set is_head = not is_head
from student as s, unit as u
where su.unit_id = u.unit_id
  and su.student_id = s.student_id
  and unit_number = '14'
  and (last_name = 'Vlasova' or last_name = 'Kuznetsov')
returning student_unit_id
 
select *
from student as s, unit as u, student_unit as su
where su.unit_id = u.unit_id
  and su.student_id = s.student_id
  and unit_number = '14'
  and (last_name = 'Vlasova' or last_name = 'Kuznetsov')
 
select s.last_name, u.unit_number, su.is_head
from student as s
join student_unit as su
on s.student_id = su.student_id
join unit as u
on su.unit_id = u.unit_id
 
 
yes_no = swap values
-- third value
 
/*
5. Delete information about the teacher with the last name Petrov 
from the database 
(you need to delete information from all tables 
that refer to the record containing information about the teacher).
*/
 
update teacher
set curator_id = NULL
where curator_id = (select teacher_id from teacher where last_name = 'Petrov')
returning teacher_id
 
delete from teacher_course_faculty
where teacher_id = (select teacher_id from teacher where last_name = 'Petrov')
 
delete from teacher_course_faculty as tcf
using teacher as t
where tcf.teacher_id = t.teacher_id and last_name = 'Petrov'
returning teacher_course_faculty_id
 
select *
from teacher as t, teacher_course_faculty as tcf
where tcf.teacher_id = t.teacher_id and last_name = 'Petrov'
 
delete from teacher
where last_name = 'Petrov'
 
/*
6. Increase the grade in higher mathematics by 1 point 
for all students of the Economic faculty.
if 5 - then remains 5
*/
 
select distinct grade
from public.student_grade

-- DML to increase grade in Higher Math, if it is not already 5 for Economic faculty students
update student_grade sg
set grade = grade + 1
where sg.grade < 5
  and sg.course_id = (
        select course_id
        from course
        where course_name = 'Higher Mathematics'
      )
  and sg.student_id in (
        select su.student_id
        from student_unit su
        join unit u on u.unit_id = su.unit_id
        join faculty f on f.faculty_id = u.faculty_id
        where f.faculty_name = 'Economic'
      );
 
/*
7. Ensure that any course is taught by no more than two teachers 
on a faculty. If a course is taught by more than two teachers, 
leave the courses with shorter durations.
*/
 
select * from teacher_course_faculty
order by faculty_id, course_id

-- DML to delete record where course is taught by more than 1 teacher on the faculty and is not of the shortest duration
delete from teacher_course_faculty tcf
where (tcf.course_id, tcf.faculty_id, tcf.duration) not in (
    select
      course_id,
      faculty_id,
      min(duration)
    from teacher_course_faculty
    group by course_id, faculty_id
);