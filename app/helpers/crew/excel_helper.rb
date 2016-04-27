module Crew::ExcelHelper
  def print_rooms(hotel, order = :number)
    str = ''
    hotel.rooms.includes(:users).order(order).each do |room|
      str << '<Row><Cell><Data ss:Type="String">Nº ' + room.number.to_s + '</Data></Cell></Row>'
      str << '<Row>
                <Cell><Data ss:Type="String">Nome</Data></Cell>
                <Cell><Data ss:Type="String">Email</Data></Cell>
                <Cell><Data ss:Type="String">Telefone</Data></Cell>
                <Cell><Data ss:Type="String">Empresa Júnior</Data></Cell>
              </Row>'

      room.users.order(:name).each do |user|
        str << '<Row>
                  <Cell><Data ss:Type="String">' + user.name              + '</Data></Cell>''
                  <Cell><Data ss:Type="String">' + user.email             + '</Data></Cell>
                  <Cell><Data ss:Type="String">' + user.phone             + '</Data></Cell>
                  <Cell><Data ss:Type="String">' + user.junior_enterprise + '</Data></Cell>
                </Row>'
      end
      str << '<Row></Row>'
    end
    str.html_safe
  end
end
