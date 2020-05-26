Global class resubscribe implements Messaging.inboundEmailHandler{

Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
Messaging.InboundEnvelope env ) {

// Create an inboundEmailResult object for returning
// the result of the email service.
Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

// Create contact and lead lists to hold all the updated records.
List<Contact> lc = new List <contact>();
List<Lead> ll = new List <lead>();

// Convert the subject line to lower case so the program can match on lower case.
String mySubject = email.subject.toLowerCase();

// always unsubscribe, regardless of subject line or body content
Boolean resubMe;
resubMe = true;

 // Enter the IF statement.

 if (resubMe == true) {

try {

// Look up all contacts with a matching email address.

for (Contact c : [Select Id,FirstName, Name, Email, HasOptedOutOfEmail
From Contact
Where Email = :email.fromAddress
And hasOptedOutOfEmail = true And FirstName !=null 
Limit 1000]) {

// Add all the matching contacts into the list.
c.hasOptedOutOfEmail = false;
if(c.Email == null || c.Email == ''){
    c.No_Email__c = true; // Added by Abhishek on 4Sept2013
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
for (Lead l : [Select Id, Name, Email, HasOptedOutOfEmail
From Lead
Where Email = :email.fromAddress
And isConverted = false
And hasOptedOutOfEmail = true
Limit 1000]) {
// Add all the leads to the list.
l.hasOptedOutOfEmail = false;
ll.add(l);

System.debug('Lead Object: ' + l);
}
// Update all lead records in the query.
update ll;
}

catch (System.QueryException e) {
System.debug('Lead Query Issue: ' + e);
}

}// end if

// Return True and exit.
// True confirms program is complete and no emails
// should be sent to the sender of the unsubscribe request.
result.success = true;
return result;
}


}