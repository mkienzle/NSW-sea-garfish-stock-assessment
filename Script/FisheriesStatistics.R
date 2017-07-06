# CREATED    5 Oct. 2016
# MODIFIED   5 Oct. 2016

# PURPOSE plot fisheries statistics

catch <- read.csv("../Data/GarfishCatchData.csv")
effort <- read.csv("../Data/GarfishEffortData.csv")

#postscript("Results/Graphics/CatchAndEffortVariations.ps")
png("Results/Graphics/CatchAndEffortVariations.png")
#par(fg = "black", col.main = "black", col.axis = "black", col.lab = "black", cex = 1.5, cex.lab = 2, cex.axis = 1.5, cex.main = 2.5, mai = c(1.2, 1.8, 1.02, 1.5), mgp = c(4, 1, 0))

par(mai = c(1.2, 1.8, 1.02, 1.5), mgp = c(4, 1, 0))

mp <- with(catch, barplot(t(1e-3 * Catch.in.kg), las = 1, beside = T, border = "lightgrey", col = "lightgrey",
                        ylab = "Catch (tonnes)", ylim = c(0, 100), axes = FALSE, xlab = ""))

axis(side = 1, at = mp, label = catch$Year)
axis(side = 2, at = seq(0, 100, 20), label = seq(0,100,20), las = 1)

with(effort, lines(mp, Effort.in.days / 10, type = "b", pch = 19))
#lines(mp, catch$Catch.in.kg / effort$Effort.in.days / 3, type = "b", pch = 15)


#with(tmp, lines(mp, .5e3 * Catch/Effort, type = "b", pch = 19, col = "black"))
#lines(mp, .5e3 * tmmp2[,1]/tmmp[,1], type = "b", pch = 15, col = "black")
#lines(mp, .5e3 * tmmp2[,2]/tmmp[,2], type = "b", pch = 17, col = "black")

axis(side = 4, at = seq(0, 100, 20), label = seq(0, 1000, 200), las = 1)
mtext(expression(paste("Effort (", boat.days^-1, ")", sep = "")), side=4,line=3)
box()
#abline( h = seq(0,3e4, 5e3), lty = 2, col = "grey")
legend(15, 100, legend = c("Catch", "Effort"), col = c("lightgrey", "black"), pch = c(15,19), cex = 1, bg = "white")
dev.off()
