/*****************************************
 *                                       *
 *              SQL SCRIPT               *
 *                                       *
 *****************************************/

/*
 * This the script .sql to execute to create the database.
 */


 -- RAW_TWEET
 CREATE TABLE tweets (
    `id`            INTEGER PRIMARY KEY,
    `id_twitter`    INTEGER UNIQUE,
    `theme`         VARCHAR(100) NOT NULL,
    `author`        VARCHAR(50) NOT NULL,
    `text`          VARCHAR(170) NOT NULL,
    `cleaned_text`  VARCHAR(250),
    `date`          TEXT NOT NULL,
    `criteria`      VARCHAR(150) NOT NULL,
    `notation`      INTEGER,
    `verified`      NUMERIC NOT NULL
);

