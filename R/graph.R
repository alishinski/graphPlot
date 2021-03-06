#' Extracts the paths from the lavaan model.
#'
#' @param fit A model fit object of class lavaan.
buildPaths <- function(fit){
  regress <- fit@ParTable$op == "~"
  latent <- fit@ParTable$op == "=~"
  if(any(regress)){
    regress_paths <- paste(paste(fit@ParTable$rhs[regress], fit@ParTable$lhs[regress], sep = "->"), collapse = " ")
  } else {
    regress_paths <- ""
  }
  if(any(latent)) {
    latent_paths <- paste(paste(fit@ParTable$rhs[latent], fit@ParTable$lhs[latent], sep = "->"), collapse = " ")
  } else {
    latent_paths <- ""
  }
  paste(regress_paths, latent_paths, sep = " ")
}

#' Extracts the paths from the lavaan model.
#'
#' @param fit A model fit object of class lavaan.
getNodes <- function(fit){
  regress <- fit@ParTable$op == "~"
  latent <- fit@ParTable$op == "=~"
  observed_nodes <- c()
  latent_nodes <- c()
  if(any(regress)){
    observed_nodes <- c(observed_nodes, unique(fit@ParTable$rhs[regress]))
    observed_nodes <- c(observed_nodes, unique(fit@ParTable$lhs[regress]))
  }
  if(any(latent)) {
    observed_nodes <- c(observed_nodes, unique(fit@ParTable$rhs[latent]))
    latent_nodes <- c(latent_nodes, unique(fit@ParTable$lhs[latent]))
  }
  # make sure latent variables don't show up in both
  observed_nodes <- setdiff(observed_nodes, latent_nodes)
  list(observeds = observed_nodes, latents = latent_nodes)
}

#' Adds variable labels to the Diagrammer plot function call.
#'
#' @param label_list A named list of variable labels.
buildLabels <- function(label_list){
  labs <- paste(names(label_list), " [label = ", "'", label_list, "'", "]", sep = "")
  paste(labs, collapse = "\n")
}

#' Builds the Diagrammer function call.
#'
#' @param name A string of the name of the plot.
#' @param model A model fit object of class lavaan.
#' @param labels  An optionalnamed list of variable labels fit object of class lavaan.
#' @param graph_options  A named list of graph options for Diagrammer syntax.
#' @param node_options  A named list of node options for Diagrammer syntax.
#' @param edge_options  A named list of edge options for Diagrammer syntax..
#' @return A string specifying the path diagram for \code{model}
buildCall <- function(name = "plot", model, labels = NULL, graph_options, node_options, edge_options){
  string <- ""
  string <- paste(string, "digraph", name, "{")
  string <- paste(string, "\n")
  string <- paste(string, "graph", "[",  paste(paste(names(graph_options), graph_options, sep = " = "), collapse = ", "), "]")
  string <- paste(string, "\n")
  string <- paste(string, "node", "[", paste(paste(names(node_options), node_options, sep = " = "), collapse = ", "), "]")
  string <- paste(string, "\n")
  nodes <- getNodes(model)
  string <- paste(string, "node [shape = box] \n")
  string <- paste(string, paste(nodes$observeds, collapse = "; "))
  string <- paste(string, "\n")
  string <- paste(string, "node [shape = oval] \n")
  string <- paste(string, paste(nodes$latents, collapse = "; "))
  string <- paste(string, "\n")
  if(!is.null(labels)){
    labels_string = buildLabels(labels)
    string <- paste(string, labels_string)
  }
  string <- paste(string, "\n")
  string <- paste(string, "edge", "[", paste(paste(names(edge_options), edge_options, sep = " = "), collapse = ", "), "]")
  string <- paste(string, "\n")
  string <- paste(string, buildPaths(model))
  string <- paste(string, "}", sep = "\n")
  string
}

#' Plots lavaan path model with DiagrammeR
#'
#' @param name A string of the name of the plot.
#' @param model A model fit object of class lavaan.
#' @param labels  An optional named list of variable labels
#' @param graph_options  A named list of graph options for Diagrammer syntax, default provided.
#' @param node_options  A named list of node options for Diagrammer syntax, default provided.
#' @param edge_options  A named list of edge options for Diagrammer syntax., default provided.
#' @return A Diagrammer plot of the path diagram for \code{model}
#' @import DiagrammeR
#' @export
lavaanPlot <- function(name = "plot", model, labels = NULL, graph_options = list(overlap = "true", fontsize = "10"), node_options = list(shape = "box"), edge_options = list(color = "black")){
  plotCall <- buildCall(name = name, model = model, labels = labels, graph_options = graph_options, node_options = node_options, edge_options = edge_options)
  DiagrammeR::grViz(plotCall)
}

#' Plots bnlearn graph model with DiagrammeR
#'
#' @param model A model fit object of class bn.fit
#' @param labels  An optional named list of variable labels
#' @return A Diagrammer plot of the path diagram for \code{model}
#' @import DiagrammeR
#' @import bnlearn
#' @export
bnlearnPlot <- function(model, labels = NULL){
  arc <- bnlearn::arcs(model)
  arc_frame <- data.frame(arc)
  nodes <- DiagrammeR::create_nodes(unique(as.vector(arc)))
  edges <- DiagrammeR::create_edges(from = arc_frame$from, to = arc_frame$to)
  graph <- DiagrammeR::create_graph(nodes_df = nodes, edges_df = edges)
  DiagrammeR::render_graph(graph)
}

#' Plots lavaan graph model with DiagrammeR
#'
#' @param model A model fit object of class lavaan
#' @param labels  An optional named list of variable labels
#' @param node_options  A named list of node options for Diagrammer syntax, default provided.
#' @return A Diagrammer plot of the path diagram for \code{model}
#' @import DiagrammeR
#' @import lavaan
#' @export
lavaanPlot_dev <- function(model, labels = NULL, node_options = list(shape = "box")) {
  paths <- data.frame(model@ParTable$lhs, model@ParTable$rhs, model@ParTable$op)
  plot_paths <- paths[paths$model.ParTable.op == "~",1:2]
  nodes <- unique(c(model@ParTable$lhs, model@ParTable$rhs))
  parse(eval(names(node_options)[1]))
  shape <- rep("box", length(nodes))
  node_frame <- DiagrammeR::create_nodes(nodes, node_options)
  edge_frame <- DiagrammeR::create_edges(from = plot_paths$model.ParTable.rhs, to = plot_paths$model.ParTable.lhs)
  graph <- DiagrammeR::create_graph(nodes_df = node_frame, edges_df = edge_frame)
  DiagrammeR::render_graph(graph)
}
