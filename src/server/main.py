# app.py
from flask import Flask, request, jsonify
import requests
from bs4 import BeautifulSoup

app = Flask(__name__)

@app.route('/', methods=['GET'])
def scrape():
    url = 'https://dl.acm.org/action/doSearch?fillQuickSearch=false&target=advanced&expand=dl&AllField=Abstract%3A%28%22functional%22+OR+%22lamba+calculus%22%29+AND+ContribAuthor%3A%28%22church%22%29'

    if not url:
        return jsonify({'error': 'URL not provided'}), 400

    # Scraping logic
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    # Replace this with the actual scraping logic based on the structure of the page
    scraped_data = soup.title.text if soup.title else 'No title found'

    return jsonify({'result': scraped_data})

if __name__ == '__main__':
    app.run(port=5001)
