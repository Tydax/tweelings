/*****************************************
 *                                       *
 *              SQL SCRIPT               *
 *                                       *
 *****************************************/

/*
 * This the script .sql to execute to create the database.
 */


 -- TWEELING
 CREATE TABLE IF NOT EXISTS tweeling (
    `id`            INTEGER PRIMARY KEY,
    `id_twitter`    INTEGER UNIQUE,
    `theme`         VARCHAR(100) NOT NULL,
    `author`        VARCHAR(50) NOT NULL,
    `text`          VARCHAR(170) NOT NULL,
    `cleaned_text`  VARCHAR(250),
    `date`          TEXT NOT NULL,
    `criteria`      VARCHAR(150) NOT NULL,
    `notation`      INTEGER,
    `verified`      INTEGER NOT NULL
);

