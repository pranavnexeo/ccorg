Global class unsubscribe implements Messaging.inboundEmailHandler{

Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
Messaging.InboundEnvelope env ) {

system.debug('Envelope: ' + env);
system.debug('Email: ' + email);
// Create an inboundEmailResult object for returning
// the result of the email service.
Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

// Create contact and lead lists to hold all the updated records.
List<Contact> lc = new List <contact>();
List<Lead> ll = new List <lead>();

// Convert the subject line to lower case so the program can match on lower case.
String mySubject = email.subject.toLowerCase();

// always unsubscribe, regardless of subject line or body content
Boolean unsubMe;
unsubMe = true;

 // Enter the IF statement.

 if (unsubMe == true) {

try {

// Look up all contacts with a matching email address.

for (Contact c : [Select Id, FirstName,Name, Email, HasOptedOutOfEmail
From Contact
Where Email = :email.fromAddress
And hasOptedOutOfEmail = false And FirstName!=null
Limit 1000]) {

// Add all the matching contacts into the list.
c.hasOptedOutOfEmail = true;
if(c.Email == null || c.Email == ''){
    c.No_Email__c = True;
}
lc.add(c);
}
// Update all of the contact records.
update lc;
}
catch (System.QueryException e) {
System.debug('Contact Query Issue: ' + e);
}

try {
// Look up all leads matching the email address.
System.debug('unsubscribe email address = ' + email.fromAddress);
for (Lead l : [Select Id, Name, Email, PostalCode, HasOptedOutOfEmail
From Lead
Where Email = :email.fromAddress
And isConverted = false
And hasOptedOutOfEmail = false
Limit 1000]) {
// Add all the leads to the list.
l.hasOptedOutOfEmail = true;
if (l.PostalCode != null) {
  if (l.PostalCode.length() > 10)
  {
    l.PostalCode = l.PostalCode.substring(0,9);
  }
}
      ll.add(l);

System.debug('Lead Object: ' + l);
}
// Update all lead records in the query.
update ll;
}

catch (System.QueryException e) {
System.debug('Lead Query Issue: ' + e);
}

System.debug('Found the unsubscribe word in the subject line.');
 }
 else {
System.debug('No Unsuscribe word found in the subject line.' );
 }
// Return True and exit.
// True confirms program is complete and no emails
// should be sent to the sender of the unsubscribe request.
result.success = true;
return result;
}

}