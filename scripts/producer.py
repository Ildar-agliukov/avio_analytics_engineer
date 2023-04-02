import os
from json import dumps
import requests
from kafka import KafkaProducer


producer = KafkaProducer(bootstrap_servers=[os.environ['KAFKA_HOST']],
                         key_serializer=lambda x: dumps(x).encode('utf-8'),
                         value_serializer=lambda x: dumps(x).encode('utf-8'))

def get_opensky_states() -> dict:
    """Get all states from OpenSky Network API"""
    path = 'https://opensky-network.org/api/states/all'
    request = requests.get(path, timeout=60).json()
    return request['states']

def send_to_kafka(states: dict) -> None:
    """Send states to Kafka"""
    producer.send('opensky', key='all_opensky_states', value=states)

if __name__ == '__main__':
    states: dict = get_opensky_states()
    send_to_kafka(states=states)
    print('Sent all states to Kafka')
