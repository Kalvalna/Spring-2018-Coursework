library(quantmod)
library(TTR)
library(rpart)
library(rpart.plot)
library(caTools)

# Prepare data for analysis
system.time({
Initial_Equity = 100000
symbol = "AAPL"
data = getSymbols(symbol, from = "2010-01-01", auto.assign=FALSE)
colnames(data) = c("Open","High","Low","Close","Volume","Adjusted")
data = na.omit(data)
closeprice = Cl(data)
rsi = round(RSI(closeprice, n = 14, maType="WMA"),1)
rsi = c(NA, head(rsi,-1))
ShMA = 20
LMA = 50
sma = round(SMA(closeprice, ShMA), 1)
sma = c(NA, head(sma,-1))
lma = round(SMA(closeprice, LMA), 1)
lma = c(NA, head(lma,-1))
data22 = ADX(data[,c("High","Low","Close")])
data22 = as.data.frame(data22)
adx = round(data22$ADX, 1)
adx = c(NA, head(adx, -1))
data$Return = round(dailyReturn(data$Close, type='arithmetic'),2)
colnames(data) = c("Open","High","Low","Close","Volume","Adjusted","Return")
class = character(nrow(data))
class = ifelse(coredata(data$Return) >=0, "Up","Down")
data2 = data.frame(data,class,rsi,sma,lma,adx)
write.csv(data2,file="decision tree charting_table.csv")
data = data.frame(class,rsi,sma,lma,adx)
data = na.omit(data)
write.csv(data,file="decision tree charting.csv")
})

# Read data from csv file; Filter by quarter when doing quarterly analysis
df = read.csv("decision tree charting.csv")
df = df[,-1]
colnames(df) = c("Class", "RSI", "SMA", "LMA", "ADX")

# Split dataset into training and testing sets. Change 500 and 501 to 150 and 
#151 for quarterly data
dataTrain = df[1:500,]
dataTest = df[501:nrow(df),]

# Generate and display the decision tree
tree <- rpart(Class~RSI+SMA+LMA+ADX,data=dataTrain,cp=.001)
prp(tree,type=2,extra=8)

# Generates prediction of testing set and prints confusion matrix
pred = predict(tree, newdata=dataTest, type="class")
table(pred,dataTest$Class)

df = read.csv("decision tree charting.csv")
df = df[,-1]
colnames(df) = c("Class", "RSI", "SMA", "LMA", "ADX")
dataTrain = df[1:150,]
dataTest = df[151:nrow(df),]
tree <- rpart(Class~RSI+SMA+LMA+ADX,data=dataTrain,cp=.001)
prp(tree,type=2,extra=8)
pred = predict(tree, newdata=dataTest, type="class")
table(pred,dataTest$Class)
