USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
-- Count total number of rows in each table.
SELECT 
    COUNT(*) as count_rows 
FROM
    director_mapping;
    
  SELECT 
    COUNT(*) as count_rows 
FROM
    genre;  

SELECT 
    COUNT(*)
FROM
    movie;
SELECT 
    COUNT(*)
FROM
    names;
SELECT 
    COUNT(*)
FROM
    ratings;
SELECT 
    COUNT(*)
FROM
    role_mapping;




-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- The column name worlwide_gross_income has highest number of null values 3724.
SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS id_nulls,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS title_nulls,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS year_nulls,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS date_published_nulls,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS duration_nulls,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS country_nulls,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS worlwide_gross_income_nulls,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS languages_nulls,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS production_company_nulls
FROM
    movie;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- NUMBER OF MOVIES
-- The highest number of movies is related  year 2017 .
SELECT 
    year, COUNT(*) AS number_of_movies
FROM
    movie
WHERE
    year IS NOT NULL
GROUP BY year
ORDER BY number_of_movies desc;

-- Month wise number of movies 
-- The highest number of movies is produced in the month of March.
SELECT 
    MONTH(date_published) AS month_num,
    COUNT(*) AS number_of_movies
FROM
    movie
WHERE
    date_published IS NOT NULL
GROUP BY month_num
ORDER BY number_of_movies desc;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- In India 295 movies are produced and in USA 592 movies are produced in year 2019
SELECT 

    country, COUNT(*) AS num_of_movies_in_2019
FROM
    movie
WHERE
    country IN ('USA' , 'INDIA')
        AND year = 2019
GROUP BY country;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- Unique list of all genres 
SELECT DISTINCT
    genre
FROM
    genre
WHERE
    genre IS NOT NULL;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- Drama had the highest number ( 4285 ) of movies produced overall.
SELECT 
    genre.genre, COUNT(movie.id) AS count_movies
FROM
    genre
        JOIN
    movie ON genre.movie_id = movie.id
    where genre.genre is not null
GROUP BY genre.genre
ORDER BY count_movies DESC
LIMIT 1;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- There are 3289 movies which has only one genre associated with them.
SELECT COUNT(*) AS movies_with_one_genre
FROM (
    SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(genre) = 1
) AS single_genre_movies;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- The Horror genre has lowest average duration 92.72 and the Action genre has hightest average duration 112.88 
SELECT 
    genre.genre, ROUND(AVG(movie.duration), 2) AS avg_duration
FROM
    genre
        JOIN
    movie ON movie.id = genre.movie_id
GROUP BY genre.genre
ORDER BY avg_duration;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- The Thriller genre has rank 3 
SELECT *
FROM (
    SELECT 
        genre.genre, 
        COUNT(movie.id) AS movie_count,
        RANK() OVER (ORDER BY COUNT(movie.id) DESC) AS genre_rank
    FROM genre
    JOIN movie ON movie.id = genre.movie_id
    GROUP BY genre.genre
) AS ranked_genres
WHERE genre = 'Thriller';

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- MIN and MAX of avg_rating,total_votes and median_rating 
SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

-- Kirket movie has average rating 10 and 1 and the fun movie has average rating 9.6 and has rank 5
SELECT title, avg_rating, movie_rank
FROM (
    SELECT 
        movie.title, 
        ratings.avg_rating, 
        RANK() OVER (ORDER BY ratings.avg_rating DESC) AS movie_rank
    FROM movie 
    JOIN ratings ON movie.id = ratings.movie_id
) AS ranked_movies
WHERE movie_rank <= 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
 
-- Median rating 7 has the highest count (2257 movies).
--  Median rating 1 has the lowest count (94 movies).

SELECT 
    ratings.median_rating, COUNT(movie.id) AS movie_count
FROM
    ratings
        JOIN
    movie ON ratings.movie_id = movie.id
GROUP BY ratings.median_rating
ORDER BY median_rating;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:alter

-- Dream Warrior Pictures or National Theatre Live or both are in rank 1 and movie count is 3.
SELECT 
    movie.production_company,
    COUNT(movie.id) AS movie_count,
    dense_rank() OVER (ORDER BY COUNT(movie.id) DESC) AS prod_company_rank
