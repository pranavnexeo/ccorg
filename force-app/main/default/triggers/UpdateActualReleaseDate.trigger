trigger UpdateActualReleaseDate on ART_Release__c (after insert, after update) {

GenerateReleaseFromRequests.updateactualreleasedateonrequest(trigger.new);  
}