import tweepy
from kafka import KafkaProducer
import json
import time 

BEARER_TOKEN = "AAAAAAAAAAAAAAAAAAAAAJW5ygEAAAAAF0rR3zoM%2Fso3c85P5MwXr4jI89c%3D378RletHfJK2Yqo2rhVtdS4LIlXrgMK9zWFLNURX9RZehmiuMT"

# Kafka producer
producer = KafkaProducer(
	bootstrap_servers="localhost:9092",
	value_serializer=lambda x: json.dumps(x).encode("utf-8")
)

client = tweepy.Client(bearer_token=BEARER_TOKEN)

def fetch_tweets():
	query = "#madani  -is:retweet"  # Search for tweets with these hashtags
	tweets = client.search_recent_tweets(query=query, tweet_fields=["created_at", "text", "id"], max_results=10)

	if tweets.data:
		for tweet in tweets.data:
			tweet_data = {
				"id": tweet.id,
				"text": tweet.text,
				"timestamp": str(tweet.created_at)
			}
			producer.send("twitter-stream", value=tweet_data)  # Send to Kafka
			print(f"Tweet sent: {tweet_data}")

while True:
	fetch_tweets()
	time.sleep(30)
