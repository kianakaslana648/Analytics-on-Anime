import tweepy
from tweepy import OAuthHandler
import json
from tweepy import Stream
from tweepy.streaming import StreamListener
import sys

consumer_key='XXX'
consumer_secret='XXX'
access_token='XXX'
access_secret='XXX'

auth=OAuthHandler(consumer_key,consumer_secret)
auth.set_access_token(access_token,access_secret)
api=tweepy.API(auth)

output_file=open('TwitterSteinsGate.txt','w',encoding='utf-8')

search_results=[status for status in tweepy.Cursor(api.search,q='steins gate',lang='en').items(1000)]

for tweet in search_results:
    output_file.write(json.dumps(tweet.text))
    output_file.write("\n")
    #print(tweet._json['text'])
