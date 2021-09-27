Feature: Thingy API

Scenario: Sending event and expecting it to show up in the list
Given API key is valid
And  the message "On" from "Terminal123" doesn't exist
When "Terminal123" sends an event with message "On" 
And getEvents is called
Then result is 200
And result contains the message "On" from "Terminal123" with valid timestamp

Scenario: Sending event and expecting it to show up in the list
Given API key is invalid
When getEvents is called 
Then result is 401

Scenario: Get events returns multiple events
Given API key is valid 
And there are no events 
When "Terminal1" sends an event with message "On" 
And "Terminal2" sends an event with message "Off"
And "Terminal3" sends an event with message "Sleep"
And getEvents is called 
Then result is 200 
And result contains 3 messages 
And result contains the message "On" from "Terminal1" with valid timestamp
And result contains the message "Off" from "Terminal2" with valid timestamp
And result contains the message "Sleep" from "Terminal3" with valid timestamp

Scenario: Deleting even and expecting it is not shown in the list
Given API key is valid
And the message "Hot" from "ThermostatA" exists
# here we assume that previous step saves the timestamp 
When deleteEvent is called with current timestamp 
Then result is 204 
When getEvents is called
Then result is 200
And result does not contain the message "Hot" from "ThermostatA"

Scenario: Deleting nonexisting event 
Given API key is valid
And the message with timestamp 19150201 doesn't exist
When deleteEvent is called with 19150201 timestamp
Then result is 500

Scenario: Deleting an even with invalid credentials 
Given API key is invalid
When deleteEvent is called with 19150201 timestamp
Then result is 401 

Scenario: Sending command 
Given API key is valid
And thing-example-js is running with "kalashnikviktoriia/commands" topic 
When postCommand is called with body "{\"Thing\":\"ThermostatA\",\"command\":\"Turn off\"}"
Then result is 200 
And "{\"Thing\":\"ThermostatA\",\"command\":\"Turn off\"}" appears in the terminal

Scenario: Sending invalid command
Given API key is valid
And thing-example-js is running with "kalashnikviktoriia/commands" topic
When postCommand is called with body "{\"Thing\":\"ThermostatA\",\"command\":\"Turn off\""
Then result is 500 
And "{\"Thing\":\"ThermostatA\",\"command\":\"Turn off\"}" doesn't appear in the terminal

Scenario: Invalid credentials
Given API key is invalid
And thing-example-js is running with "kalashnikviktoriia/commands" topic
When postCommand is called with body "{\"Thing\":\"ThermostatA\",\"command\":\"Turn off\"}"
Then result is 401
And "{\"Thing\":\"ThermostatA\",\"command\":\"Turn off\"}" doesn't appear in the terminal

# Spamming with requests
# Would be nice to load test all endpoints 
