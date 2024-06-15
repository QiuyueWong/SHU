**# Bookmark #1
use "C:\Users\戴尔\Pictures\衍生品\volitility data.dta"
rename (var1 var2 var3 var4 var5 var6 var7 var8)(year realized c p implied RI CP ER)
sum realized c p implied RI CP ER
//reg ER realized c p
//reg ER realized c p,r

//分位点
//1.-pctile- 命令
sysuse auto, clear
pctile p_price = price, nq(10)//nq(#)指定分9个百分位数,把样本切割为10组
list p_price in 1/12, sep(0)

***五分位点
***realized volatility 五分位点
pctile RealizedVol = realized, nq(6)
list RealizedVol in 1/6, sep(0)
drop RealizedVol
drop Reavolatility
drop CallImVol 
drop PutImVol

***call implied volatility五分位点
pctile CallImVol = c, nq(6)
list CallImVol in 1/6, sep(0)

***put implied volatility五分位点
pctile PutImVol = p, nq(6)
list PutImVol in 1/6, sep(0)


2. -xtile- 命令 // 根据指定的百分位数定义类别变量，例如把25%定义为1,50%定义为2等等。

xtile RealizedVol = realized, nq(5)
list, sepby(x_bp)​
xtile CallImVol = c, nq(6)

//xtile x_Regcap2=Regcap2,nq(5)
//tab x_Regcap2
drop ReaVol
drop  q_ReaVol
drop  fq_ReaVol
drop  q_CallImVol
drop  fq_CallImVol
drop  q_PutImVol
drop  fq_PutImVol


xtile ReaVol = realized,nq(6)
tab ReaVol

quantiles ReaVol,gen(q_ReaVol) nq(6)
tab q_ReaVol
//bysort Indcd year:quantiles Regcap2,gen(fq_Regcap2) nq(3)
//tab fq_Regcap2
bysort c p implied RI CP ER:quantiles ReaVol,gen(fq_ReaVol) nq(5)
tab fq_ReaVol

//call
xtile CallImVol = c,nq(6)
tab CallImVol
quantiles CallImVol,gen(q_CallImVol) nq(6)
tab q_CallImVol
bysort realized  p implied RI CP ER:quantiles CallImVol,gen(fq_CallImVol) nq(5)
tab fq_CallImVol

//put
xtile PutImVol = p,nq(6)
tab PutImVol
quantiles PutImVol,gen(q_PutImVol) nq(6)
tab q_PutImVol
bysort realized c  implied RI CP ER:quantiles PutImVol,gen(fq_PutImVol) nq(5)
tab fq_PutImVol

//famamacbeth 回归
//先做beta回归

//在做时间序列回归
xtfmb  beta(realized )  beta(c) beta (p)
tsset year
xtfmb  ER  realized c p
xtfmb ER  realized c p, verbose
