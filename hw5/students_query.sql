-- 1. Select the last name, date of birth, and student ID (student_number field) for male students. 
-- Sort the result by date of birth in ascending order, with the oldest student appearing first.

SELECT last_name, birthday, student_number
FROM student
WHERE gender = 1
ORDER BY birthday ASC;

-- 2. Write a query that returns teachers who have curators. 
-- The result should contain one field, teacher_name, which consists of the teacher's last name 
-- and first name separated by a space.

-- 1 solution
SELECT last_name || ' ' || first_name AS teacher_name
FROM teacher
WHERE curator_id IS NOT NULL;

-- 2 solution
SELECT CONCAT_WS(' ', last_name, first_name) AS teacher_name
FROM teacher
WHERE curator_id IS NOT NULL;

-- 3. Write a query that returns teachers who are either over 65 years old 
-- or whose last name starts with the letter 'S'.

-- 1 solution
SELECT last_name, first_name, birthday, extract(year from birthday)
FROM teacher
WHERE extract(year from current_date) - extract(year from birthday) > 65
	OR last_name LIKE 'S%';

-- 2 solution
SELECT CONCAT(last_name, ' ', first_name) AS teacher_name, extract(year from birthday)
FROM teacher
WHERE birthday < CURRENT_DATE - INTERVAL '65 years'
	OR last_name LIKE 'S%';
	
-- 4. Write a query that selects the last name, first name, and group number of each student.

SELECT s.last_name, s.first_name, u.unit_number
FROM student s
JOIN student_unit su ON su.student_id = s.student_id
JOIN unit u ON u.unit_id = su.unit_id;

-- 5. Write a query that returns the last names of all teachers. 
-- If a teacher has a curator, also display the curator's last name.

-- 1 solution
SELECT
  t.last_name       AS teacher_last_name,
  c.last_name       AS curator_last_name
FROM teacher t
LEFT JOIN teacher c
  	ON t.curator_id = c.teacher_id;

-- 2 solution
SELECT t.teacher_id, t.last_name,
	(SELECT c.last_name FROM teacher as c where t.curator_id = c.teacher_id)
FROM teacher as t

-- 6. Select the group number and last name of the head of each group.

-- 1 solution
SELECT
  u.unit_number,
  s.last_name
FROM student_unit su
JOIN student s ON su.student_id = s.student_id
JOIN unit u ON su.unit_id = u.unit_id
WHERE su.is_head = TRUE;

-- 2 solution
SELECT s.last_name, s.first_name, u.unit_number
FROM student s
JOIN student_unit su ON su.student_id = s.student_id
JOIN unit u ON u.unit_id = su.unit_id
WHERE is_head = TRUE;

-- 7. Write a query that returns the last names of teachers 
-- who teach both Algebra and Higher Mathematics.

SELECT DISTINCT tc.teacher_id, teacher.last_name, course.course_name FROM teacher_course_faculty as tc
JOIN teacher ON teacher.teacher_id = tc.teacher_id
JOIN course ON course.course_id = tc.course_id
WHERE course_name IN ('Algebra', 'Higher Mathematics')

-- 8. Select teachers who give lectures on more than one faculty.

SELECT teacher.last_name "teacher's last name", COUNT(faculty_id) as "faculty quantity" 
FROM teacher_course_faculty as tc
JOIN teacher ON teacher.teacher_id = tc.teacher_id
GROUP BY teacher.last_name
HAVING COUNT(faculty_id) > 1

-- 9. Write a query that returns the last name of the student, the names of the courses taught at his/her faculty, 
-- and the student's grade for each course, if the student took the exam. 
-- If the student did not take the exam, display null instead of the grade. 
-- Consider that a student may take an exam for a course not taught at his/her faculty, and one course at the faculty may be taught by different teachers.

SELECT 
	s.student_id "student's id", 
	last_name "student's last name", 
	f.faculty_name "faculty name", 
	c.course_id "course id", 
	course_name "course name", 
	grade
