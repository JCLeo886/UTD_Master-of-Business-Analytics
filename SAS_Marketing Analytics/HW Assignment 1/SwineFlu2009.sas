data SwineFlu2009;
infile 'SwineFlu2009.dat';
input FirstCase_ID 1-4 
      ContinentCase_ID 13-17 
      Country $27-60 
      First_Case_Date yymmdd10.  
      Apr_Cases 79-88 
      May_Cases 89-98 
      Jun_Cases 99-108 
      Jul_Cases 108-118 
      Aug_Cases 119-128 
      Case_Cum 129-144 
      FirstDeath_ID 145-154 
      ContinentDeath_ID 155-168 
      First_Death_Date yymmdd10. 
      May_Deaths 194-203 
      Jun_Deaths 204-213 
      Jul_Deaths 214-223 
      Aug_Deaths 224-233 
      Sep_Deaths 234-243 
      Oct_Deaths 244-255 
      Nov_Deaths 256-264 
      Dec_Deaths ;  

format First_Case_Date yymmdd10.; 
format First_Death_Date yymmdd10.;
run;

proc print data=SwineFlu2009;
run;

DATA  SwineFlu2009;
   SET SwineFlu2009;
   LABEL  FirstCase_ID  ="ID for sorting by first case date"
          ContinentCase_ID ="X represents continent and YY represents the YYth country with the next 1st case"
		  Country ="Country"
		  First_Case_Date ="Date of first case reported"
		  Apr_Cases ="Number of cumulative cases reported on the first day of April"
		  May_Cases ="Number of cumulative cases reported on the first day of May"
		  Jun_Cases ="Number of cumulative cases reported on the first day of June"
		  Jul_Cases ="Number of cumulative cases reported on the first day of July"
		  Aug_Cases ="Number of cumulative cases reported on the first day og August"
		  Case_Cum ="Last reported cumulative number of cases reported to WHO as of August 9, 2009"
		  FirstDeath_ID ="ID for sorting by first death date"
		  ContinentDeath_ID ="X represents continent and YY represents the YYth country with the next 1st death"
		  First_Death_Date ="Date of first death"
		  May_Deaths ="Number of cumulative deaths reported on the first day of May"
		  Jun_Deaths ="Number of cumulative deaths reported on the first day of June"
		  Jul_Deaths ="Number of cumulative deaths reported on the first day of July"
		  Aug_Deaths ="Number of cumulative deaths reported on the first day of August"
		  Sep_Deaths ="Number of cumulative deaths reported on the first day of September"
		  Oct_Deaths ="Number of cumulative deaths reported on the first day of October"
		  Nov_Deaths ="Number of cumulative deaths reported on the first day of November"
		  Dec_Deaths ="Number of cumulative deaths reported on the first day of December";
RUN;
proc contents data=SwineFlu2009;
run;
