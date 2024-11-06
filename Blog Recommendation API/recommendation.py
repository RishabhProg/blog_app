import pandas as pd
import csv
import numpy as np
import nltk
import re
from nltk import corpus
from nltk.stem import WordNetLemmatizer
from nltk.stem import PorterStemmer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from nltk import wsd
from nltk.corpus import wordnet as wn

nltk.download('omw-1.4')
nltk.download('wordnet')
nltk.download('wordnet2022')
nltk.download('stopwords')

from pymongo import MongoClient
uri = "mongodb+srv://pushpanjali:Pushpanjali123@blogplatform.3q8rv.mongodb.net/"
client = MongoClient(uri)

client.list_database_names()

db=client['test']
collection=db['blogs']

blogs=csv.writer
blogs = pd.read_csv('')
users = pd.read_csv('data/users.csv')
interactions = pd.read_csv('data/interactions.csv')
comments = pd.read_csv('data/comments.csv')

blogs.drop(['user_id','published_at'],axis='columns',inplace=True)

import re
def clean(text):
    return re.sub("[^a-zA-Z0-9 ]","",text)
blogs["clean_title"]=blogs["title"].apply(clean)
blogs["clean_content"]=blogs["content"].apply(clean)
blogs["clean_category"]=blogs["category"].apply(clean)
blogs

lst_stopwords=corpus.stopwords.words('english')
def pre_process_text(text, flg_stemm=False, flg_lemm=True, lst_stopwords=None):
    text=str(text).lower()
    text=text.strip()
    text = re.sub(r'[^\w\s]', '', text)
    lst_text = text.split()
    if lst_stopwords is not None:
        lst_text=[word for word in lst_text if word not in lst_stopwords]
    if flg_lemm:
        lemmatizer = WordNetLemmatizer()
        lst_text = [lemmatizer.lemmatize(word) for word in lst_text]
    if flg_stemm:
        stemmer = PorterStemmer()
        lst_text = [stemmer.stem(word) for word in lst_text]
    text=" ".join(lst_text)
    return text

blogs['clean_content'] = blogs['clean_content'].apply(lambda x: pre_process_text(x,flg_stemm=False,flg_lemm=True,lst_stopwords=lst_stopwords))
blogs['clean_title'] = blogs['clean_title'].apply(lambda x: pre_process_text(x,flg_stemm=False,flg_lemm=True,lst_stopwords=lst_stopwords))
blogs['clean_category'] = blogs['clean_category'].apply(lambda x: pre_process_text(x,flg_stemm=False,flg_lemm=True,lst_stopwords=lst_stopwords))
blogs['tokens']=blogs['clean_title']+blogs['clean_content']+blogs['clean_category']

tfidf_vecotorizer = TfidfVectorizer()
tfidf_matrix = tfidf_vecotorizer.fit_transform(blogs['tokens'])

def recommend(text):
    text=clean(text)
    query_vec = tfidf_vecotorizer.transform([text])
    similarity = cosine_similarity(query_vec, tfidf_matrix).flatten()
    indices = np.argpartition(similarity, -10)[-5:]
    results = blogs.iloc[indices].iloc[::-1]
    return results


