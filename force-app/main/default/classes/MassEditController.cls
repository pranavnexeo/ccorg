public class MassEditController{

public List<sobject> records{Get; set;}
public string returl{get; set;}
public map<string, boolean> updateable{get; set;}

public MassEditController(apexpages.standardsetcontroller ssc){
  records = ssc.getselected();
  returl = apexpages.currentpage().getparameters().get('returl');
  Map<String,Schema.SObjectField> fmap = ssc.getRecord().getSobjectType().getDescribe().fields.getMap();
  updateable = new map<string, boolean>();
  for(string s:fmap.keyset())
  {
    system.debug(s);
    updateable.put(s.toUpperCase(), fmap.get(s).getDescribe().isupdateable());
  }
  
  
}
public PageReference masssave() {
    boolean success = true;
    try{
        update records;
       }
    catch(DmlException ex){
        ApexPages.addMessages(ex);
        success = false;
       }
    
    if(success)
    return new pagereference(returl);
    else
    return null;
  }

}