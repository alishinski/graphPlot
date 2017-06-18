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
## Using the old function
# graphPlot::bnlearnPlot(fitted)
## using the S3 method for class bn.fit
# graphPlot(fitted)
#
# library(lavaan)
# library(DiagrammeR)
#
# model <- 'mpg ~ cyl + disp + hp
#           qsec ~ disp + hp + wt'
#
# fit <- sem(model, data = mtcars)
#
## Using the old function
# lavaanPlot(model = fit, node_options = list(shape = "box", fontname = "Helvetica"), edge_options = list(color = "grey"))
## Using the new version of the function that is unfinished
# lavaanPlot_dev(model = fit)
## Using the S3 method for class lavaan
# graphPlot(fit)

# model <- fit
# node_options = list(shape = "box")
#
# lavaanPlot_dev <- function(model, labels = NULL, node_options = list(shape = "box")) {
#   paths <- data.frame(model@ParTable$lhs, model@ParTable$rhs, model@ParTable$op)
#   plot_paths <- paths[paths$model.ParTable.op == "~",1:2]
#   nodes <- unique(c(model@ParTable$lhs, model@ParTable$rhs))
#   node_frame <- DiagrammeR::create_nodes(nodes, node_options)
#   node_frame <- DiagrammeR::create_nodes(nodes)
#   shape <- rep("box", 6)
#   node_frame <- DiagrammeR::create_nodes(nodes, shape = "box")
#   edge_frame <- DiagrammeR::create_edges(from = plot_paths$model.ParTable.rhs, to = plot_paths$model.ParTable.lhs)
#   graph <- DiagrammeR::create_graph(nodes_df = node_frame, edges_df = edge_frame)
#   DiagrammeR::render_graph(graph)
# }
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
