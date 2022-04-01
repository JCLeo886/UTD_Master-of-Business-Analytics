/* A*/
data Hotel;
infile 'Hotel.dat';
input Room_No $ 1-4 
      Guest_Num 7-11 
      check_in_month 12-14 
      check_in_day 15-17
      check_in_year 18-25 
      check_out_month 26-28 
      check_out_day 29-32 
      check_out_year 33-40 
      Wifi_use $ 41-47 
      Wifi_day_Num 48-51  
      Room_type $ 52-66
      Room_rate ; 
run;

proc print data=Hotel;
title1 ' Hotel SAS Dataset ';
run;

data report(drop=check_in_month check_in_day check_in_year check_out_month check_out_day check_out_year);
 set Hotel;
 CheckIn = cats(check_in_month,'/',check_in_day,'/',check_in_year);
 CheckOut = cats(check_out_month,'/',check_out_day,'/',check_out_year);
run;

proc print data= report;
run;

/* B*/
data Hotel2 (drop = CheckIn CheckOut);
   set report;
   Check_In_Date= input(CheckIn,anydtdte32.);
   Check_out_Date= input(CheckOut,anydtdte32.);
   Format Check_In_Date mmddyy10.;
   Format Check_out_Date mmddyy10.;
run;

proc print data= Hotel2;
run;

proc contents data= Hotel2;
run;

/* C*/
data Hotel3;
   set Hotel2;
   Days_in_stay = Check_out_Date-Check_In_Date;
   if Guest_Num = 1 then do ;
   Person_rate = 0;
   end;
   else do;
   Person_rate = ((Guest_Num-1)*10*Days_in_stay);
   end;

   if Wifi_use = 'NO' then do;
   Wifi_service_fee = 0;
   end;
   else do;
   Wifi_service_fee = 9.95+4.95*Wifi_day_Num;
   end;
run;

proc print data= Hotel3;
run;

/* D*/
data Hotel4;
   set Hotel3;
   Grand_total = (Person_rate+Wifi_service_fee)*1.0775;
run;

proc print data= Hotel4; 
run;

data Hotel_f;
set Hotel4;
    Grand_total = round(Grand_total,0.01);
run;

/* E*/
proc print data= Hotel_f; run;
