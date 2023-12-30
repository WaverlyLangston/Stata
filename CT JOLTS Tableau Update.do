*Import CT State Level JOLTS Data
clear
import delimited "https://download.bls.gov/pub/time.series/jt/jt.data.0.Current"
*thin file to work with
drop if year < 2017
replace series_id = strtrim(series_id)
drop if substr(series_id,3,1) != "S"
drop if substr(series_id,10,2) != "09"

*creating a date field that stata can use to switch file from long to wide
tostring year, generate (yearstr)
generate str month = substr(period,-2,2)
generate timestr = month+"/01/"+yearstr
generate time = date(timestr,"MDY")
drop year period footnote_codes month timestr yearstr
reshape wide value, i(time) j(series_id, string)

*recreate readable time fields
generate year = year(time)
tostring year, replace
generate month = month(time)
tostring month, replace
generate str time2 = month+"/"+year

*rename variables
rename valueJTS000000090000000HIL Hires_Level
rename valueJTS000000090000000HIR Hires_Rate
rename valueJTS000000090000000JOL Job_Openings_Level
rename valueJTS000000090000000JOR Job_Openings_Rate
rename valueJTS000000090000000LDL Layoffs_Discharges_Level
rename valueJTS000000090000000LDR Layoffs_Discharges_Rate
rename valueJTS000000090000000QUL Quits_Level
rename valueJTS000000090000000QUR Quits_Rate
rename valueJTS000000090000000TSL Total_Separations_Level
rename valueJTS000000090000000TSR Total_Separations_Rate
rename valueJTS000000090000000UOR Unemployed_Per_Open_Ratio

*Published in thousands
replace Hires_Level = Hires_Level * 1000
replace Job_Openings_Level = Job_Openings_Level * 1000
replace Layoffs_Discharges_Level = Layoffs_Discharges_Level * 1000
replace Quits_Level = Quits_Level * 1000
replace Total_Separations_Level = Total_Separations_Level * 1000

*prepare rates as percentages
replace Hires_Rate = Hires_Rate / 100
replace Job_Openings_Rate = Job_Openings_Rate / 100
replace Layoffs_Discharges_Rate = Layoffs_Discharges_Rate / 100
replace Quits_Rate = Quits_Rate / 100
replace Total_Separations_Rate = Total_Separations_Rate / 100
replace Unemployed_Per_Open_Ratio = Unemployed_Per_Open_Ratio / 100

*calculate Year over year variables
generate Hires_Level_YOY = (Hires_Level[_n]-Hires_Level[_n-12])/Hires_Level[_n-12]
generate Hires_Rate_YOY = (Hires_Rate[_n]-Hires_Rate[_n-12])/Hires_Rate[_n-12]
generate Job_Openings_Level_YOY = (Job_Openings_Level[_n]-Job_Openings_Level[_n-12])/Job_Openings_Level[_n-12]
generate Job_Openings_Rate_YOY = (Job_Openings_Rate[_n]-Job_Openings_Rate[_n-12])/Job_Openings_Rate[_n-12]
generate Layoffs_Discharges_Level_YOY = (Layoffs_Discharges_Level[_n]-Layoffs_Discharges_Level[_n-12])/Layoffs_Discharges_Level[_n-12]
generate Layoffs_Discharges_Rate_YOY = (Layoffs_Discharges_Rate[_n]-Layoffs_Discharges_Rate[_n-12])/Layoffs_Discharges_Rate[_n-12]
generate Quits_Level_YOY = (Quits_Level[_n]-Quits_Level[_n-12])/Quits_Level[_n-12]
generate Quits_Rate_YOY = (Quits_Rate[_n]-Quits_Rate[_n-12])/Quits_Rate[_n-12]
generate Total_Separations_Level_YOY = (Total_Separations_Level[_n]-Total_Separations_Level[_n-12])/Total_Separations_Level[_n-12]
generate Total_Separations_Rate_YOY = (Total_Separations_Rate[_n]-Total_Separations_Rate[_n-12])/Total_Separations_Rate[_n-12]
generate Unemployed_Per_Open_Ratio_YOY = (Unemployed_Per_Open_Ratio[_n]-Unemployed_Per_Open_Ratio[_n-12])/Unemployed_Per_Open_Ratio[_n-12]

export excel using "Data For Tableau.xlsx", firstrow(variables) sheet(CT_JOLTS, replace)



