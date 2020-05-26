trigger Donotallowrecordcreate on Closure_Specification_SubSection__c (before insert) {
Integer NumOfAtts=[select count() from Closure_Specification_SubSection__c where Container_Specification_Document__c=:Trigger.New[0].Container_Specification_Document__c];
//List<Bank_Information_document_scan__c> FormType = [select id, Select_Form_Type__c from Bank_Information_document_scan__c where id =:Trigger.New[0].ParentId];
 List<Closure_Specification_SubSection__c> atts = Trigger.new;
 for(Closure_Specification_SubSection__c a:atts) {
        if(NumOfAtts>5){
            a.addError('Only 6 records can be created for this Combination Container record.');
        }
        
    }
 }