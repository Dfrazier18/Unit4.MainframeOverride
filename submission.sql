-- Run the init file
psql -f init.sql

-- Connect to database
\c mainframe_override

-- List all tables connrcted to the DB
\d
/*              List of relations
 Schema |        Name         | Type  | Owner
--------+---------------------+-------+-------
 public | emptystack_accounts | table | dfraz
 public | forum_accounts      | table | dfraz
 public | forum_posts         | table | dfraz
(3 rows)
 */

-- Your first clue: you know that the forum post was made in April 2048, and the author mentioned something about EmptyStack and their dad, who shares the same last name and is also an active participant in the forum.

-- First find forum posts from April 2048
\d forum_posts

/*                        Table "public.forum_posts"
 Column  |              Type              | Collation | Nullable | Default
---------+--------------------------------+-----------+----------+---------
 id      | text                           |           | not null |
 title   | text                           |           | not null |
 content | text                           |           | not null |
 date    | timestamp(3) without time zone |           | not null |
 author  | text                           |           | not null |
Indexes:
 */

SELECT author, content, title, id FROM forum_posts WHERE date BETWEEN '2048-04-01' AND '2048-04-30' AND ( content LIKE '%dad%' AND content LIKE '%EmptyStack%');
/*smart-money-44 | You should all invest in EmptyStack Solutions soon or you'll regret it. My dad works there and he's got some serious inside intel. Their self-driving taxis are the future and the future is here. | Get rich fast | nbZY_ */

-- Find out who smart-money-44 is
\d forum_accounts

/* Table "public.forum_accounts"
   Column   | Type | Collation | Nullable | Default
------------+------+-----------+----------+---------
 username   | text |           | not null |
 first_name | text |           | not null |
 last_name  | text |           | not null | 
 */

 SELECT first_name, last_name FROM forum_accounts WHERE username = 'smart-money-44';
 /*
 first_name | last_name
------------+-----------
 Brad       | Steele 
 */

 -- Find out who Brad's father is
 SELECT username, first_name, last_name FROM forum_accounts WHERE last_name = 'Steele';
 /*
 username     | first_name | last_name
-----------------+------------+-----------
 sharp-engine-57 | Andrew     | Steele
 stinky-tofu-98  | Kevin      | Steele
 smart-money-44  | Brad       | Steele 
 */

 -- Search forum posts for talks about "intel"
 SELECT author, content, title, id FROM forum_posts WHERE author = 'stinky-tofu-98' OR author = 'sharp-engine-57';
 /* 
 author | content | title | id
--------+---------+-------+----
(0 rows) 
*/

-- No forum posts so let's cross reference the name with the emptystack accounts

SELECT * FROM emptystack_accounts WHERE last_name = 'Steele';
/* 
username    |  password   | first_name | last_name
----------------+-------------+------------+-----------
 triple-cart-38 | password456 | Andrew     | Steele
 lance-main-11  | password789 | Lance      | Steele 
 */

 -- Brad's father is Andrew Steele, sharp-engine-57/triple-cart-38
 
 -- Access the mainframe
 \q
 node mainframe.js
 /*
 Username: triple-cart-38
Password: password456
*/

-- Run the new emptystack file?
psql -f emptystack.sql

psql

-- See what's new
\d
/*              List of relations
 Schema |        Name         | Type  | Owner
--------+---------------------+-------+-------
 public | emptystack_accounts | table | dfraz
 public | emptystack_messages | table | dfraz
 public | emptystack_projects | table | dfraz
 public | forum_accounts      | table | dfraz
 public | forum_posts         | table | dfraz
(5 rows) 
*/

-- Find messages about "taxis"?
\d emptystack_messages
/* 
Table "public.emptystack_messages"
 Column  | Type | Collation | Nullable | Default
---------+------+-----------+----------+---------
 id      | text |           | not null |
 from    | text |           | not null |
 to      | text |           | not null |
 subject | text |           | not null |
 body    | text |           | not null | 
 */
SELECT * FROM emptystack_messages WHERE ("from" = 'triple-cart-38' OR "to" = 'triple-cart-38') AND (body ILIKE '%taxi%' OR "subject" ILIKE '%taxi%');
/*
  id   |     from     |       to       |   subject    |                            body
-------+--------------+----------------+--------------+------------------------------------------------------------
 LidWj | your-boss-99 | triple-cart-38 | Project TAXI | Deploy Project TAXI by end of week. We need this out ASAP.
(1 row)
 */

-- Search projects for project taxi
\d emptystack_projects
/* 
 Table "public.emptystack_projects"
 Column | Type | Collation | Nullable | Default
--------+------+-----------+----------+---------
 id     | text |           | not null |
 code   | text |           | not null |
*/
SELECT * FROM emptystack_projects WHERE code ILIKE '%taxi%' OR id ILIKE '%taxi%';
/*
 id    | code
----------+------
 DczE0v2b | TAXI
 */

 -- Find out who the boss is
SELECT * FROM emptystack_accounts WHERE username = 'your-boss-99';
/*
username   |    password    | first_name | last_name
--------------+----------------+------------+-----------
 your-boss-99 | notagaincarter | Skylar     | Singer
(1 row)
 */

-- Stop the project!
\q
node mainframe -stop
/*
WARNING: admin access required. Unauthorized access will be logged.
Username: your-boss-99
Password: notagaincarter
Welcome, your-boss-99.
Project ID: DczE0v2b
Initiating project shutdown sequence...
5...
4...
3...
2...
1...
Project shutdown complete.
 */
 