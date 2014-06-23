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

alchemy.begin = (userConf) ->
    alchemy.conf = _.assign({}, alchemy.defaults, userConf)

    if alchemy.conf.dataSource == null
        no_results = """
                    <div class="modal fade" id="no-results">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title">Congratulations!</h4>
                                </div>
                                <div class="modal-body">
                                    <p>You've got Alchemy.js up and running!</p>
                                    <p>Check out the <a href="https://github.com/GraphAlchemist/Alchemy/wiki">documentation</a>
                                       for examples and help getting started.</p>
                                    <p>In the meantime, we've set up a sample graph for you to play around with.</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>
                   """
        $('body').append(no_results)
        $('#no-results').modal('show')
  
        alchemy.conf = _.assign({}, alchemy.defaults, alchemy.welcomeConf)
        d3.json("../sample_data/default.json", alchemy.startGraph)
        
    else if typeof alchemy.conf.dataSource == 'string'
        d3.json(alchemy.conf.dataSource, alchemy.startGraph)
    else if typeof alchemy.conf.dataSource == 'object'
        alchemy.startGraph(alchemy.conf.dataSource)
    