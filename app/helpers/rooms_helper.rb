module RoomsHelper
  def show_capacity(room)
    people_count = room.users.count

    if people_count < room.capacity
      color = 'green-text darken-3'
    else
      color = 'red-text darken-3'
    end

    "
      <span class=\"#{color}\">
        #{people_count}/#{room.capacity}
      </span>
    ".html_safe
  end
end
