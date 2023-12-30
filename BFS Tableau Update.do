*Import Census BFS monthly data
clear
import delimited "https://www.census.gov/econ/bfs/csv/bfs_monthly.csv"

*only keeping seasonally adjusted, All Naics (industry not available at state level), total apps and high propensity apps,
drop if sa == "U"
drop sa
drop if naics_sector != "TOTAL"
drop naics_sector
keep if series == "BA_BA" | series == "BA_HBA"


*rename for reshaping time to long
rename jan valuejan
rename feb valuefeb
rename mar valuemar
rename apr valueapr
rename may valuemay
rename jun valuejun
rename jul valuejul
rename aug valueaug
rename sep valuesep
rename oct valueoct
rename nov valuenov
rename dec valuedec

reshape long value, i(year series geo) j(month) string

generate monthint = month(date("2000"+month+"1","YMD"))
tostring monthint, replace
tostring year, replace
generate period = date(year + monthint, "YM")
generate time = monthint + "/" + year

*create label for reshaping values to long
generate label = geo+"_"+series
drop series geo

reshape wide value, i(period) j(label) string
order time, after(period)

rename value* *

*make numeric
destring AK_BA_BA AK_BA_HBA AL_BA_BA AL_BA_HBA AR_BA_BA AR_BA_HBA AZ_BA_BA AZ_BA_HBA CA_BA_BA CA_BA_HBA CO_BA_BA CO_BA_HBA CT_BA_BA CT_BA_HBA DC_BA_BA DC_BA_HBA DE_BA_BA DE_BA_HBA FL_BA_BA FL_BA_HBA GA_BA_BA GA_BA_HBA HI_BA_BA HI_BA_HBA IA_BA_BA IA_BA_HBA ID_BA_BA ID_BA_HBA IL_BA_BA IL_BA_HBA IN_BA_BA IN_BA_HBA KS_BA_BA KS_BA_HBA KY_BA_BA KY_BA_HBA LA_BA_BA LA_BA_HBA MA_BA_BA MA_BA_HBA MD_BA_BA MD_BA_HBA ME_BA_BA ME_BA_HBA MI_BA_BA MI_BA_HBA MN_BA_BA MN_BA_HBA MO_BA_BA MO_BA_HBA MS_BA_BA MS_BA_HBA MT_BA_BA MT_BA_HBA MW_BA_BA MW_BA_HBA NC_BA_BA NC_BA_HBA ND_BA_BA ND_BA_HBA NE_BA_BA NE_BA_HBA NH_BA_BA NH_BA_HBA NJ_BA_BA NJ_BA_HBA NM_BA_BA NM_BA_HBA NO_BA_BA NO_BA_HBA NV_BA_BA NV_BA_HBA NY_BA_BA NY_BA_HBA OH_BA_BA OH_BA_HBA OK_BA_BA OK_BA_HBA OR_BA_BA OR_BA_HBA PA_BA_BA PA_BA_HBA RI_BA_BA RI_BA_HBA SC_BA_BA SC_BA_HBA SD_BA_BA SD_BA_HBA SO_BA_BA SO_BA_HBA TN_BA_BA TN_BA_HBA TX_BA_BA TX_BA_HBA US_BA_BA US_BA_HBA UT_BA_BA UT_BA_HBA VA_BA_BA VA_BA_HBA VT_BA_BA VT_BA_HBA WA_BA_BA WA_BA_HBA WE_BA_BA WE_BA_HBA WI_BA_BA WI_BA_HBA WV_BA_BA WV_BA_HBA WY_BA_BA WY_BA_HBA, replace

*create YOY for each
foreach var of varlist AK_BA_BA AK_BA_HBA AL_BA_BA AL_BA_HBA AR_BA_BA AR_BA_HBA AZ_BA_BA AZ_BA_HBA CA_BA_BA CA_BA_HBA CO_BA_BA CO_BA_HBA CT_BA_BA CT_BA_HBA DC_BA_BA DC_BA_HBA DE_BA_BA DE_BA_HBA FL_BA_BA FL_BA_HBA GA_BA_BA GA_BA_HBA HI_BA_BA HI_BA_HBA IA_BA_BA IA_BA_HBA ID_BA_BA ID_BA_HBA IL_BA_BA IL_BA_HBA IN_BA_BA IN_BA_HBA KS_BA_BA KS_BA_HBA KY_BA_BA KY_BA_HBA LA_BA_BA LA_BA_HBA MA_BA_BA MA_BA_HBA MD_BA_BA MD_BA_HBA ME_BA_BA ME_BA_HBA MI_BA_BA MI_BA_HBA MN_BA_BA MN_BA_HBA MO_BA_BA MO_BA_HBA MS_BA_BA MS_BA_HBA MT_BA_BA MT_BA_HBA MW_BA_BA MW_BA_HBA NC_BA_BA NC_BA_HBA ND_BA_BA ND_BA_HBA NE_BA_BA NE_BA_HBA NH_BA_BA NH_BA_HBA NJ_BA_BA NJ_BA_HBA NM_BA_BA NM_BA_HBA NO_BA_BA NO_BA_HBA NV_BA_BA NV_BA_HBA NY_BA_BA NY_BA_HBA OH_BA_BA OH_BA_HBA OK_BA_BA OK_BA_HBA OR_BA_BA OR_BA_HBA PA_BA_BA PA_BA_HBA RI_BA_BA RI_BA_HBA SC_BA_BA SC_BA_HBA SD_BA_BA SD_BA_HBA SO_BA_BA SO_BA_HBA TN_BA_BA TN_BA_HBA TX_BA_BA TX_BA_HBA US_BA_BA US_BA_HBA UT_BA_BA UT_BA_HBA VA_BA_BA VA_BA_HBA VT_BA_BA VT_BA_HBA WA_BA_BA WA_BA_HBA WE_BA_BA WE_BA_HBA WI_BA_BA WI_BA_HBA WV_BA_BA WV_BA_HBA WY_BA_BA WY_BA_HBA {
	generate YOY_`var' = (`var'[_n] - `var'[_n-12]) / `var'[_n-12]
}

drop if CT_BA_BA == .
 
export excel using "Data For Tableau.xlsx", firstrow(variables) sheet(Biz_Form_All, replace)










