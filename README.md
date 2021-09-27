# ConnectedMolecules
The task was to do whatever a QA/test engineer would do when facing the system.

My approach was to:
- Create a test plan using Gherkin language (see [feature file](API.feature))
- Create a description of the steps mentioned in the test plan (see [API steps](API%20%steps.md))
- Perform the test run described by the test plan and document the results (see [API test run](API%20%test%20%run.md))

Few comments:
- As discussed with Çağrı, I've considered the [openapi](openapi.yml) file as source of truth. 
Even though it might makes sense for the endpoints to return `404 Not Found` and `400 Bad Request`, it wasn't mentioned in the file. That's why I "failed" some test cases, because technically the system was not behaving according to the documentation.
- I didn't provide descriptions for the steps that were more or less trivial
