script to massage customer data in order to get it ready for import into Zendesk (using graham's tool)

for limelight:

1. run import_users.rb on file containing ALL users.  this will initiate the build of user.yaml

2. run import_agent.rb on file containing agent and groups. this will build user.yaml some more.

3. run export_tickets.rb on ticket file. this will generate tickets.csv

4. run export_tickets_comments.rb on ticket comment files.  this will generate ticket comments.csv

5. run export_groups.rb.  this will generate groups.csv

6. run export_users.rb.  this will generate users.csv
