trigger CalculateQuantityInMT on OpportunityLineItem (before insert, before update) 
{
    //Iterating thru all Opportunity Products inserted/updated
    for(OpportunityLineItem oppLineItem : Trigger.new)
    {
        //Calculation of Quantity in MT based on Unit Of Measure
        if(oppLineItem.UOM__c == 'KG')
        oppLineItem.Quantity_in_MT__c = oppLineItem.Quantity/1000;
        else oppLineItem.Quantity_in_MT__c = oppLineItem.Quantity/2204.6;
    }
}