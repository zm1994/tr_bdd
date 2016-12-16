  class DataOneWaySearch
    attr_accessor :type_avia_search, :departure_city, :departure_avia_code, :arrival_city, :arrival_avia_code
    attr_accessor :time_departure, :time_arrive, :string_format_date_dep, :string_format_date_arr
    attr_accessor :params_avia_location, :params_flight_dates, :params_flight_dates, :params_passengers

    def initialize
      @departure_city = 'Киев'
      @departure_avia_code = 'IEV'
      @arrival_city = 'Варшава'
      @arrival_avia_code = 'WAW'
      random_date = Random.new
      @time_departure = Time.now + random_date.rand(5...20).days
      @type_avia_search = 'one_way'
      @string_format_date = @time_departure.strftime("%d.%m.%Y")

      @params_avia_location = { departure_avia_city: @departure_city,
                                departure_avia_code: @departure_avia_code,
                                arrival_avia_city: @arrival_city,
                                arrival_avia_code: @arrival_avia_code }

      @params_flight_dates = { date_departure: @string_format_date }
      @params_passengers = { adults: '1', children: '1', infants: '1', cabin_class: 'economy' }
    end
  end

  class DataRoundSearch
    attr_accessor :type_avia_search, :departure_city, :departure_avia_code, :arrival_city, :arrival_avia_code
    attr_accessor :time_departure, :time_arrive, :string_format_date_dep, :string_format_date_arr
    attr_accessor :params_avia_location, :params_flight_dates, :params_flight_dates, :params_passengers

    def initialize
      @departure_city = 'Киев'
      @departure_avia_code = 'IEV'
      @arrival_city = 'Варшава'
      @arrival_avia_code = 'WAW'
      random_date = Random.new
      @time_departure = Time.now + random_date.rand(5...20).days
      @time_arrive = @time_departure + 10.days
      @type_avia_search =  'round_trip'
      @string_format_date_dep = @time_departure.strftime("%d.%m.%Y")
      @string_format_date_arr = @time_arrive.strftime("%d.%m.%Y")

      @params_avia_location = { departure_avia_city: @departure_city,
                                departure_avia_code: @departure_avia_code,
                                arrival_avia_city: @arrival_city,
                                arrival_avia_code: @arrival_avia_code }

      @params_flight_dates = { date_departure: @string_format_date_dep,
                               date_arrival: @string_format_date_arr }

      @params_passengers = { adults: '1', children: '1', infants: '1', cabin_class: 'economy' }
    end
  end

  class DataComplexSearch
    attr_reader :type_avia_search, :departure_city, :departure_avia_code, :arrival_city, :arrival_avia_code
    attr_accessor :time_departure, :time_arrive, :string_format_date_dep, :string_format_date_arr
    attr_accessor :params_avia_location, :params_flight_dates, :params_flight_dates, :params_passengers

    def initialize
      @departure_city = 'Киев'
      @departure_avia_code = 'IEV'
      @arrival_city = 'Варшава'
      @arrival_avia_code = 'WAW'
      random_date = Random.new
      @time_departure = Time.now + random_date.rand(5...20).days
      @time_arrive = @time_departure + 10.days
      @type_avia_search =  'complex_trip'
      @string_format_date_dep = @time_departure.strftime("%d.%m.%Y")
      @string_format_date_arr = @time_arrive.strftime("%d.%m.%Y")

      @params_avia_location = { departure_avia_city: @departure_city,
                                departure_avia_code: @departure_avia_code,
                                arrival_avia_city: @arrival_city,
                                arrival_avia_code: @arrival_avia_code }
      # date_arrival is a date of departure second flight trip

      @params_flight_dates = { date_departure: @string_format_date_dep,
                               date_arrival: @string_format_date_arr }

      @params_passengers = { adults: '1', children: '1', infants: '1', cabin_class: 'economy' }
    end
  end

  class Passengers
    attr_accessor :params_adult, :params_child, :params_infant

    def initialize
      random = Random.new

      @params_adult = { first_name: 'ANDREY',
                        last_name: 'ANDREEV',
                        birthday: '12.01.1980',
                        passport_number: 'CL' + random.rand(10000...900000).to_s,
                        passport_expired: '20.12.2017' }

      @params_child = { first_name:  'SERGEY',
                        last_name:  'ANDREEV',
                        birthday: '15.05.2008',
                        passport_number: 'CL' + random.rand(10000...900000).to_s,
                        passport_expired: '10.10.2019' }

      @params_infant = { first_name: 'ALEXANDR',
                         last_name: 'ANDREEV',
                         birthday: '09.04.2016',
                         passport_number: 'CK' + random.rand(10000...900000).to_s,
                         passport_expired: '20.12.2017' }
    end
  end

  class Payer
    attr_accessor :params_payer

    def initialize
      @params_payer = { juridical_name: 'TEST TEST',
                        registration_number: '12345678',
                        email: 'test@example.com',
                        phone: '+380234534545',
                        full_name: 'TESTER',
                        password: 'qwerty123'}
    end
  end