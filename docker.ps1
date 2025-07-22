# Clean up old containers
docker rm -f zookeeper kafka elasticsearch kibana
docker network rm kafka-elk-network 2>$null

# Create network
docker network create kafka-elk-network

# Start Kafka in KRaft mode (no Zookeeper needed)
docker run -d --name kafka `
  --network kafka-elk-network `
  -p 9092:9092 `
  -e KAFKA_NODE_ID=1 `
  -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT `
  -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:19092,PLAINTEXT_HOST://localhost:9092 `
  -e KAFKA_PROCESS_ROLES=broker,controller `
  -e KAFKA_CONTROLLER_QUORUM_VOTERS=1@kafka:29093 `
  -e KAFKA_LISTENERS=PLAINTEXT://kafka:19092,CONTROLLER://kafka:29093,PLAINTEXT_HOST://0.0.0.0:9092 `
  -e KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT `
  -e KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER `
  -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 `
  -e KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 `
  -e KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 `
  -e KAFKA_AUTO_CREATE_TOPICS_ENABLE=true `
  -e CLUSTER_ID=MkU3OEVBNTcwNTJENDM2Qk `
  -e KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0 `
  confluentinc/cp-kafka:latest

# Start Elasticsearch
docker run -d --name elasticsearch `
  --network kafka-elk-network `
  -p 9200:9200 `
  -e "discovery.type=single-node" `
  -e "xpack.security.enabled=false" `
  -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" `
  elasticsearch:7.17.10

# Start Kibana
docker run -d --name kibana `
  --network kafka-elk-network `
  -p 5601:5601 `
  -e "ELASTICSEARCH_HOSTS=http://elasticsearch:9200" `
  kibana:7.17.10

# Wait for services to start
Write-Host "Waiting for services to start..."
Start-Sleep -Seconds 30

# Check container status
Write-Host "Container Status:"
docker ps

# Wait a bit more for Kafka to be fully ready
Write-Host "Waiting for Kafka to be fully ready..."
Start-Sleep -Seconds 15

# Create Kafka topic
Write-Host "Creating Kafka topic..."
docker exec kafka kafka-topics `
  --create `
  --topic twitter-stream `
  --bootstrap-server localhost:9092 `
  --partitions 1 `
  --replication-factor 1

# Verify topic creation
Write-Host "Verifying topic creation:"
docker exec kafka kafka-topics `
  --list `
  --bootstrap-server localhost:9092

# Test Kafka connectivity
Write-Host "Testing Kafka connectivity..."
docker exec kafka kafka-broker-api-versions --bootstrap-server localhost:9092

Write-Host "Setup complete! Services should be available at:"
Write-Host "- Kafka: localhost:9092"
Write-Host "- Elasticsearch: http://localhost:9200"
Write-Host "- Kibana: http://localhost:5601"