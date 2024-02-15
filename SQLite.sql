CREATE TABLE applestore_description_combine AS

SELECT * from appleStore_description1
UNION ALL
SELECT * from appleStore_description2
UNION ALL
SELECT * from appleStore_description3
UNION ALL
SELECT * from appleStore_description4

--- Exploratory Data AnalysisAppleStore

 --check the number of unique apps in both tableappAppleStore

Select count(DISTINCT ID) as uniqueappid
from AppleStore;

Select count(DISTINCT ID) as uniqueappid
from applestore_description_combine;

 --check for any missing values in key fields

SELECT count(*) as missingvalue
from AppleStore
where track_name is NULL or user_rating is NULL or prime_genre is NULL;

select count(*) as missingvalues
from applestore_description_combine
where app_desc is NULL;

 -- Find out the no of apps per genre
 
 SELECT prime_genre, COUNT(*) As numapp
 from AppleStore
 group by prime_genre
 order by numapp DESC;
 
 -- Get an overview of the apps rating
 
 SELECT min(user_rating) as Minrate,
 max(user_rating) as maxrate,
 avg(user_rating) as avgrate
 from AppleStore;
 
 --DATA ANALYSIS
 
 -- Determine whether paid apps have higher rating than free apps
 
 SELECT CASE
          when price > 0 then 'paid'
          else 'free'
          end as app_type,
          avg(user_rating) as avgrating
          from AppleStore
          group by app_type;
 
 
 -- check if apps with more supported languages have higher rating
 
 SELECT CASE
 when lang_num < 10 then '<10 languages'
 when lang_num between 10 and 30 then '10-30 languages'
 else '>30 languages'
 end as language_type,
 avg(user_rating) as avgrate
 from AppleStore
 GROUP by language_type
 order by avgrate desc;
 
 -- check genre with low ratings 
 
 select prime_genre, avg(user_rating) as avgrating
 from AppleStore
 group by prime_genre
 order by avgrating
 limit 10;
 
 -- check if there is correletion between length of app description and user rating

  select CASE
 when length(b.app_desc) < 500 then 'short'
 when length(b.app_desc) between 500 and 1000 then 'Medium'
 else 'High'
 end as description_length,
 avg(A.user_rating) as avgrating 
 from AppleStore as A 
 
 join applestore_description_combine as B 
 on A.id = B.id
 group by description_length
 order by avgrating desc;

 -- check the top rated appps for each genre 
 
 select prime_genre,
        user_rating,
        track_name
   FROM
   (
     SELECT prime_genre,
        user_rating,
        track_name,
     RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
     from 
     AppleStore ) as a 
     where 
     a.rank=1;
 
 
 
 
 
 