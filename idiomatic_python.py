# https://medium.com/the-andela-way/idiomatic-python-coding-the-smart-way-cc560fa5f1d6

#For example an empty list/sequences [], empty dictionaries {} None, False, Zero for numeric types, are considered “falsy”. On the other hand, almost everything else is considered “truthy”.
#Bad
x = True
y = 0
if x == True:
  # do something
elif x == False:
  # do something else
if y == 0:
  # do something
ls = [2, 5]
if len(ls) > 0:
  # do something
#Good
(x, y) = (True, 0)
# x is truthy
if x:
  # do something
else:
  # do something else
# y is falsy
if not y:
  # do something
ls = [2, 5]
if ls:
  # do something
