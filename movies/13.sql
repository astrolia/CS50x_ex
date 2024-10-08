SELECT name FROM people
JOIN stars s ON s.person_id = people.id
JOIN movies m ON m.id = s.movie_id
WHERE s.movie_id IN (SELECT movie_id FROM stars
WHERE person_id IN (SELECT id FROM people WHERE name = 'Kevin Bacon' AND birth = 1958))
AND people.name <> 'Kevin Bacon';
