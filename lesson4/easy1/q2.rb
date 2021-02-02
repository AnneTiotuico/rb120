module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed
  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

my_car = Car.new
my_car.go_fast

my_truck = Truck.new
my_truck.go_fast

blue_truck = Truck.new
blue_truck.go_fast


small_car = Car.new
small_car.go_fast
