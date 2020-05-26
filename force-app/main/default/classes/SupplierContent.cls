public class SupplierContent
{
    public string strSupplierName{get;set;}
    public string strSupplierId{get;set;}
    public List<ContentVersion> lstContent{get;set;}
    public SupplierContent()
    {
        strSupplierId = ApexPages.currentPage().getParameters().get('pid');
        lstContent = new List<ContentVersion>();
        
    }
    public pagereference Redirect()
    {
        id WSid;
        if(strSupplierId != null)
        {
            Nexeo_Competitor__c obj =[select id,name  from Nexeo_Competitor__c where id=:strSupplierId ];
            for(ContentWorkspace objW:[SELECT Id FROM ContentWorkspace WHERE Name = :obj.name])
            {
                WSid = objW.id;
            }
            system.debug('WSid=='+WSid);
           
        }
        //pagereference pg = new pagereference('/'+WSid);
        pagereference pg = new pagereference('/sfc/#search?searchWorkspaceIds=%5B%22'+WSid+'%22%5D&masterWorkspaceId='+WSid);

        pg.setredirect(true);
        return pg;
    }
     public pagereference RedirectManageContent()
    {
        id WSid;
         system.debug('strSupplierId=='+strSupplierId);
           
        if(strSupplierId != null)
        {
            Nexeo_Competitor__c obj =[select id,name  from Nexeo_Competitor__c where id=:strSupplierId ];
            for(ContentWorkspace objW:[SELECT Id FROM ContentWorkspace WHERE Name = :obj.name])
            {
                WSid = objW.id;
            }
            system.debug('WSid=='+WSid);
           
        }
        
        pagereference pg = new pagereference('/'+WSid);
        //pagereference pg = new pagereference('/sfc/#search?searchWorkspaceIds=%5B%22'+WSid+'%22%5D&masterWorkspaceId='+WSid);

        pg.setredirect(true);
        return pg;
    }
}