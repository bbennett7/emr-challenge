# README

PLAN MAP
"Silver Deductible Plan" - internal id: 2 - provider: Athena
  redox: { 
    source_plan_name: "Deductible Plan", 
    source_plan_id: "12345" 
  }
  providence health: { 
    source_plan_name: "High Deductible Plan", 
    source_plan_id: "12345" 
  }
  abm health: { 
    source_plan_name: "Tier 1 Plan", 
    source_plan_id: "372942" 
  }
"Global Plan" - internal id: 4 - provider: Blue Shield
  redox: { 
    source_plan_name: "XYZ Plan",
    source_plan_id: "27340-23" }
  providence health: { 
    source_plan_name: "ABC Plan", 
    source_plan_id: "48290370" }
  abm health: { 
    source_plan_name: "JKL Plan",
    source_plan_id: "2468921" 
  }

Notes:
- Can handle matches for one missing letter, one extra letter, or one wrong letter for human error in plan name, plan id, provider name, group name, member first name, member last name, or nickname (ie Alex Hamilton pulls up Alexander Hamilton)
- There is no logic to account for incorrect data - ie, no logic to account for the wrong provider listed with a plan
- New policy numbers need be 9 digits or less

WEBHOOK FLOW:
1. Post requests should be sent to /webhook-gateway
2. Requests must include a "Source" header with the name of the source (Redox, etc.)
3. /webhook-gateway routes to gateway method --> gateway calls handler for source --> handler manipulates data to uniform structure for creation methods --> get or create methods find or create provider, plan, group, policy and member (plan uses plan mapper to find corresponding plan on master list)

ADDING NEW SOURCES:
1. Add source to gateway switch statement
2. Create a handle_source_event function that manipulates payload into uniform structure (refer to comment: default structure of objects to build for db persistence)
3. Call new handler in new switch case
4. Add master plan data to DB and plan mapper

GIVEN MORE TIME, I WOULD:
- Add in an encryption/decryption mechanism for member SSN
- Improve error handling, further testing for edge cases
- Improve matching algorithm, accounting for situations such as Athena Health and Athens Health both being valid companies
- Add in a Redis DB to store "pending" (unmatched) payloads, give users option to manually handle/assign on frontend 
- Further abstract similar functionality into individual methods
