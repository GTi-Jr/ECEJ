module RoomsHelper
  def show_capacity(room)
    people_count = room.users.count

    if people_count < room.capacity
      color = 'green-text darken-3'
      message = "#{people_count}/#{room.capacity} pessoas"
    else
      color = 'red-text darken-3'
      message = 'Lotado'
    end

    "
      <span class=\"#{color}\">
        #{message}
      </span>
    ".html_safe
  end
end
