#print("Hello Sonar")

import os

# BAD PRACTICE: hardcoded password (Sonar will flag this)


def calculate(a, b):
    result = a + b
    unused_var = 10   # unused variable (issue)
    return result

def divide(a, b):
    try:
        return a / b
    except:
        pass   # bad exception handling (issue)

def duplicate_code(x):
    if x > 10:
        print("Greater than 10")
    if x > 10:   # duplicate condition (issue)
        print("Still greater than 10")

def risky_function():
    eval("print('Hello')")   # security issue

if __name__ == "__main__":
    print(calculate(5, 3))
    print(divide(10, 0))
    duplicate_code(20)
    risky_function()
