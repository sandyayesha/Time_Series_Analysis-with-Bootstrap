#Install the packages
#install.packages('readxl')
#install.packages('fpp')

#Run the packages
library(readxl)
library(fpp)

#Import data
data <- read_excel("Download/Rice Price Data.xlsx.xlsx", 
                   sheet = "Sheet1") #Based on your directory
data=ts(data)

#Transform the data into time series
train=data[1:60]
test=data[61:72]
data_train<-ts(train,start=c(1,1),freq=1)
data_train
uji<-ts(test,start=c(61,1),freq=1)
uji

#Check its stationarity in variance
stas.var<- BoxCox.lambda(data_train)
stas.var

#First Box Cox Transformation
data_train=data_train^stas.var
uji=uji^stas.var

#Check its stationarity in variance again
stas.var<- BoxCox.lambda(data_train)
stas.var

#Second Box Cox Transformation
data_train=data_train^stas.var
uji=uji^stas.var

#Check its stationarity in variance again
stas.var<- BoxCox.lambda(data_train)
stas.var #if stas.var=1 the it is stationar in variance

#Check its stationarity in mean
adf.test(data_train)

#Differentation
fit<-diff(data_train,lag=1) #(d=1)
adf.test(fit) #if p-value < alpha the it is stationar in mean

#Plot the ACF and PACF
acf(fit,60) #q = 2
pacf(fit,60) #p = 1

#Make the best model
#You can use the arima.fit but here I finf the best model manually
Model1=arima(data_train,order=c(1,0,1)) #ARIMA (1,0,1)

#Bootstrapping Residual
set.seed(1)
B=1000
paramet_ar=c()
paramet_ma=c()
paramet_intersep=c()
for(i in 1:B){
  xstar<-sample(Model1$residuals,length(Model1$residuals),replace=T)
  data_boot<-data_train+xstar
  Model=arima(data_boot,order=c(1,0,1))
  paramet_ar=c(paramet_ar,Model$coef["ar1"])
  paramet_ma=c(paramet_ma,Model$coef["ma1"])
  paramet_intersep=c(paramet_intersep,Model$coef["intercept"])
}
paramet_ar_mean=mean(paramet_ar)
paramet_ma_mean=mean(paramet_ma)
paramet_intersep_mean=mean(paramet_intersep)
cat("Parameter AR= ",paramet_ar_mean,"\nParameter MA= ",paramet_ma_mean, "\n
    Parameter Intersep= ",paramet_intersep_mean,"\n")
cat("Dengan standar deviasi ",
    paramet_ar_mean-1.96*sd(paramet_ar)," < Parameter AR < ",paramet_ar_mean+1.96*sd(paramet_ar)
    ,"\n",paramet_ma_mean-1.96*sd(paramet_ma)," < Parameter MA < ",paramet_ma_mean+1.96*sd(paramet_ma)
    ,"\n",paramet_intersep_mean-1.96*sd(paramet_intersep)," < Parameter Intersep < ",paramet_intersep_mean+1.96*sd(paramet_intersep))

#Forecasting and model Validation
data_train_peramalan=data_train[1]
data_train_peramalan=c(data_train_peramalan,paramet_ar_mean*data_train[1]-paramet_ma_mean*(data_train[1]-data_train_peramalan[1])+mean(data_train)*(1-paramet_ar_mean))
for(i in 3:61){
  peramal=paramet_ar_mean*data_train[i-1]-paramet_ma_mean*(data_train[i-1]-data_train_peramalan[i-1])+mean(data_train)*(1-paramet_ar_mean)
  data_train_peramalan=c(data_train_peramalan,peramal)
}
data_train_peramalan

for(i in 62:84){
  peramal=paramet_ar_mean*data_train_peramalan[i-1]+mean(data_train)*(1-paramet_ar_mean)
  data_train_peramalan=c(data_train_peramalan,peramal)
}
data_train_peramalan

c_uji=c(uji)

#Compute its MAPE and S-MAPE
sum(abs((c_uji-data_train_peramalan[61:72])/c_uji))/length(c_uji)
sum(abs(c_uji-data_train_peramalan[61:72])*2/(abs(c_uji)+abs(data_train_peramalan[61:72])))/length(c_uji)