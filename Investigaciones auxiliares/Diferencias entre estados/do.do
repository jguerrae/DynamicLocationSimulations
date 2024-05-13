clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\investigación\survivalp90.dta"

//GRAFICAS
twoway (scatter y x if sname=="Wisconsin", msymbol(Oh) mcolor(yellow))(scatter y x if sname=="Ohio", msymbol(Oh) mcolor(red)) (scatter y x if sname=="Indiana", msymbol(Oh) mcolor(green)) (scatter y x if sname=="Illinois", msymbol(Oh) mcolor(blue))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\investigación\scatter_color.png", as(png) name("Graph") replace

twoway (scatter y x, msymbol(Oh))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\investigación\scatter.png", as(png) name("Graph") replace

twoway (scatter y x if sname=="Wisconsin" & y<=5 & x<=2000, msymbol(Oh) mcolor(yellow) xscale(range(1 2000)) yscale(range(1 5)) title(Wisconsin))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\investigación\scatter_color_W.png", as(png) name("Graph") replace

twoway (scatter y x if sname=="Ohio" & y<=5 & x<=2000, msymbol(Oh) mcolor(red) xscale(range(1 2000)) yscale(range(1 5)) title(Ohio))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\investigación\scatter_color_O.png", as(png) name("Graph") replace

twoway (scatter y x if sname=="Indiana" & y<=5 & x<=2000, msymbol(Oh) mcolor(green) xscale(range(1 2000)) yscale(range(1 5)) title(Indiana))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\investigación\scatter_color_In.png", as(png) name("Graph") replace

twoway (scatter y x if sname=="Illinois" & y<=5 & x<=2000, msymbol(Oh) mcolor(blue) xscale(range(1 2000)) yscale(range(1 5)) title(Illinois))
graph export "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MC experiment\investigación\scatter_color_Il.png", as(png) name("Graph") replace



//REGRESIONES
xtset snumber
gen x2 = x*x
gen D=0
replace D=1 if y>=1


reg y x
xtreg y x, fe

reg y x x2
xtreg y x x2, fe

logit D x
predict Dhat

logit D x x2
predict Dhat2


