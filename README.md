script to massage customer data in order to get it ready for import into Zendesk (using graham's tool)

for tripadvisor:

1. run export_tickets.rb on csv file for tickets (from customer) - this will build user.yaml some more, and generate output files tickets.csv

2  run export_tickets_comments.rb.  this will generate ticket comments.csv

3. run export_organizations.rb.  this will generate organizations.csv

4. run export_groups.rb.  this will generate groups.csv

5. run export_users.rb.  this will generate users.csv
