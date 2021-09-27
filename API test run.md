Scenario: Sending event and expecting it to show up in the list
Test result: pass 

Scenario: Sending event with invalid API key
Test result: Pass

Scenario: Get events returns multiple events
Test result: Pass

Scenario: Deleting event and expecting it is not shown in the list
Test result: Pass

Scenario: Deleting nonexisting event
Test result: Fail
Actual result: 404 Not Found 
Comment: as we consider openapi.yml to be a source of truth 404 is not expected

Scenario: Deleting an event with invalid credentials 
Test result: Pass

Scenario: Sending command 
Test result: Pass

Scenario: Sending invalid command
Test result: Fail
Actual result: 400 Bad request
Comment: as we consider openapi.yml to be a source of truth 400 is not expected

Scenario: Sending a command with invalid credentials
Test result: Pass

