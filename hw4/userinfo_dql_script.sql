--show first_name, last_name from Latvia
	SELECT first_name, last_name, country
	FROM userinfo
	WHERE country = 'Latvia';
	
--show first_name, last_name from Latvia and Poland
	SELECT first_name, last_name, country
	FROM userinfo
	WHERE country IN ('Latvia', 'Poland');
	
--show first_name, last_name from Latvia and Poland, China
	SELECT first_name, last_name, country
	FROM userinfo
	WHERE country IN ('Latvia', 'Poland', 'China');
	
--show unique countries - 1/2 solution
	SELECT DISTINCT country
	FROM userinfo;
	
--show unique countries - 2/2 solution
	SELECT country
	FROM userinfo
	GROUP BY country;
	
--show countries and genders and number of people
	SELECT country, gender, COUNT(*) AS people_count
	FROM userinfo
	GROUP BY country, gender
	ORDER BY country;
	
--show countries and number of different genders in it
	SELECT country, COUNT(DISTINCT gender) AS gender_count
	FROM userinfo
	GROUP BY country;
	
--show countries with more than 5 users
	SELECT country, COUNT(*) AS user_count
	FROM userinfo
	GROUP BY country
	HAVING COUNT(*) > 5
	ORDER BY country;
	
--show all users with google email
	SELECT *
	FROM userinfo
	WHERE email LIKE '%google%';