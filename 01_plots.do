/*---------------------------------------------------------------------------------------------------
  Gini coefficient of Education

* Author	: Ronny M. Condor (ronny.condor@unmsm.edu.pe)

* Objetive	: Creating the Gini coefficient of education 
*			  for LATAM countries and make a descriptive analysis

* Inputs	: i) Barro & Lee educational attaintment dataset (1950-2010)
*			      ii) Ziesemer, THW (2016) Gini Coefficients of Education for 146 Countries, 1950-2010

* Outputs	: Plots

* Comments	: Outputs used in an inphographics for La Rotonda Blog

---------------------------------------------------------------------------------------------------*/

*Folder structure (based on econresearchR)
global root		= 	"D:\Projects\Educational Gini\03_data"
global raw		=	"$root\01_raw"
global codes	=	"$root\02_codes"
global cleaned	=	"$root\03_cleaned"
global analysis	=	"$root\04_analysis"
global results	=	"$root\05_results"

*------------------------------------------------------------------
*						DATA PREPARATION
*------------------------------------------------------------------

tempfile data1
import excel "$raw\ginipublicexcel.xls", sheet("data1") firstrow case(lower) clear
save `data1'

tempfile data2
import excel "D:\Projects\Educational Gini\03_data\01_raw\ginipublicexcel.xls", sheet("data2") firstrow case(lower) clear
save `data2'

tempfile barrolee
use "$raw\barrolee.dta",clear
rename WBcode wbcode
keep region_code wbcode year
save `barrolee'

import excel "D:\Projects\Educational Gini\03_data\01_raw\ginipublicexcel.xls", sheet("data3") firstrow case(lower) clear
append using `data1'
append using `data2'
drop if year==.

merge 1:1 wbcode year using `barrolee', nogen keep(3)

*------------------------------------------------------------------
*						DATA ANALYSIS & GRAPHS
*------------------------------------------------------------------
set scheme plottig
grstyle init    
grstyle set plain, grid box

encode region_code, gen (region)
codebook region
preserve 
collapse (mean) egini, by (region year)
graph tw (line egini year if region==2) (line egini year if region==3) (line egini year if region==4) (line egini year if region==5) (line egini year if region==6) (line egini year if region==7), xtitle("Año") ytitle("Gini Educacional") legend(label (1 "Asia Oriental y el Pacífico") label (2 "Europa y Asia Central") label (3 "América Latina y el Caribe") label (4 "Oriente Medio y África del Norte") label (5 "Asia del Sur") label (6 "África subsahariana")) xlabel(1950(10)2010) note("Elaboración: @BlogRotonda" "Fuente: Barro-Lee Educational Attainment Dataset")
graph export "$analysis\graph1.png", replace
restore


graph tw (line egini year if wbcode=="PER") (line egini year if wbcode=="CHL") (line egini year if wbcode=="COL") (line egini year if wbcode=="ARG") (line egini year if wbcode=="ECU") (line egini year if wbcode=="BOL"), xtitle("Año") ytitle("Gini Educacional") legend(label (1 "Perú") label (2 "Chile") label (3 "Colombia") label (4 "Argentina") label (5 "Ecuador") label (6 "Bolivia")) xlabel(1950(10)2010) note("Elaboración: @BlogRotonda" "Fuente: Barro-Lee Educational Attainment Dataset")
graph export "$analysis\graph2.png", replace
