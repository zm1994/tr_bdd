class DataRailwaySearch
  attr_accessor :departure_railway_city, :departure_railway_station, :departure_railway_code, :params_departure_location
  attr_accessor :arrival_railway_city, :arrival_railway_station, :arrival_railway_code, :params_arrival_location
  attr_accessor :date_railway_departure
  attr_accessor :array_popular_directions

  def initialize
    @departure_railway_city = 'Киев'
    @departure_railway_station = 'Киев-Пассажирский'
    @departure_railway_code = '2200001'

    @arrival_railway_city = 'Харьков'
    @arrival_railway_station = 'Харьков-Пасс'
    @departure_railway_code = '2204001'

    @params_departure_location = { city: @departure_railway_city,
                                   station: @departure_railway_station,
                                   code: @departure_railway_code }

    @params_arrival_location = {  city: @arrival_railway_city,
                                  station: @arrival_railway_station,
                                  code: @departure_railway_code }

    @date_railway_departure = Time.now.strftime("%d.%m.%Y")

    @array_popular_directions = [['Киев', 'Харьков'], ['Киев', 'Одесса'], ['Киев', 'Львов'], ['Львов', 'Харьков'], ['Харьков', 'Одесса']]
  end
end

class Passenger
  attr_accessor :first_name, :last_name, :type_passenger, :age, :preferential_document
  attr_accessor :params_passenger

  def initialize
    @first_name = 'Иван'
    @last_name = 'Иванов'
    @type_passenger = 'adult'

    @params_passenger = { first_name: @first_name,
                          last_name: @last_name,
                          type_passenger: @type_passenger }
  end

  def set_as_student(first_name, last_name, type_passenger, preferential_document)
    @first_name = first_name
    @last_name = last_name
    @type_passenger = type_passenger
    @preferential_document = preferential_document

    @params_passenger = { first_name: @first_name,
                          last_name: @last_name,
                          type_passenger: @type_passenger,
                          preferential_document: @preferential_document }
  end

  def set_as_child(first_name, last_name, type_passenger, age)
    @first_name = first_name
    @last_name = last_name
    @type_passenger = type_passenger
    @age = age

    @params_passenger = { first_name: @first_name,
                          last_name: @last_name,
                          type_passenger: @type_passenger,
                          age: @age }
  end
end

class Payer
  attr_accessor :full_name, :email, :telephone
  attr_accessor :params_payer

  def initialize
    @full_name = 'Тест тест'
    @email = 'test@example.com'
    @telephone = '+38064763434'

    @params_payer = { full_name: @full_name, email: @email, telephone: @telephone }
  end
end