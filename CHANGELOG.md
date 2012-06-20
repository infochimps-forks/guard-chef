## Version 0.0.2++ -- updated for guard 1.x+

* Updated for Guard 1.1 method names
* Recognizes Yet Another way that chef says it succeeded -- modern knives say 'Uploaded 1 cookbook'; earlier versions were less quantified


## Version 0.0.2+  -- covers environments, data bags, etc

* Handles chef environments
* Uses knife for roles, cookbooks and environments
* Refactored jobs to share common code. 
* Recognizes paths like site-cookbooks/templates/default/x.erb and production-cookbooks/roles/foo.rb.
* More specs. 
