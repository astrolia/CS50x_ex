SELECT name FROM people
JOIN stars ON stars.person_id = people.id
WHERE stars.movie_id IN (SELECT DISTINCT id FROM movies WHERE year = 2004) ORDER BY birth;
