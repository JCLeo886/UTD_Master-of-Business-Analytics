/*Question 1*/
libname ClsData "E:\Users\dxa190004\Desktop\Sas Assignment files";
ods html;
ods listing close;
ods graphics on;

data Crackers;
set ClsData.Crackers;
run;

proc surveyselect data = Crackers out = Crackers_sampled outall samprate = 0.75 seed = 23;
run;
/*Question 3*/
data crackers_choice (keep=selected obs cracker choice price display feature);
array chosen[4] Sunshine Keebler Nabisco Private;
array prices[4] PriceSunshine PriceKeebler PriceNabisco PricePrivate;
array displays[4] DisplSunshine DisplKeebler DisplNabisco DisplPrivate;
array features[4] FeatSunshine FeatKeebler FeatNabisco FeatPrivate;
array allbrands[4] $ _temporary_ ('Sunshine' 'Keebler' 'Nabisco' 'Private');
set Crackers_sampled;
obs = _n_;
do i = 1 to 4;
Cracker = allbrands[i];
Price = prices[i];
Display = displays[i];
Feature = features[i];
Choice = chosen[i];
output;
end;
run;
/*Question 4*/
data Crackers_training Crackers_test;
set crackers_choice;
if selected then output crackers_training;
else output crackers_test;
run;

proc logistic data = Crackers_training;
strata obs;
class cracker (ref = 'Private') / param = ref;
model choice (event = '1') = cracker price display feature cracker*display cracker*feature / clodds = wald orpvalue;
run;

/*Question 5*/
proc mdc data = Crackers_training;
id obs;
class cracker;
model choice = cracker price display feature cracker*display cracker*feature / type = clogit nchoice = 4;
restrict crackerprivate = 0;
restrict crackerprivatedisplay = 0;
restrict crackerprivatefeature = 0;
run;
/*Question 6*/
data cracker_6;
set crackers_choice;
if selected = 0 then choice =.;
run;

proc mdc data = cracker_6;
id obs;
class cracker;
model choice = cracker price display feature cracker*display cracker*feature / type = mprobit nchoice = 4;
restrict crackerprivate = 0;
restrict crackerprivatedisplay = 0;
restrict crackerprivatefeature = 0;
output out = cracker_prediction pred = p;
run;
