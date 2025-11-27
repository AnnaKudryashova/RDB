--1.add gender_group with values - male, female, others (use CASE) and show first_name, last_name, gender_group
	SELECT
	  first_name,
	  last_name,
	  CASE
	    WHEN gender ILIKE 'male' THEN 'male'
	    WHEN gender ILIKE 'female' THEN 'female'
	    ELSE 'others'
	  END AS gender_group
	FROM userinfo;
	
--2.count how many people in each gender_group
	SELECT
	  CASE
	    WHEN gender ILIKE 'male' THEN 'male'
	    WHEN gender ILIKE 'female' THEN 'female'
	    ELSE 'others'
	  END AS gender_group,
	  COUNT(*) AS people_count
	FROM userinfo
	GROUP BY gender_group;

--3.show number of female, male, others by country in next way:
--country    female   male   others
--latvia        2       1       0

	SELECT country,
	  COUNT(CASE WHEN gender ILIKE 'female' THEN 1 END) AS female,
	  COUNT(CASE WHEN gender ILIKE 'male'   THEN 1 END) AS male,
	  COUNT(CASE WHEN gender NOT ILIKE 'female' 
	  		AND gender NOT ILIKE 'male' THEN 1 END) AS others
	FROM userinfo
	GROUP BY country
	ORDER BY country;
	

	