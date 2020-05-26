/**
 * Converts the blacklisted word to regex for used in keyword filtering.
 * Author: Quinton Wall - qwall@salesforce.com
 */
trigger AddRegexTrigger on Blacklisted_Word__c (before insert, before update) {

    for (Blacklisted_Word__c f : trigger.new)
    {
          f.RegexValue__c = RegexHelper.toRegex(f.Word__c, f.Match_Whole_Words_Only__c);
    }
   
}