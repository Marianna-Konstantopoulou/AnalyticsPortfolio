################################
##### Pipelines Assignment #####
################################
## Big Data Systems - Kafka ##
################################
# ---
# 
#Marianna Konstantopoulou
#P2822122
#MSc Business Analytics Part Time

#Define & create a KafkaAdminClient class:

admin_client = KafkaAdminClient(bootstrap_servers="localhost:9092", client_id='test')

#To create new topics, we first need to define an empty topic list:

topic_list = []

#Use the NewTopic class to create the topic (“clima”) & determine partition nums & replication factor.

new_topic = NewTopic(name="clima", num_partitions= 2, replication_factor=1)
topic_list.append(new_topic)

#View topic details:

configs = admin_client.describe_configs(
    config_resources=[ConfigResource(ConfigResourceType.TOPIC, "clima")])

#We will use KafkaProducer class for this (messages in JSON):

producer = KafkaProducer(value_serializer=lambda v: json.dumps(v).encode('utf-8'))

#Publish five example messages:

producer.send("clima", {'temperature':25, 'humidity':0.8, 'timestamp':'123344453'})
producer.send("clima", {'temperature':35, 'humidity':0.5, 'timestamp':'123345455'})
producer.send("clima", {'temperature':21, 'humidity':0.4, 'timestamp':'143344352'})
producer.send("clima", {'temperature':10, 'humidity':0.1, 'timestamp':'129898453'})
producer.send("clima", {'temperature':17, 'humidity':0.2, 'timestamp':'123035658'})

#Define & create a KafkaConsumer, subscribing to the topic ”clima”

consumer = KafkaConsumer('clima')

#Iterate & print the messages:

for msg in consumer:
    print(msg.value.decode("utf-8"))

