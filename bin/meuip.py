import requests

def meuipjson_requests():
    url = 'https://ipinfo.io/json'
    site = requests.get(url).json()
    print(site['ip'])
    # print(site['city'])

if __name__ == '__main__':
    meuipjson_requests()