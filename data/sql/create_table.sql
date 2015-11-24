/*****************************************
 *                                       *
 *              SQL SCRIPT               *
 *                                       *
 *****************************************/

/*
 * This the script .sql to execute to create the database.
 */


 -- RAW_TWEET
 CREATE TABLE raw_tweet (
    `id`            INTEGER PRIMARY KEY,
    `id_twitter`    INTEGER,
    `theme`         VARCHAR(100),
    `author`        VARCHAR(50),
    `text`          VARCHAR(170),
    `date`          TEXT,
    `criteria`      VARCHAR(150),
    `notation`      INTEGER
);