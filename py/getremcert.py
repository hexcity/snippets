# import requests module
import requests
 
# Making a get request
#response = requests.get('https://expired.badssl.com/')
response = requests.get('https://192.168.88.4:7878/')
 
# print request object
print(response)