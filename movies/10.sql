SELECT DISTINCT name FROM people
JOIN directors d ON d.person_id = people.id
JOIN ratings r ON r.movie_id = d.movie_id
WHERE r.rating >= 9.0;
