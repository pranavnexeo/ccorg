trigger RD_Requests_After on R_D_Requests__c (after insert, after update) {
  R_D_Object_Functions.ShareRDRequests(trigger.new);
}