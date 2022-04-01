LIBNAME HW 'HW2';

data earthquakes;
 set HW.earthquakes;
run; 

PROC SQL;
CREATE TABLE Earthquake2State AS
SELECT *
FROM earthquakes
WHERE State = 'Alaska' or State = 'California';
QUIT;

PROC SQL;
CREATE TABLE Earthquake2State_1 AS
SELECT *
FROM Earthquake2State
WHERE Year > 2001;
QUIT;

* Question 1 (a) and (b);
proc tabulate data= Earthquake2State_1 ;
 class State Year; *categorical variables for breakdown of variable summaries;
 var Magnitude Month Day; *variables described by the table; 
 table Year*State*(Magnitude),N Mean Median StdDev Min Max p25 p75 Max; 
 title 'Statistics for the Magnitude of Earthquake';
run;

*Question 1(c);
proc sort data=Earthquake2State_1;;
 by Year;
run;

proc tabulate data= Earthquake2State_1 ;
 by Year;
 class State Year; *categorical variables for breakdown of variable summaries;
 var Magnitude Month Day; *variables described by the table; 
 table Year*State*(Magnitude),N Mean Median StdDev Min Max p25 p75 Max; 
 title 'Statistics for the Magnitude of Earthquake by Year';
run;

*Question 1(d);
proc tabulate data= Earthquake2State_1 ;
 class State Year; *categorical variables for breakdown of variable summaries;
 var Magnitude Month Day; *variables described by the table; 
 table Year*(Magnitude),State*(N Mean Median StdDev Min Max p25 p75 Max); 
 title 'Statistics for the Magnitude of Earthquake';
run;

*Question 1(e);

proc means data= Earthquake2State mean maxdec= 2;
 class State Year;
 var Magnitude;
 output out=M_means 
  		mean= AvgMagnitude;
run;

proc sgpanel  data= M_means;
 panelby State;
 series x=Year y=AvgMagnitude;
 title 'The trend of average magnitude of earthquakes over time for the two states';
run;

*Question 1(f);
*Test the following null hypothesis: “the average magnitude of earthquakes in California is equal to that of Alaska.”;

proc ttest data=Earthquake2State; 	*two-sided test as default;
 class State;
 var Magnitude;
 title 'Hypothesis Test';
run;

*Question 2(a);
data study_gpa;
 set HW.study_gpa;
run; 

*proc contents data=study_gpa;
*run;

proc sgplot data= study_gpa;
 histogram AveTime / binstart = 0 binwidth = 5 ; 
 density AveTime;               		* Just Normal distribution;
 density AveTime / type = kernel;		* Kernel smoothing of histogram;
 title 'Histogram for Hours of Study';
run;
*Question 2(b);

proc corr data=study_gpa;
 var AveTime Units GPA;
 title 'Correlation Table of "AveTime" "Units" "GPA"';
run;

proc ttest data=study_gpa; 	*two-sided test as default;
 paired AveTime*Units;  *paired;
 title 'Hypothesis Test between AveTime*Units';
run;

proc ttest data=study_gpa; 	*two-sided test as default;
 paired AveTime*GPA;  *paired;
 title 'Hypothesis Test between AveTime*GPA';
run;

proc ttest data=study_gpa; 	*two-sided test as default;
 paired GPA*Units;  *paired;
 title 'Hypothesis Test between GPA*Units';
run;

*Question 3(a)
Treatment 0=baseline, 1=first year, and 2=second year. 
Strata    1=baseline plaque 0.60mm+ and 2=baseline plaque below 0.60mm
visit     0=placebo and 1=vitamin E
treatment = treatmen;


data vite;
 set HW.vite;
run; 

proc contents data=vite;
run;

*Question 3(c);

PROC SQL;
CREATE TABLE vite_V02 AS
SELECT *
FROM vite
WHERE Visit = 0 or Visit = 2;
QUIT;

PROC SQL;
CREATE TABLE vite_V02noT0 AS
SELECT *
FROM vite_V02
WHERE treatmen = 1;
QUIT;
proc sort data=vite_V02noT0; 
by ID;
run;
proc transpose data=vite_V02noT0 out=wide1 prefix=plaque;
    by ID;
    id Visit;
    var plaque;
run;

ods graphics on;
proc ttest data=wide1;
 paired plaque0*plaque2;;
 title 'hypothesis Visit0_T1 and Visit2_T1';
run;
ods graphics off;


*Question 3(d);
PROC SQL;
CREATE TABLE vite_V02noT1 AS
SELECT *
FROM vite_V02
WHERE treatmen = 0;
QUIT;
proc sort data=vite_V02noT1; 
by ID;
run;
proc transpose data=vite_V02noT1 out=wide2 prefix=plaque;
    by ID;
    id Visit;
    var plaque;
run;

ods graphics on;
proc ttest data=wide2;
 paired plaque0*plaque2;;
 title 'Hypothesis Visit0_T0 and Visit2_T0';
run;
ods graphics off;

*Question 3(f);

* random select 250 obeservation from vita data;
PROC SQL;
CREATE TABLE T0_Alco_S AS
SELECT treatmen,alcohol as T0_alc, Smoke as T0_Smo
FROM vite_v02
Where treatmen = 0;
QUIT;

data T0_Alco_S;
 set T0_Alco_S;
	IDNew=_n_;
run;

PROC SQL;
CREATE TABLE T1_Alco_S AS
SELECT treatmen, alcohol as T1_alc, Smoke as T1_Smo
FROM vite_v02
Where treatmen = 1;
QUIT;

data T1_Alco_S;
 set T1_Alco_S;
	IDNew=_n_;
run;

data concatenation;
 merge T1_Alco_S T0_Alco_S;
 by IDnew;
 run;

proc ttest data=concatenation;
 paired T0_alc*T1_alc;
 title 'Hypothesis test on Alcohol';
run;

proc ttest data=concatenation;
 paired T0_Smo*T1_Smo;
 title 'Hypothesis test on Smoke';
run;
