# A comment, this is so you can read your program later.
# Anything after the # is ignored by python.

print("I could have code like this.") # and the comment after is ignored

# You can also use a comment to "disable" or comment out code:
# print("This won't run.")

print("This will run.")

# In this exercise I'm going to compute the factorial of 50
print("let's compute 10!")
n=10 #the number which we want to compute about the factorial
m=1 #set the start value of m=1
for i in range(n): #write a for loop to compute the value of 10!
	m=m*(i+1)  #because in python, i starts from 0 to n-1, so we want to compute n!, we need to use i+1
print("the value of 10! is",m) #print the results of 10!