FROM movie
JOIN ratings ON movie.id = ratings.movie_id
WHERE ratings.avg_rating > 8
AND movie.production_company IS NOT NULL
GROUP BY movie.production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both 

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Drama has highest movie count 16 and Family genre has lowest 1 in March 2017 and votes is more then 1000.
SELECT 
    genre.genre, COUNT(movie.id) AS movie_count
FROM
    genre
        JOIN
    movie ON genre.movie_id = movie.id
        JOIN
    ratings USING (movie_id)
WHERE
    YEAR(date_published) = 2017
        AND MONTH(date_published) = 3
        AND country IN ('usa')
        AND total_votes > 1000
GROUP BY genre.genre;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- The Brighton Miracle movie has highest average rating 9.5 
select movie.title,ratings.avg_rating,genre.genre from movie join ratings on movie.id = ratings.movie_id
join genre on movie.id=genre.movie_id
where movie.title like 'The %' and ratings.avg_rating > 8
order by avg_rating desc;


-- Here i am trying Top movies by  median rating where median_rating is >= 10 and total votes > 10000 on my hand there is only  promise movie

SELECT 
    movie.title,
    ratings.median_rating,
    ratings.total_votes
FROM movie
JOIN ratings ON movie.id = ratings.movie_id
WHERE median_rating >= 10 and total_votes > 100000
ORDER BY total_votes DESC;
-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?

-- Type your code below:

-- there are 361 movies which is relesed in between 1 apr 2018 and 1 apr 2019 and median rating is 8
SELECT COUNT(movie.id) as count
FROM movie 
JOIN ratings ON movie.id = ratings.movie_id 
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01' 
  AND ratings.median_rating = 8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
-- Greman movies has 4695 total votes and italian has only 1684
SELECT 
    movie.languages, ratings.total_votes
FROM
    movie
        JOIN
    ratings ON movie.id = ratings.movie_id
WHERE
    movie.languages IN ('german' , 'italian')
GROUP BY movie.languages;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
-- name column as 0 null values and hight has 17335 null values as highest in all columns 
SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Get top 3 genres with the most movies having avg_rating > 8
WITH top_genres AS (
    SELECT genre, COUNT(*) AS movie_count
    FROM genre
    JOIN ratings ON genre.movie_id = ratings.movie_id
    WHERE ratings.avg_rating > 8
    GROUP BY genre
    ORDER BY movie_count DESC
    LIMIT 3
),

--  Get top 3 directors in those genres
top_directors AS (
    SELECT 
        names.name AS director_name,
        COUNT(DISTINCT director_mapping.movie_id) AS movie_count
    FROM director_mapping
    JOIN names ON director_mapping.name_id = names.id
    JOIN ratings ON director_mapping.movie_id = ratings.movie_id
    JOIN genre ON director_mapping.movie_id = genre.movie_id
    WHERE ratings.avg_rating > 8
      AND genre.genre IN (SELECT genre FROM top_genres)
    GROUP BY names.name
    ORDER BY movie_count DESC
    LIMIT 3
)
-- Final output
SELECT * FROM top_directors;




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Actor name Mammootty  has 8 movies and Mohanlal has 5 
SELECT 
    names.name AS actor_name,
    COUNT(*) AS movie_count
FROM names
JOIN role_mapping ON names.id = role_mapping.name_id
JOIN ratings ON ratings.movie_id = role_mapping.movie_id
WHERE ratings.median_rating >= 8
  AND role_mapping.category = 'actor'
GROUP BY names.name
ORDER BY movie_count DESC
LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/


-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- Marvel Studios has rank 1 and vote count is 2656967 and Marvel Studios rules the movie world.
SELECT 
    movie.production_company, 
    SUM(ratings.total_votes) AS vote_count, 
    RANK() OVER (ORDER BY SUM(ratings.total_votes) DESC) AS prod_comp_rank
FROM movie 
JOIN ratings ON movie.id = ratings.movie_id
WHERE movie.production_company IS NOT NULL
GROUP BY movie.production_company
LIMIT 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top actor is Vijay Sethupathi has total votes 23114,movies 5,average rating 8.42 and rank 1 
WITH indian_actor_movies AS (
    SELECT 
        n.name AS actor_name,
        r.avg_rating,
        r.total_votes,
        rm.name_id,
        m.id AS movie_id
    FROM names n
    JOIN role_mapping rm ON n.id = rm.name_id
    JOIN movie m ON rm.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
    WHERE rm.category = 'actor'
      AND m.country = 'India'
),

