public with sharing class MaterialLookupcontroller
{
    public Boolean renderResultSets{get;set;}
     //List variable to store all the Material
    public List<Material_Sales_Data2__c> materialresults{get;set;}
    public List<MaterialWrapper> theseMaterials{get;set;}
    public Boolean hasResults{get;set;}
   //String provided by user to get the simmilar Material in lookupdialog
    public String searchtext{get;set;}
    public MaterialLookupcontroller()
    {
        renderResultSets = false;
        hasResults = false;
        
        String stextParam = ApexPages.currentPage().getParameters().get('stext');
        if(stextParam!='' && stextParam!=null)
        {
            stextParam = String.escapeSingleQuotes(stextParam);
            querymaterial(stextParam);
        }
    }
    
    //Wrapper Class Definition
    public with sharing class MaterialWrapper
    {
        public Material_Sales_Data2__c thisMaterial {get; set;}
        public String matNumber {get; set;}
        public materialWrapper(Material_Sales_Data2__c tempMat)
        {
            thisMaterial = tempMat;
            matNumber = String_Functions.removeLeadingZeros(tempMat.Material_Number__c);
        }
    }
    //Function to fetch all the Material when user enters the simillar string or name.
    public void querymaterial(String searchtext)
    {
        String queryText = '%' + searchtext + '%';
        String accountId = ApexPages.currentPage().getParameters().get('accountId');
        Account soldToAccount;
        if(accountId != null && accountId != '')
        {
            theseMaterials = new List<MaterialWrapper>();
            soldToAccount = [Select a.SAP_Sales_Org__c, a.SAP_DistChannel__c, a.Id From Account a
                                    WHERE a.Id =: accountId];
        }        
        if(searchtext.contains('*'))
        {
            searchtext = searchtext.replace('*','');
        }
        if(soldToAccount != null)
        {
            materialresults = [Select Id, Name, SalesOrg_Desc__c, Material_Number__c, Material_Desc__c, DistChannel_Desc__c 
                                From Material_Sales_Data2__c where (Name like:queryText) 
                                AND (Sales_Org_Code__c =: soldToAccount.SAP_Sales_Org__c)
                                AND (Dist_Channel_Code__c =: soldToAccount.SAP_DistChannel__c)
                                order by Name desc LIMIT 1000];
        }
        if(materialresults != null)
        {
            for(Material_Sales_Data2__c thisMat : materialresults)
            {
                MaterialWrapper mw = new MaterialWrapper(thisMat);
                theseMaterials.add(mw);
            }
            if(materialresults.size()>0)
            {
                renderResultSets = true;
                hasResults = true;
            }
            else
            {
                renderResultSets = true;
                hasResults = false;
            }
        }
    }
    public PageReference fetchMaterials()
    {
        querymaterial(searchtext);
        return null;
    }
    
    //Test method for the apex class
    public static testmethod void testMaterialLookupController()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Account acc = new Account(Name = 'test account', SAP_DistChannel__c = '11', SAP_Sales_Org__c = '4321');
        insert acc;
        Material_Sales_Data2__c mat1 = new Material_Sales_Data2__c(Dist_Channel_Code__c = '11', Material_Number__c = '00000111111',
                                                                    Record_Key__c = '987654', Sales_Org_Code__c = '4321');
        insert mat1;
        
        PageReference pageRef = Page.MaterialLookup;
        pageRef.getParameters().put('stext',mat1.Material_Number__c);
        pageRef.getParameters().put('accountId',acc.Id);
        Test.setCurrentPage(pageRef);
        
        MaterialLookupcontroller matlookupcont=new MaterialLookupcontroller();
        matlookupcont.searchtext=mat1.Material_Number__c;
        matlookupcont.fetchMaterials();
       
        PageReference pageRef2 =Page.MaterialLookup;
        pageRef2.getParameters().put('stext','Testl*');
        pageRef.getParameters().put('accountId',acc.Id);
        Test.setCurrentPage(pageRef2);
        
        MaterialLookupcontroller matlookupcont1=new MaterialLookupcontroller();
        matlookupcont1.searchtext='Testl*';
        matlookupcont1.fetchMaterials();           
    }
}