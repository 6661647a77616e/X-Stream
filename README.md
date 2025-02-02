# Twitter Data Streaming with Apache Kafka, Elasticsearch, and Kibana

## Overview
This project streams real-time Twitter data using the **Twitter API**, processes it with **Apache Kafka**, stores it in **Elasticsearch**, and visualizes it in **Kibana**.

## Tech Stack
- **Apache Kafka** (for real-time data streaming)
- **Zookeeper** (Kafka dependency for managing metadata)
- **Twitter API** (for fetching tweets)
- **Elasticsearch** (for storing and indexing tweets)
- **Kibana** (for visualization)
- **Docker** (for containerization)
- **Python** (for Kafka producer and consumer scripts)

## Setup Instructions
### 1️⃣ Clone the Repository
```bash
git clone https://github.com/Pravesh-Sudha/twitter-streams.git
cd twitter-streams/
```

### 2️⃣ Start Docker Containers
#### Start Zookeeper
```bash
docker run -d --name zookeeper -p 2181:2181 zookeeper
```
#### Start Kafka
```bash
docker run -d --name kafka \
  --link zookeeper \
  -p 9092:9092 \
  -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
  -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092 \
  -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
  confluentinc/cp-kafka
```
#### Start Elasticsearch
```bash
docker run -d --name elasticsearch -p 9200:9200 -e "discovery.type=single-node" elasticsearch:7.17.10
```
#### Start Kibana
```bash
docker run -d --name kibana --link elasticsearch -p 5601:5601 kibana:7.17.10
```

### 3️⃣ Configure Twitter API Keys
Obtain API keys from [Twitter Developer Portal](https://developer.twitter.com/) and update `producer.py`:
```python
BEARER_TOKEN = "your_twitter_bearer_token"
```
![twiiter-token](https://github.com/user-attachments/assets/1f800030-0e29-4139-96cd-2129c8939ac6)


### 4️⃣ Create Kafka Topic
```bash
docker exec -it kafka kafka-topics --create --topic twitter-stream --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
```

### 5️⃣ Run the Producer (Fetch Tweets and Send to Kafka)
```bash
python producer.py
```

### 6️⃣ Run the Consumer (Read from Kafka and Store in Elasticsearch)
```bash
python consumer.py
```

### 7️⃣ Verify Data in Elasticsearch
```bash
curl -X GET "http://localhost:9200/twitter/_search?pretty=true"
```

### 8️⃣ Visualize Tweets in Kibana
1. Open **Kibana** at `http://localhost:5601`# Twitter Data Streaming with Apache Kafka, Elasticsearch, and Kibana

## Overview
This project streams real-time Twitter data using the **Twitter API**, processes it with **Apache Kafka**, stores it in **Elasticsearch**, and visualizes it in **Kibana**.

## Tech Stack
- **Apache Kafka** (for real-time data streaming)
- **Zookeeper** (Kafka dependency for managing metadata)
- **Twitter API** (for fetching tweets)
- **Elasticsearch** (for storing and indexing tweets)
- **Kibana** (for visualization)
- **Docker** (for containerization)
- **Python** (for Kafka producer and consumer scripts)

## Setup Instructions
### 1️⃣ Clone the Repository
```bash
git clone https://github.com/Pravesh-Sudha/twitter-streams.git
cd twitter-streams/
```

### 2️⃣ Start Docker Containers
#### Start Zookeeper
```bash
docker run -d --name zookeeper -p 2181:2181 zookeeper
```
#### Start Kafka
```bash
docker run -d --name kafka \
  --link zookeeper \
  -p 9092:9092 \
  -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
  -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092 \
  -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
  confluentinc/cp-kafka
```
#### Start Elasticsearch
```bash
docker run -d --name elasticsearch -p 9200:9200 -e "discovery.type=single-node" elasticsearch:7.17.10
```
#### Start Kibana
```bash
docker run -d --name kibana --link elasticsearch -p 5601:5601 kibana:7.17.10
```

### 3️⃣ Configure Twitter API Keys
Obtain API keys from [Twitter Developer Portal](https://developer.twitter.com/) and update `producer.py`:
```python
BEARER_TOKEN = "your_twitter_bearer_token"
```
![twiiter-token](https://github.com/user-attachments/assets/1f800030-0e29-4139-96cd-2129c8939ac6)


### 4️⃣ Create Kafka Topic
```bash
docker exec -it kafka kafka-topics --create --topic twitter-stream --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
```

### 5️⃣ Run the Producer (Fetch Tweets and Send to Kafka)
```bash
python producer.py
```

### 6️⃣ Run the Consumer (Read from Kafka and Store in Elasticsearch)
```bash
python consumer.py
```

### 7️⃣ Verify Data in Elasticsearch
```bash
curl -X GET "http://localhost:9200/twitter/_search?pretty=true"
```

### 8️⃣ Visualize Tweets in Kibana
1. Open **Kibana** at `http://localhost:5601`
2. Go to **Management → Stack Management → Index Patterns**
3. Create Index Pattern: **`twitter`**
4. Use **Discover** or **Visualizations** to explore tweets

## Features
✅ Fetches real-time tweets using **Twitter API**  
✅ Streams tweets to **Apache Kafka**  
✅ Stores tweets in **Elasticsearch**  
✅ Visualizes tweets using **Kibana**  
✅ Uses **Docker** for easy setup  

## Author
[Pravesh Sudha](https://github.com/Pravesh-Sudha)

## License
This project is licensed under the MIT License.


2. Go to **Management → Stack Management → Index Patterns**
3. Create Index Pattern: **`twitter`**
4. Use **Discover** or **Visualizations** to explore tweets

![viz](Visualizations.png)

## Features
✅ Fetches real-time tweets using **Twitter API**  
✅ Streams tweets to **Apache Kafka**  
✅ Stores tweets in **Elasticsearch**  
✅ Visualizes tweets using **Kibana**  
✅ Uses **Docker** for easy setup  

## Author
[Pravesh Sudha](https://github.com/Pravesh-Sudha)

## License
This project is licensed under the MIT License.

