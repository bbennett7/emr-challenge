# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


1. Clone repo
2. Run `bundle install` in the command line
3. rake eslint:run_all

WEBHOOK FLOW:
1. Post requests should be sent to /webhook-gateway
2. Requests must include a "Source" header with the name of the source (Redox, etc.)
3. /webhook-gateway routes to gateway method --> gateway calls handler for source --> handler manipulates data to uniform structure for creation methods --> creation methods find or create provider, plan, group, policy and member

ADDING NEW SOURCES:
1. Add source to gateway switch statement
2. Create a handle_source_event function that manipulates payload into uniform structure (refer to comment: default structure of objects to build for db persistence)
3. Call handler in new switch case

GIVEN MORE TIME, I WOULD:
- Add in an encryption/decryption mechanism for member SSN
- Improve error handling, further testing for edge cases
- Improve matching algorithm, accounting for situations such as Athena Health and Athens Health both being valid companies
- Add in a Redis DB to store "pending" (unmatched) payloads, give users option to manually handle/assign on frontend 
- Further abstract similar functionality into individual methods