FROM student s
JOIN student_unit su ON su.student_id = s.student_id
JOIN unit u ON u.unit_id = su.unit_id
JOIN faculty f ON f.faculty_id = u.faculty_id
LEFT JOIN student_grade sg ON sg.student_id = s.student_id
LEFT JOIN course c ON c.course_id = sg.course_id

-- 10. Write a query that returns the name of the faculty and the average duration of courses taught at that faculty.

SELECT 
    f.faculty_name "faculty name",
    ROUND(AVG(tcf.duration), 2) as "average duration"
FROM Faculty f
JOIN Teacher_Course_Faculty tcf ON f.faculty_id = tcf.faculty_id
GROUP BY f.faculty_id
ORDER BY f.faculty_name;

SELECT 
	f.faculty_id "faculty id", 
	f.faculty_name "faculty name", 
	ROUND(AVG(duration), 2) as "average duration"
FROM teacher_course_faculty tcf
JOIN faculty f ON f.faculty_id = tcf.faculty_id
GROUP BY f.faculty_id 
ORDER BY f.faculty_id

-- 11. Write a query that returns the last name, first name, and average grade based on exam results for students 
-- with an average grade greater than or equal to 4. Sort the result in descending order of the average grade and then by the last name of the student.

SELECT 
    s.last_name "last name",
    s.first_name "first name",
    ROUND(AVG(sg.grade), 2) as "average grade"
FROM student_grade sg
JOIN student s ON s.student_id = sg.student_id
GROUP BY s.student_id
HAVING AVG(sg.grade) >= 4
ORDER BY "average grade" DESC, s.last_name;

-- 12. Select the last names of teachers who teach courses with a total duration of more than 200 hours.

-- solution 1
SELECT 
	t.teacher_id "teacher's id", 
	t.last_name "teacher's last name", 
	SUM(duration) "total duration"
FROM teacher_course_faculty tcf
JOIN teacher t ON t.teacher_id = tcf.teacher_id
GROUP BY t.teacher_id
HAVING SUM(duration) > 200
ORDER BY t.teacher_id

-- solution 2
SELECT
	t.teacher_id "teacher's id",
	t.last_name "teacher's last name"
FROM teacher t
WHERE (
    SELECT SUM(duration)
    FROM teacher_course_faculty tcf
    WHERE tcf.teacher_id = t.teacher_id
) > 200
ORDER BY t.last_name;

-- 13. Display a list of faculties, and for each faculty, show the name of the course with the shortest duration.

SELECT 
    f.faculty_name "faculty name",
    c.course_name "course name",
    tcf.duration "shortest duration"
FROM faculty f
JOIN teacher_course_faculty tcf ON f.faculty_id = tcf.faculty_id
JOIN course c ON tcf.course_id = c.course_id
WHERE tcf.duration = (
    SELECT MIN(tcf2.duration)
    FROM teacher_course_faculty tcf2
    WHERE tcf2.faculty_id = f.faculty_id
)
ORDER BY f.faculty_name;

-- 14. Select the last names of students who performed better on the Algebra exam than on the Geometry exam.

SELECT s.last_name "student's last name"
FROM student s
WHERE (
    SELECT sg.grade 
    FROM student_grade sg
    JOIN course c ON sg.course_id = c.course_id
    WHERE sg.student_id = s.student_id 
      AND c.course_name = 'Algebra'
) > (
    SELECT sg.grade 
    FROM student_grade sg
    JOIN course c ON sg.course_id = c.course_id
    WHERE sg.student_id = s.student_id 
      AND c.course_name = 'Geometry'
);

-- 15.Write a query that returns the name of the course and the name of the faculty for courses taught only on one faculty and not on others.

SELECT DISTINCT
  c.course_id "course id",
  c.course_name "course name",
  f.faculty_id "faculty id",
  f.faculty_name "faculty name"
FROM course c
JOIN teacher_course_faculty tcf ON c.course_id = tcf.course_id
JOIN faculty f ON tcf.faculty_id = f.faculty_id
WHERE c.course_id IN (
    SELECT course_id
    FROM teacher_course_faculty
    GROUP BY course_id
    HAVING COUNT(DISTINCT faculty_id) = 1
);