create database netflix;
use deepak;
select * from deepak;
select count(*) as total_content from deepak; 
-- 15 bussines problems
-- 1. count the numbers of movies vs tv show 
SELECT type, COUNT(*) AS total_content
FROM deepak
GROUP BY type;
-- 2.find the most common for movies and tv shows
SELECT type, rating, total
FROM (
    SELECT
        type,
        rating,
        COUNT(*) AS total,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM deepak
    GROUP BY type, rating
) AS t1
WHERE ranking = 1;
-- 3.list all movies relesed in a specific year (e.g. , 2020)
 -- filter 2020
 -- movies 
 select * from deepak
 where type = "movie" and release_year = 2020;
 -- 4. find the top 5 countries with the most content on netflix 
 select country, count(show_id) as total_content from deepak group by 1;
 SELECT TRIM(new_country) AS country,
    COUNT(*) AS total_content
FROM (SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country FROM deepak
) AS countries
GROUP BY TRIM(new_country)
ORDER BY total_content DESC
LIMIT 5; 

-- 5.identify the longest movie 
SELECT *
FROM deepak
WHERE type = 'Movie'
AND duration = (
    SELECT MAX(duration)
    FROM deepak
    WHERE type = 'Movie'
);

-- 6.find content added in the last 5 years
SELECT *
FROM deepak
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
select CURRENT_DATE - INTERVAL '5 years';

-- 7. find all the movies/tv shows by director 'rajiv chilaka'
SELECT *
FROM deepak
WHERE LOWER(director) LIKE '%rajiv chilaka%';


-- 8. list all tv shows with more than 5 seasons
SELECT *, SPLIT_PART(duration, ' ', 1): INT AS session
FROM deepak
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
  select split_part('apple banana cherry',' ',1);

-- 9. count the number of content items in each genre
select unnest(string_to_array(listed_in,',')) as genre,
count(show_id) as total_content from deepak group by 1;


-- 10. Find the average release year for content produced in a specific country
SELECT AVG(release_year) AS avg_release_year
FROM netflix
WHERE country = 'India';
-- 11. List all movies that are documentaries
SELECT *
FROM netflix
WHERE type = 'Movie'
  AND listed_in LIKE '%Documentaries%';

-- 12. Find all content without a director
select * from deepak where director is null;
--  13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from deepak
where cast like '%salman khan%' and release_year > extract(year from current_date) - 10;


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select show_id,
casts,
unnest(string_to_array(cast,',')) as actors,
count(*) as total_content from deepak group by 1;

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in
-- the description field. Label content containing these keywords as 'Bad' and all other 
 -- content as 'Good'. Count how many items fall into each category.
 SELECT
    CASE
        WHEN description LIKE '%kill%' 
          OR description LIKE '%violence%' 
        THEN 'Bad'
        ELSE 'Good'
    END AS category,
    COUNT(*) AS total_content
FROM deepak
GROUP BY 1;
 