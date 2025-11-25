-- 1.add new record with first name and second name and email
		INSERT INTO users (first_name, last_name, email)
		VALUES ('Tom', 'Smith', 'tom_smith@email.com');
-- 2.for last added record set id
		UPDATE users
		SET id = 101
		WHERE email = 'tom_smith@email.com';
-- 3.remove users who has no join_date
		DELETE FROM users
		WHERE join_date IS NULL;
-- 4.remove users with join_date smwhere in Jan 2024
		DELETE FROM users
		WHERE join_date >= DATE '2024-01-01'
		AND join_date < DATE '2024-02-01';
-- 5.add new user with join_date = today for new user
		INSERT INTO users (first_name, last_name, email, join_date, yes_no)
		VALUES ('Alice', 'Smith', 'alice_smith@email.com', CURRENT_DATE, false);
-- 6.add new column full_name = first_name + last_name
		ALTER TABLE users
		ADD COLUMN full_name VARCHAR(100);
		
		UPDATE users
		SET full_name = first_name || ' ' || last_name;
-- 7.swap true and false values in yes_no column
		UPDATE users
		SET yes_no = CASE
			WHEN yes_no = 'true' THEN 'false'
			WHEN yes_no = 'false' THEN 'true'
			ELSE yes_no
		END;