actor_stats AS (
    SELECT 
        actor_name,
        COUNT(movie_id) AS movie_count,
        SUM(total_votes) AS total_votes,
        SUM(avg_rating * total_votes) / SUM(total_votes) AS actor_avg_rating
    FROM indian_actor_movies
    GROUP BY actor_name
    HAVING COUNT(movie_id) >= 5
)

SELECT 
    actor_name,
    total_votes,
    movie_count,
    ROUND(actor_avg_rating, 2) AS actor_avg_rating,
    RANK() OVER (
        ORDER BY actor_avg_rating DESC, total_votes DESC
    ) AS actor_rank
FROM actor_stats;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Taapsee Pannu tops with average rating 7.74,total votes 18061 movies 3 and has rank 1. 

WITH hindi_actress_movies AS (
    SELECT 
        n.name AS actress_name,
        r.avg_rating,
        r.total_votes,
        rm.name_id,
        m.id AS movie_id
    FROM names n
    JOIN role_mapping rm ON n.id = rm.name_id
    JOIN movie m ON rm.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
    WHERE rm.category = 'actress'
      AND m.country = 'India'
      AND m.languages LIKE '%Hindi%'
),

actress_stats AS (
    SELECT 
        actress_name,
        COUNT(movie_id) AS movie_count,
        SUM(total_votes) AS total_votes,
        SUM(avg_rating * total_votes) / SUM(total_votes) AS actress_avg_rating
    FROM hindi_actress_movies
    GROUP BY actress_name
    HAVING COUNT(movie_id) >= 3
)

SELECT 
    actress_name,
    total_votes,
    movie_count,
    ROUND(actress_avg_rating, 2) AS actress_avg_rating,
    RANK() OVER (
        ORDER BY actress_avg_rating DESC, total_votes DESC
    ) AS actress_rank
FROM actress_stats
LIMIT 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:
-- Joker , Andhadhun,ah-ga-ssi and Contratiempo are superhit movies 
SELECT 
    movie.title AS movie_name,
    CASE 
        WHEN ratings.avg_rating > 8 THEN 'Superhit'
        WHEN ratings.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN ratings.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        ELSE 'Flop'
    END AS movie_category
FROM movie
JOIN ratings ON movie.id = ratings.movie_id
JOIN genre ON movie.id = genre.movie_id
WHERE genre.genre = 'Thriller'
  AND ratings.total_votes >= 25000
