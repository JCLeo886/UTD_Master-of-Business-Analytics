ODS HTML;
ODS LISTING CLOSE;
ODS GRAPHICS ON;
LIBNAME REG 'HW3 Data'; 
DATA video;
set REG.videogamesales_main (encoding=any);
run;
*Question1;
*a;
proc freq data = video;
 Tables Platform Genre Rating;
 run;

*b;
data video2;
set video;
if Platform='DS' then groupDS=1;
else groupDS=0;
if Platform='GBA' then groupGBA=1;
else groupGBA=0;
if Platform='GC' then groupGC=1;
else groupGC=0;
if Platform='PC' then groupPC=1;
else groupPC=0;
if Platform='PS2' then groupPS2=1;
else groupPS2=0;
if Platform='PS3' then groupPS3=1;
else groupPS3=0;
if Platform='PSP' then groupPSP=1;
else groupPSP=0;
if Platform='Wii' then groupWii=1;
else groupWii=0;
if Platform='X360' then groupX360=1;
else groupX360=0;
if Genre='Action' then action=1;
else action=0;
if Genre='Adventure' then adventure=1;
else adventure=0;
if Genre='Fighting' then fighting=1;
else fighting=0;
if Genre='Misc' then genmisc=1;
else genmisc=0;
if Genre='Platform' then genplat=1;
else genplat=0;
if Genre='Puzzle' then puzzle=1;
else puzzle=0;
if Genre='Racing' then racing=1;
else racing=0;
if Genre='Role-Playing' then roleplay=1;
else roleplay=0;
if Genre='Shooter' then shooter=1;
else shooter=0;
if Genre='Simulation' then simulation=1;
else simulation=0;
if Genre='Sports' then sports=1;
else sports=0;
if Rating='E' then groupe=1;
else groupe=0;
if Rating='E10+' then groupe10p=1;
else groupe10p=0;
if Rating='M' then groupm=1;
else groupm=0;
age = 2013-Year_of_Release;
run;

*c; *0.1742;
proc reg data = Video2;
 model Global_sales = Critic_Score Critic_Count User_Score User_Count groupDS
groupGBA groupGC groupPC groupPS2 groupPS3 groupPSP groupWii groupX360
action adventure fighting genmisc genplat puzzle racing roleplay shooter simulation
sports groupe groupe10p groupm age;
Title modelc;
quit;


*d;
data Video3;
 set Video2;
 log_Global_sales = log(Global_sales);
 log_Critic_Score = log(Critic_Score);
 log_Critic_Count = log(Critic_Count);
 log_User_Score = log(User_Score);
 log_User_Count = log(User_Count);
run;


*e; *0.4520;
proc reg data = Video3;
 model log_Global_sales = Critic_Score Critic_Count User_Score User_Count groupDS
groupGBA groupGC groupPC groupPS2 groupPS3 groupPSP groupWii groupX360
action adventure fighting genmisc genplat puzzle racing roleplay shooter simulation
sports groupe groupe10p groupm age;
Title modele;
quit;


*f; *0.5379;
proc reg data = Video3;
 model log_Global_sales = log_Critic_Score log_Critic_Count log_User_Score log_User_Count groupDS
groupGBA groupGC groupPC groupPS2 groupPS3 groupPSP groupWii groupX360
action adventure fighting genmisc genplat puzzle racing roleplay shooter simulation
sports groupe groupe10p groupm age;
 Title modelf;
quit;


*g;
*f has the best adj R squared;

*------------------------------------------------------------------------------;


*Question2;
proc reg data = Video3;
 model log_Global_sales = log_Critic_Score log_Critic_Count log_User_Score log_User_Count groupDS
groupGBA groupGC groupPC groupPS2 groupPS3 groupPSP groupWii groupX360
action adventure fighting genmisc genplat puzzle racing roleplay shooter simulation
sports groupe groupe10p groupm age;
 output out = regdata2 r = sresiduals cookd = Cookd;
 title 'Model2';
quit;
proc print data=regdata2;
 var _ALL_;
 where Cookd > 4/4413;
run;

proc reg data=regdata2;
 model log_Global_sales = log_Critic_Score log_Critic_Count log_User_Score log_User_Count groupDS
groupGBA groupGC groupPC groupPS2 groupPS3 groupPSP groupWii groupX360
action adventure fighting genmisc genplat puzzle racing roleplay shooter simulation
sports groupe groupe10p groupm age;
 where Cookd < 4 /4413;
 title 'Model 2 without influential data';
quit;

proc robustreg data=Video3 method = m;
 model log_Global_sales = log_Critic_Score log_Critic_Count log_User_Score log_User_Count groupDS
groupGBA groupGC groupPC groupPS2 groupPS3 groupPSP groupWii groupX360
action adventure fighting genmisc genplat puzzle racing roleplay shooter simulation
sports groupe groupe10p groupm age;
 output out = robregmm weight = wgt outlier = ol;
 title 'Model 2 Robust';
run;

ODS RTF FILE='Vif.rtf';
proc reg data = Video3;
  model log_Global_sales = log_Critic_Score log_Critic_Count log_User_Score log_User_Count groupDS
groupGBA groupGC groupPC groupPS2 groupPS3 groupPSP groupWii groupX360
action adventure fighting genmisc genplat puzzle racing roleplay shooter simulation
sports groupe groupe10p groupm age / collinoint vif; 
  title 'Model 2 Vif';
run;
ODS RTF CLOSE;

proc reg data=Video3;
model log_Global_sales = log_Critic_Score log_Critic_Count log_User_Score log_User_Count groupDS
groupGBA groupGC groupPC groupPS2 groupPS3 groupPSP groupWii groupX360
action adventure fighting genmisc genplat puzzle racing roleplay shooter simulation
sports groupe groupe10p groupm age / hcc spec;
 title 'Model2 Hetero';
quit;

*Heteroscedasticity add square root;
data Video3_news;
 set Video3;
 sqrt_Global_sales = sqrt(log_Global_sales);
 run;

proc reg data=Video3_news;
model sqrt_Global_sales = log_Critic_Score log_Critic_Count log_User_Score log_User_Count groupDS
groupGBA groupGC groupPC groupPS2 groupPS3 groupPSP groupWii groupX360
action adventure fighting genmisc genplat puzzle racing roleplay shooter simulation
sports groupe groupe10p groupm age / hcc spec;
 title 'Heteroscedasticity add square root';
quit;

proc univariate data=regdata2 normal; 
 var sresiduals; 
 histogram sresiduals / normal kernel;
 title 'Model2 - Normal';
run;

proc univariate data=regdata2 normal;
 var sresiduals; 
 histogram sresiduals / normal kernel;
 where cookd < 4 /4413;
 title 'Model2 - Normal - without outlier';
run;


*---------------------------------------------------------------------------------;


*Question3;
ODS RTF FILE='GLM.rtf';
proc glm data = Video3;
 class Platform Genre Rating;
 model log_Global_sales = log_Critic_Score log_Critic_Count log_User_Score log_User_Count Platform Genre Rating age/solution;
 title 'Model3 - glm';
quit;
ODS RTF CLOSE;
