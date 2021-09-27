Feature: Thingy API

Scenario: Sending event and expecting it to show up in the list
Given API key is valid
And  the message "Error" from "kalashnikviktoriia" doesn't exist
When "kalashnikviktoriia" sends an event with message "Error" 
And getEvents is called
Then result is 200
And result contains the message "Error" from "kalashnikviktoriia" with valid timestamp

Scenario: Sending event with invalid API key
Given API key is invalid
When getEvents is called 
Then result is 401

Scenario: Get events returns multiple events
Given API key is valid 
And there are no events 
When "kalashnikviktoriia" sends an event with message "Error" 
And "kalashnikviktoriia" sends an event with message "Off"
And "kalashnikviktoriia" sends an event with message "Sleep"
And getEvents is called 
Then result is 200 
And result contains 3 messages 
And result contains the message "Error" from "kalashnikviktoriia" with valid timestamp
And result contains the message "Off" from "kalashnikviktoriia" with valid timestamp
And result contains the message "Sleep" from "kalashnikviktoriia" with valid timestamp

Scenario: Deleting event and expecting it is not shown in the list
Given API key is valid
And the message "Sleep" from "kalashnikviktoriia" exists
# here we assume that previous step saves the timestamp 
When deleteEvent is called with current timestamp 
Then result is 204 
When getEvents is called
Then result is 200
And result does not contain the message "Sleep" from "kalashnikviktoriia"

Scenario: Deleting nonexisting event 
Given API key is valid
And the message with timestamp 19150201 doesn't exist
When deleteEvent is called with 19150201 timestamp
Then result is 500

Scenario: Deleting an event with invalid credentials 
Given API key is invalid
When deleteEvent is called with 19150201 timestamp
Then result is 401 

Scenario: Sending command 
Given API key is valid
And thing-example-js is running with "kalashnikviktoriia/commands" topic 
When postCommand is called with body {"Thing":"ThermostatA","command":"Turn off"}
Then result is 200 
And {"Thing":"ThermostatA","command":"Turn off"} appears in the terminal

Scenario: Sending invalid command
Given API key is valid
And thing-example-js is running with "kalashnikviktoriia/commands" topic
When postCommand is called with body {"Thing":"ThermostatA","command":"Turn off"
Then result is 500 
And {"Thing":"ThermostatA","command":"Turn off" doesn't appear in the terminal

Scenario: Sending a command with invalid credentials
Given API key is invalid
And thing-example-js is running with "kalashnikviktoriia/commands" topic
When postCommand is called with body {"Thing":"ThermostatA","command":"Turn off"}
Then result is 401
And {"Thing":"ThermostatA","command":"Turn off"} doesn't appear in the terminal

# Scenario: Spamming with requests to check performance 
# Would be nice to load test all endpoints 

