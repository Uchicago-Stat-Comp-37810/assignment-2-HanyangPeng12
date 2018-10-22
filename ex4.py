# STAT 37810 Assignment 2
# Author: Hanyang Peng

cars = 100 #set the start value of cars
space_in_a_car = 4.0 #set the start value of space in a car
drivers = 30 #set the start value of the number of drivers
passengers = 90 #set the start value of the number of passengers
cars_not_driven = cars - drivers #calculate the number of cars which don't have drivers
cars_driven = drivers #calculate the number of cars which have drivers
carpool_capacity = cars_driven * space_in_a_car #calculate the carpool capacity, 
#which means how many space it can provide for all those driven cars
average_passengers_per_car = passengers / cars_driven #calculate the average passengers for each car
# The error mentioned by the writer when it happened in the first time he write
#is because he didn't define the variable 'car_pool_capacity', maybe he just type
#the 'carpool_capacity' in the wrong way.

print("There are", cars, "cars available.") #print out how many cars are available
print("There are only", drivers, "drivers available.") #print out how many drivers are available
print("There will be", cars_not_driven, "empty cars today.") #print out how many cars are not driven
print("We can transport", carpool_capacity, "people today.") #print out how many people we can drive today
print("We have", passengers, "to carpool today.") #print out howmany passengers we need to drive
print("We need to put about", average_passengers_per_car, 
      "in each car.") #print out how many people will be in one car