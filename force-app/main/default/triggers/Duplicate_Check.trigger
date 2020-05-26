trigger Duplicate_Check on Site_RIM_Information__c (before insert){
List<id> parent_id = new List<id>();
for(Site_RIM_Information__c c : trigger.new)
{
parent_id.add(c.MainSitePick__c);
}
List<Site_RIM_Information__c> ls = [select id ,MainSitePick__c from Site_RIM_Information__c  where MainSitePick__c in :Parent_id]; 
set<id> clst = new set<id>();
for(Site_RIM_Information__c c:ls )
{
clst.add(c.MainSitePick__c);
}
for(Site_RIM_Information__c o : trigger.new)
{
if(clst.contains(o.MainSitePick__c))
o.adderror('This Site Name already using existing record, Please select other site Name');
}
}