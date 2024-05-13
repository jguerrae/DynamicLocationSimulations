//CÓDIGO PARA PRODUCIR DATASETS DE 100000 OBS EN FUNCIÓN DEL SHARE


//NESTAB
clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4 - repaso Jorge (feb 2022)\interpolation\shares_VF"

keep nestab_d cfips year
gen n_esc = .

replace n_esc = 100000
gen nnestab = round(n_esc*nestab_d)
expand nnestab
egen cfipsid = group(cfips)
bysort year: gen cfipsfirmsid=_n



foreach x of numlist 1985 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 ///
					1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 /// 
{
	preserve
	keep if year ==  `x'
	save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4 - repaso Jorge (feb 2022)\nestab\MC\MCY_`x'", replace
	restore
}



//KS

clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4 - repaso Jorge (feb 2022)\interpolation\shares_VF"

keep  ks_d cfips year
gen n_esc = .

replace n_esc = 100000
gen nks = round(n_esc* ks_d)
expand nks
egen cfipsid = group(cfips)
bysort year: gen cfipsfirmsid=_n


foreach x of numlist 1895 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 ///
					1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 /// 
{
	preserve
	keep if year ==  `x'
	save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4 - repaso Jorge (feb 2022)\ks\MC\MCY_`x'", replace
	restore
}



//MKT

clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4 - repaso Jorge (feb 2022)\interpolation\shares_VF"

keep  mkt_d cfips year
gen n_esc = .

replace n_esc = 100000
gen nmkt = round(n_esc* mkt_d)
expand nmkt
egen cfipsid = group(cfips)
bysort year: gen cfipsfirmsid=_n


foreach x of numlist 1895 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 ///
					1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 /// 
{
	preserve
	keep if year ==  `x'
	save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4 - repaso Jorge (feb 2022)\mkt\MC\MCY_`x'", replace
	restore
}


//FMKT

clear all
use "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4 - repaso Jorge (feb 2022)\interpolation\shares_VF"

keep  fmkt_d cfips year
gen n_esc = .

replace n_esc = 100000
gen nfmkt = round(n_esc* fmkt_d)
expand nfmkt
egen cfipsid = group(cfips)
bysort year: gen cfipsfirmsid=_n


foreach x of numlist 1895 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 ///
					1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 /// 
{
	preserve
	keep if year ==  `x'
	save "D:\CLOUD\Universidad de los Andes\Xavier Hernando Duran Amorocho - Jorge Guerra\MCs\MC_v4 - repaso Jorge (feb 2022)\fmkt\MC\MCY_`x'", replace
	restore
}


