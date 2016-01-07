class Crew::PdfsController < ApplicationController
  before_action :authenticate_crew_admin!

  def users
    @users = User.all.order(:name)    
    html = render_to_string(layout: 'pdf')    
    kit = PDFKit.new(html)
    pdf = kit.to_pdf
    
    send_data pdf, filename: "congressistas_#{DateTime.now.strftime('%y:%m:%d:%H:%M')}.pdf",
                   type: "application/pdf"
  end

  def event_users
    @event = Event.find(params[:id])
    html = render_to_string(layout: 'pdf')
    kit = PDFKit.new(html)
    pdf = kit.to_pdf

    send_data pdf, filename: "congressistas em #{@event.name}.pdf"  
  end
end
