class Crew::PdfsController < ApplicationController
  before_action :authenticate_crew_admin!
  # PDFKit gem is used for this controller purpose

  # Downloads a PDF with all users ordered by name. Only emails and numbers are shown.
  def users
    @users = User.all.order(:name)
    html = render_to_string(layout: 'pdf')
    kit = PDFKit.new(html)
    pdf = kit.to_pdf

    send_data pdf, filename: "congressistas_#{DateTime.now.strftime('%y:%m:%d:%H:%M')}.pdf",
                   type: "application/pdf"
  end

  # Download a PDF with all user of an event.
  def event_users
    @event = Event.find(params[:id])
    @users = @event.users
    html = render_to_string(layout: 'pdf')
    kit = PDFKit.new(html)
    pdf = kit.to_pdf

    send_data pdf, filename: "congressistas em #{@event.name}.pdf"
  end
end
