ODS HTML;
ODS LISTING CLOSE;
ODS GRAPHICS ON;

LIBNAME data 'HW4 Data'; 

*Question1;
data Heinz;
set data.heinzhunts(encoding=any);
run;

data Heinz2;
 set Heinz;
 LogPriceRatio = log (PriceHeinz/PriceHunts);
 IntHienz = DisplHeinz * FeatHeinz;
 IntHunts = DisplHunts * FeatHunts;
run;

*Question2;
proc surveyselect data=Heinz2 out=Heinz2_sampled outall samprate=0.8 seed=10;
run;

data Heinz2_training Heinz2_test;
 set Heinz2_sampled;
 if selected then output Heinz2_training; 
 else output Heinz2_test;
run;


*Question3;

*For Heinz;
ODS RTF FILE='logit.rtf';
proc logistic data=Heinz2_sampled;
 logit: model Heinz (event='1') = LogPriceRatio DisplHeinz FeatHeinz DisplHunts FeatHunts IntHienz IntHunts / clodds=wald orpvalue; 
 *'clodds=wald orpvalue' generates p-values for Odds Ratios';
 weight selected; /*only training sample is used for estimation, since selected = 0 for test sample */
 title 'Logit';
run;
ODS RTF CLOSE;



*Question4;
*interpret;


*Question5;
*calaulation;



*Question6 0.0523178601;
proc logistic data=Heinz2_training outmodel=Logitmodel;
 logit: model Heinz (event='1') = LogPriceRatio DisplHeinz FeatHeinz DisplHunts FeatHunts IntHienz IntHunts;
 weight selected;
 title 'Step 1';
run;

proc logistic inmodel=Logitmodel;
 score data=Heinz2_test outroc=Heinz2_logit_roc;
 title 'Step 2';
run;

data roc;
set Heinz2_logit_roc;
TotalCost = _FALPOS_ * 0.25 + _FALNEG_ * 1;
run;
