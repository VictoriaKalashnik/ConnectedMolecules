## "the message "X" from "Y" doesn't exist"

- send Get events request in Postman 
- make sure the response doesn't contain a record with payload = X and thingId = Y 

## "X" sends an event with message "Y"

- run command in commandline: 
```shell
node pubsub --endpoint "a15auxg78avhs5-ats.iot.eu-west-1.amazonaws.com" --cert "../certificate.pem" --key "../private.key" --ca "../AmazonRootCA1.pem" --topic "kalashnikviktoriia/events"  --message "Y" --thing "X" --count 1
```
## there are no events

- send Get events request in Postman
- if there are any records in the response send "Delete a single event" request in Postman for each timestamp in the response 
- send "Get events" request in Postman to make sure there are no events

## the message "X" from "Y" exists

- send Get events request in Postman
- make sure the response contains a record with payload = X and thingId = Y 
- note down the timestamp of the record (we will later refer to it as "current timestamp")

## the message with timestamp X doesn't exist

- send Get events request in Postman 
- make sure the response doesn't contain a record with timestamp = X

## thing-example-js is running with "X" topic

- run command in commandline: 
```shell
node pubsub --endpoint "a15auxg78avhs5-ats.iot.eu-west-1.amazonaws.com" --cert "../certificate.pem" --key "../private.key" --ca "../AmazonRootCA1.pem" --topic "X" --count 0
```


 