ORDER BY ratings.avg_rating DESC;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
-- Action genre has same average duaration ,running total duration and moving average duration 112.88.
SELECT 
    genre.genre,
    ROUND(AVG(movie.duration), 2) AS avg_duration,
    ROUND(SUM(AVG(movie.duration)) OVER (ORDER BY genre.genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS running_total_duration,
    ROUND(AVG(AVG(movie.duration)) OVER (ORDER BY genre.genre ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
FROM genre
JOIN movie ON genre.movie_id = movie.id
WHERE movie.duration IS NOT NULL
GROUP BY genre.genre
ORDER BY genre.genre;

-- Round is good to have and not a must have; Same thing applies to sorting
-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Top 3 Genres based on most number of movies
-- Comedy ,Drama and Thriller are top three genere based on most number of movies .
WITH top_genres AS (
    SELECT genre.genre
    FROM genre
    GROUP BY genre.genre
    ORDER BY COUNT(genre.movie_id) DESC
    LIMIT 3
),

movies_with_income AS (
    SELECT 
        genre.genre,
        EXTRACT(YEAR FROM movie.date_published) AS year,
        movie.title AS movie_name,
        CAST(REPLACE(REPLACE(movie.worlwide_gross_income, '$', ''), ',', '') AS UNSIGNED) AS gross_income
    FROM genre
    JOIN movie ON genre.movie_id = movie.id
    WHERE genre.genre IN (SELECT genre FROM top_genres)
      AND movie.worlwide_gross_income IS NOT NULL
),

ranked_movies AS (
    SELECT 
        genre,
        year,
        movie_name,
        gross_income,
        RANK() OVER (PARTITION BY genre, year ORDER BY gross_income DESC) AS movie_rank
    FROM movies_with_income
)

SELECT * 
FROM ranked_movies
WHERE movie_rank <= 5
ORDER BY genre, year, movie_rank;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
-- Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits among multilingual movies .

SELECT 
    movie.production_company,
    COUNT(movie.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(movie.id) DESC) AS prod_comp_rank
FROM movie
JOIN ratings ON movie.id = ratings.movie_id
WHERE ratings.median_rating >= 8
  AND POSITION(',' IN movie.languages) > 0  -- checks for multilingual movies (comma implies more than one language)
  AND movie.production_company IS NOT NULL
GROUP BY movie.production_company
LIMIT 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

-- Sangeetha Bhat ,Adriana Matoshi and Fatmire Sahiti are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre.
WITH superhit_drama_movies AS (
    SELECT 
        m.id AS movie_id,
        r.avg_rating,
        r.total_votes
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    JOIN genre g ON m.id = g.movie_id
    WHERE r.avg_rating > 8
      AND g.genre = 'Drama'
),

actress_data AS (
    SELECT 
        n.name AS actress_name,
        COUNT(DISTINCT s.movie_id) AS movie_count,
        SUM(r.total_votes) AS total_votes,
        ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 4) AS actress_avg_rating
    FROM names n
    JOIN role_mapping rm ON n.id = rm.name_id
    JOIN superhit_drama_movies s ON rm.movie_id = s.movie_id
    JOIN ratings r ON s.movie_id = r.movie_id
    WHERE rm.category = 'actress'         -- assuming this identifies female actors
    GROUP BY n.name
)

SELECT 
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    RANK() OVER (
        ORDER BY actress_avg_rating DESC, total_votes DESC, actress_name ASC
    ) AS actress_rank
FROM actress_data
ORDER BY actress_rank
LIMIT 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
-- details for top 9 directors (based on number of movies)

WITH director_movies AS (
    SELECT 
        dm.name_id AS director_id,
        n.name AS director_name,
        m.id AS movie_id,
        m.date_published,
        m.duration,
        r.avg_rating,
        r.total_votes
    FROM director_mapping dm
    JOIN names n ON dm.name_id = n.id
    JOIN movie m ON dm.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
    WHERE m.date_published IS NOT NULL
),

-- Count movies per director and get top 9
top_directors AS (
    SELECT director_id
    FROM director_movies
    GROUP BY director_id
    ORDER BY COUNT(movie_id) DESC
    LIMIT 9
),

-- Compute inter-movie durations using LEAD()
movie_gaps AS (
    SELECT 
        dm.director_id,
        dm.director_name,
        dm.movie_id,
        dm.date_published,
        LEAD(dm.date_published) OVER (PARTITION BY dm.director_id ORDER BY dm.date_published) AS next_movie_date
    FROM director_movies dm
    WHERE dm.director_id IN (SELECT director_id FROM top_directors)
),

inter_movie_days AS (
    SELECT 
        director_id,
        AVG(DATEDIFF(next_movie_date, date_published)) AS avg_inter_movie_days
    FROM movie_gaps
    WHERE next_movie_date IS NOT NULL
    GROUP BY director_id
),

-- Aggregate movie stats per director
director_stats AS (
    SELECT 
        dm.director_id,
        dm.director_name,
        COUNT(dm.movie_id) AS number_of_movies,
        ROUND(AVG(dm.avg_rating), 2) AS avg_rating,
        SUM(dm.total_votes) AS total_votes,
        MIN(dm.avg_rating) AS min_rating,
        MAX(dm.avg_rating) AS max_rating,
        SUM(dm.duration) AS total_duration
    FROM director_movies dm
    WHERE dm.director_id IN (SELECT director_id FROM top_directors)
    GROUP BY dm.director_id, dm.director_name
)

-- Final output combining all
SELECT 
    ds.director_id,
    ds.director_name,
    ds.number_of_movies,
    ROUND(COALESCE(imd.avg_inter_movie_days, 0), 0) AS avg_inter_movie_days,
    ds.avg_rating,
    ds.total_votes,
    ds.min_rating,
    ds.max_rating,
    ds.total_duration
FROM director_stats ds
LEFT JOIN inter_movie_days imd ON ds.director_id = imd.director_id
ORDER BY ds.number_of_movies DESC;
