library(spocc)
spocc_download = occ(query ='Phascolarctos cinereus', from='gbif', limit=2000);
spocc_download

library(dismo)
library(raster)
wc = getData('worldclim', var='bio', res=5)

library(ENMeval)

occdat <- occ2df(spocc_download)
ext=extent(c(115, 155, -40, 20))
predictors = crop(wc, ext)

loc=occdat[,c('longitude', 'latitude')]
extr = extract(predictors, loc)
loc = loc[!is.na(extr[,1]),]

eval = ENMevaluate(occ=as.data.frame(loc), env = predictors, method='block', parallel=FALSE, fc=c("L", "LQ"), RMvalues=seq(0.5, 2, 0.5), rasterPreds=T)

which(eval@results$AICc == min(eval@results$AICc))
which(eval@results$avg.test.AUC== max(eval@results$avg.test.AUC))
best=which(eval@results$AICc == min(eval@results$AICc))

plot(eval@predictions[[best]])
points(as.data.frame(loc), pch=20, cex =0.1)

est.loc = extract(eval@predictions[[best]], as.data.frame(loc))
est.bg = extract(eval@predictions[[best]], eval@bg.pts)
ev = evaluate(est.loc, est.bg)
thr = threshold(ev)
plot(eval@predictions[[best]] > thr$equal_sens_spec, col = c('light gray', 'cyan'))
points(as.data.frame(loc), pch=20, cex =0.1)




