trigger CC_nex_invoice_trigger on ccrz__E_Invoice__c (after insert) 
{
	if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
    	{
            cc_nex_Invoice.update_SAPinvoice_in_ccorder(Trigger.New);
        }
    }
}