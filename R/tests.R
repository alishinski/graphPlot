# library(bnlearn)
#
# # learn the network structure.
# res = gs(learning.test)
# # set the direction of the only undirected arc, A - B.
# res = set.arc(res, "A", "B")
# # estimate the parameters of the Bayesian network.
# fitted = bn.fit(res, learning.test)
# # replace the parameters of the node B.
# new.cpt = matrix(c(0.1, 0.2, 0.3, 0.2, 0.5, 0.6, 0.7, 0.3, 0.1),
#                  byrow = TRUE, ncol = 3,
#                  dimnames = list(B = c("a", "b", "c"), A = c("a", "b", "c")))
# fitted$B = as.table(new.cpt)
# # the network structure is still the same.
# all.equal(res, bn.net(fitted))
#
#
# graphPlot::bnlearnPlot(fitted)
# library(lavaan)
#
# model <- 'mpg ~ cyl + disp + hp
#           qsec ~ disp + hp + wt'
#
# fit <- sem(model, data = mtcars)
# summary(fit)
#
# lavaanPlot(model = fit, node_options = list(shape = "box", fontname = "Helvetica"), edge_options = list(color = "grey"))
#
#
# labels <- list(mpg = "Miles Per Gallon", cyl = "Cylinders", disp = "Displacement", hp = "Horsepower", qsec = "Speed", wt = "Weight")
#
# lavaanPlot(model = fit, labels = labels, node_options = list(shape = "box", fontname = "Helvetica"), edge_options = list(color = "grey"))
#
#
# HS.model <- ' visual  =~ x1 + x2 + x3
# textual =~ x4 + x5 + x6
# speed   =~ x7 + x8 + x9
# '
#
# fit <- cfa(HS.model, data=HolzingerSwineford1939)
#
# lavaanPlot(model = fit, edge_options = list(color = "grey"))
