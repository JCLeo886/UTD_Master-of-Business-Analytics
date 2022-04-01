/* Homework 1 Pizza dataset*/
/* A,B,C */
proc import datafile="Pizza.csv" out=pizza dbms=csv replace;
    getnames=yes;
run;

title1 ' Basic summary Pizza.csv ';

proc print data=pizza;
run;

proc contents data=pizza;
run;

/* D */
data pizza2;
infile 'Pizza.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
informat SurveyNum best32. ;
informat Arugula best32. ;
informat PineNut best32. ;
informat Squash best32. ;
informat Shrimp best32.  ;
informat Eggplant best32.  ;
format SurveyNum best12. ;
format Arugula best12. ;
format PineNut best12. ;
format Squash best12. ;
format Shrimp best12. ;
format Eggplant best12. ;
input SurveyNum Arugula PineNut Squash Shrimp Eggplant;
run;

proc contents data=pizza2;
run;

/* E */

PROC MEANS Data=pizza2 Mean Noprint nway;
VAR Arugula PineNut Squash Shrimp Eggplant;
OUTPUT out = pizza2_Result (drop= _TYPE_ _FREQ_)
Mean = / autoname; 
run;

PROC PRINT DATA=pizza2_Result;
title1 ' The Average Ratings for Each Topping ';
RUN;
