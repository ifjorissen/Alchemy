# Alchemy.js is a graph drawing application for the web.
# Copyright (C) 2014  GraphAlchemist, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

alchemy.startGraph = (data) ->
    # save nodes & edges
    alchemy.nodes = data.nodes
    alchemy.edges = data.edges

    # create nodes map and update links
    nodesMap = d3.map()
    alchemy.nodes.forEach (n) ->
        nodesMap.set(n.id, n)
    alchemy.edges.forEach (e) ->
        e.source = nodesMap.get(e.source)
        e.target = nodesMap.get(e.target)

    #API FIXME: allow alternative root node positioning?
    alchemy.layout.positionRootNodes()

    #create SVG
    alchemy.vis = d3.select('.alchemy')
        .attr("style", "width:#{alchemy.conf.graphWidth}px; height:#{alchemy.conf.graphHeight}px")
        .append("svg")
            .attr("xmlns", "http://www.w3.org/2000/svg")
            .attr("pointer-events", "all")
            .on("dblclick.zoom", null)
            .on('click', alchemy.utils.deselectAll)
            .call(alchemy.interactions.zoom)
            .append('g')
                .attr("transform","translate(#{alchemy.conf.initialTranslate}) scale(#{alchemy.conf.initialScale})")

    #enter/exit nodes/edges
    # alchemy.edge = alchemy.vis.selectAll("line")
    #            .data(alchemy.edges)#, (d) -> d.source.id + '-' + d.target.id + d.node_type)
    # alchemy.node = alchemy.vis.selectAll("g.node")
    #           .data(alchemy.nodes)#, (d) -> d.id)
    # force layout constant
    k = Math.sqrt(alchemy.nodes.length / (alchemy.conf.graphWidth * alchemy.conf.graphHeight))

    # create layout
    alchemy.force = d3.layout.force()
        .charge(alchemy.layout.charge(k))
        .linkDistance((d) -> alchemy.layout.linkDistanceFn(d,k))
        .theta(1.0)
        .gravity(alchemy.layout.gravity(k))
        .linkStrength(alchemy.layout.linkStrength)
        .friction(alchemy.layout.friction())
        .chargeDistance(alchemy.layout.chargeDistance())
        .size([alchemy.conf.graphWidth, alchemy.conf.graphHeight])
        .nodes(alchemy.nodes)
        .links(alchemy.edges)
        .on("tick", alchemy.layout.tick)

    # TODO: fix this in the graph file generating view instead of here
    fixNodesTags(alchemy.nodes, alchemy.edges);

    alchemy.updateGraph()
    # alchemy.zoomControls.init()
    alchemy.controlDash.init()
    # alchemy.filters.init(alchemy.nodes, alchemy.edges)
    # alchemy.stats.init()
    
    # alchemy.configuration for forceLocked
    if !alchemy.conf.forceLocked 
         alchemy.force
                .on("tick", alchemy.layout.tick)
                .start()


    # call user-specified functions after load function if specified
    # deprecate?
    if alchemy.conf.afterLoad?
        if typeof alchemy.conf.afterLoad is 'function'
            alchemy.conf.afterLoad()
        else if typeof alchemy.conf.afterLoad is 'string'
            alchemy[alchemy.conf.afterLoad] = true

    if alchemy.conf.initialScale isnt alchemy.defaults.initialScale
        alchemy.interactions.zoom.scale(alchemy.conf.initialScale)
        return

    if alchemy.conf.initialTranslate isnt alchemy.defaults.initialTranslate
        alchemy.interactions.zoom.translate(alchemy.conf.initialTranslate)
        return
