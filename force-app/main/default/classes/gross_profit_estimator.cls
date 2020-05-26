global class gross_profit_estimator{

private static decimal getMatrixValue(string key){
  Map<String, Gross_Profit_Matrix__c> gp = Gross_Profit_Matrix__c.getAll();
  Map<String, Decimal> toreturn = new Map<String, Decimal>();
  for(Gross_Profit_Matrix__c gpm:gp.values())
    toreturn.put(gpm.selection_1__c + ':' + gpm.selection_2__c, gpm.value__c);
  return toreturn.get(key);
    
}

@RemoteAction
global static double getValue(boolean sf1, string type, string selection1, string selection2, string useragent){
  
  
  string key = selection1 + ':'+ selection2;
  decimal value = getMatrixValue(key);
  
  insert new Gross_Profit_Calculation__c(
    In_Salesforce1__c = sf1,
    Selection_1__c = selection1,
    Selection_2__c = selection2,
    type__c = type,
    user_Agent__c = useragent,
    value__c = value
  );
  return value;
}

}