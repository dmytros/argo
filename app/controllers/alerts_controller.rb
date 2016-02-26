class AlertsController < ApplicationController
  layout 'alert'
  
  def list
    render json: {data: []}

#    render json: {data: [
#      ['Malware IP Found', '10.11.12.13', '2015-09-01 15:34:12', view_context.link_to('Seen', '',  class: "button button-pill button-flat") + " " + view_context.link_to('Details', '',  class: "button button-pill button-flat")],
#      ['Blocked User Logged in', 'kevinj', '2015-09-01 15:38:34', view_context.link_to('Seen', '', class: "button button-pill button-flat") + " " + view_context.link_to('Details', '',  class: "button button-pill button-flat")]
#    ]}.to_json
  end
end
