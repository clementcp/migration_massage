script to massage customer data in order to get it ready for import into Zendesk (using graham's tool)

for medidata:

1. run import_agent.rb - this will build user.yaml some more, listing special agents where tickets are required

2. run export_tickets.rb.  this will generate tickets.csv

3. run export_tickets_comments.rb.  this will generate ticket comments.csv

4. run export_groups.rb.  this will generate groups.csv

5. run export_users.rb.  this will generate users.csv
