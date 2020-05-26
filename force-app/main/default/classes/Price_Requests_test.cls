@isTest(SeeAllData=false)
public class Price_Requests_test{

 /*   public static testMethod void testMyController() {
        

        
        Date myDate = Date.Today();
        String today = '12/27/2009';        
        Account a = new Account(name = 'Test Account',sap_salesgroup__c = '1000',sap_city__c = 'Newyork');
        insert a;
        string acct = a.Id;
        List<Material_Sales_Data2__c> matlist = [select id,Name,Material_Group2_Desc__c,PH1_Division__c,PH2_Line__c,PH3_group__c,PH4_supplier__c,PH5_family__c,PH6_segment__c,PH7_subsegment__c,Material_Base_Code__c,material_Base_Code_Desc__c,Material_Group2_Code__c,material_group4_code__c from Material_Sales_Data2__c limit 1];
        Account_Material__c acmt = new account_material__c();
        acmt.account__c = acct;
        acmt.sap_material__c = matlist[0].id; 
        insert acmt;
        
        
        String acc = createAccountprice_Requests(); 
        String mat = createMaterial();
        
        Account_Material__c accmat = new account_material__c(Account__c = acc, SAP_Material__c = mat);
        insert accmat;
        Price_Request_Transaction__c p = new Price_Request_Transaction__c(Approval_Rejection_Comments__c = 'Comments',Account_Material__c = accmat.id);
        insert p;
        system.debug('$$$$$$$ p'+p.id);
        
        Price_Request_Transaction__c p1 = new Price_Request_Transaction__c(Account_Material__c = accmat.id, approval_status__c = 'Draft');
        insert p1;
        system.debug('$$$$$$$ p'+p1.id);
        
        Price_Requests cont = new Price_Requests();
        cont.getcurrentrequestssize();
        String pId = (String)p.Id;
        Map<String, Price_Request_Transaction__c> amap = new Map<String, Price_Request_Transaction__c>();
        amap.put(pid,p);
        
        Map<String, Price_Request_Transaction> objmap = new Map<String, Price_Request_Transaction>();
        Price_Request_Transaction__c transrecord = new Price_Request_Transaction__c(Unit_Conversion_Data__c = '12;23;45',requested_effective_date__c = Date.today(),Approval_Rejection_Comments__c = 'Comments',type__c = 'CSP',Approval_Level__c = 'Exception 1',approval_status__c = 'Draft',SAP_Material__c = matlist[0].id, sap_material__r = matlist[0],ship_to__r = a,ship_to__c = acct,account_material__r = acmt,account_material__c = acmt.id);
        insert transrecord;
        
        Map<String, Price_Request_Transaction__c> amap1 = new Map<String, Price_Request_Transaction__c>();
        amap1.put(transrecord.Id,transrecord);
        
        
        Price_Request_Transaction pTran = new Price_Request_Transaction(transrecord);
       
        SAP_Price__c sp = new SAP_Price__c(Price_Request_Transaction__c = transrecord.Id, Type__c = 'Requested');
        insert sp;
        
        SAP_Price_Tier__c spt = new SAP_Price_Tier__c(effective_date__c = myDate ,SAP_Price__c = sp.Id, CurrencyIsoCode = 'USD');
        insert spt;
        
        SAP_Price__c sp1 = new SAP_Price__c(Price_Request_Transaction__c = transrecord.Id, Type__c = 'Request');
        insert sp1;
        
        SAP_Price_Tier__c spt1 = new SAP_Price_Tier__c(effective_date__c = myDate ,SAP_Price__c = sp.Id, CurrencyIsoCode = 'CAD');
        insert spt1;
        
        List<SAP_Price_Tier__c> sptList = new List<SAP_Price_Tier__c>();
        sptList.add(spt);
        
        sptList.add(spt1);
        
        Sap_Price sapPrice = new Sap_Price();
        Sap_Price sapPrice1 = new Sap_Price();
        sapPrice.SAP_Price = sp;
        sapPrice.SAP_Tiers = sptList;
        
        sapPrice1.SAP_Price = sp1;
        sapPrice1.SAP_Tiers = sptList;
                
        pTran.List_Prices = sapPrice;
        pTran.CSP_Prices = sapPrice;
        pTran.Target_Prices = sapPrice1;
        pTran.Requested_Tiers = sapPrice1;
        pTran.Requested_Tiers.SAP_Tiers.clear();
        pTran.Requested_Tiers.SAP_Tiers.add(spt1);
        
        update transrecord;
        apexpages.currentpage().getparameters().put('cid', 'cform-acct=' + acc + 'cform-firstname=Matthew&cform-lastname=Rumschlag&cform-email=mjrumschlag@nexeosolutions.com');
        cont.savecontact();
        cont.FetchUnits(pTran);
        Price_Requests.FetchUnitOptions(pTran);
       // cont.FetchSimulateWindow(pTran); 
        
        objmap.put('' + acct + matlist[0].id, pTran);
                
     
       // Price_Requests.gettheform(pTran, '', '', false);
       // Price_Requests.getcombogriddata('', 'Account', 'name', '', 'Name', '5');
       // Price_Requests.getusstates();
       // Price_Requests.getAccountIndustryFilters();
        
        Price_Requests.getAccountDivisionFilters();
        //Price_Requests.getCurrencies();
        //Price_Requests.getscompetitors();
        //Price_Requests.getPriceProtection();
        List<PH6_PH7__C> phs = PH6_PH7__c.getall().values();
        string ph6 = 'test PH7';
        if(phs.size() > 0)
          ph6 = phs.get(0).ph6__c;
       // cont.getPH6();
       // cont.FetchPH7(ph6);   
        
        Account_material__c am1 = new Account_Material__c(Account__C = '001E000000CTuUXIA1', SAP_Material__c = 'a0eE0000000Uju1IAC');
        insert am1;
        ApexPages.currentpage().getparameters().put('rid', 'SelectedRow=001E000000CTuUXIA1a0eE0000000Uju1IAC');
                                                          
       // cont.savepriceletter();
        string plform = 'plemails=mjrumschlag%40nexeosolutions.com&plsubject=test&plbody=test';
        apexpages.currentpage().getparameters().put('plform', plform);
      //  cont.sendpriceletter();
          
        String mimi =  '1=a&2=b';
        ApexPages.currentpage().getparameters().put('mimi',mimi);
       // cont.submitmimiform();
        
        
   //     cont.field6changed();
   //     cont.field7changed();
        price_Requests.getemptyformtable();
        price_Requests.getemptypendingentry();
        price_Requests.getemptypricelettertable();
        price_Requests.getemptypendingtable();
       // price_Requests.getemptyhistorytable();
        price_Requests.getemptyaudittable();
        price_Requests.getemptyquotetable();
        price_Requests.getemptyapprovalstable();

        String am = 'amform-acct='+acc+'&amform-material='+mat;
        ApexPages.currentpage().getparameters().put('am',am);
   //     cont.saveaccountmaterial();
        
        cont.updatePricingTable();
        
       cont.currentrequests = new list<Price_Request_Transaction>{ptran};
       ApexPages.currentpage().getparameters().put('rid', 'SelectedRow=001E000000CTuUXIA1' + am1.id);
      // cont.ShowForm();
       string sForm = 'effdate=11%2F24%2F2012&exdate=11%2F24%2F2013&currency=USD&pricetype=CSP&drdep=No&bracketvolume=1&brvoluom=DR&bracketprice=1&brpriceuom=DR&ordervol=1&ordervoluom=DR&competitorid=a1DE00000008asqMAA&obtainedfrom=Customer+-+Verbal&competitorprice=1.0000&compvoluom=DR&priceprot=Z0+-+No+Protection&comments=test';
       ApexPages.currentpage().getparameters().put('sForm',sForm);
     //  cont.simulateForm();
       //cont.saveandsubmitform();
        
        String rid= 'SelectedAudit='+p.Id+'&'; 
        ApexPages.currentpage().getparameters().put('rid',rid);
       // cont.ReleaseSelected();
        
        rid= 'SelectedRow='+acct + matlist[0].id+'&'; 
        ApexPages.currentpage().getparameters().put('rid',rid);
        sForm = 'currency=USD&comments=test&effdate='+today+'&exdate='+today+'&pricetype=test&bracketvolumee=test&brvoluome=test&brpriceuome=test&bracketpricee=test&upordowne=test';
        ApexPages.currentpage().getparameters().put('sForm',sForm);
        
        Set<String> sAIDs = new Set<String>();
        sAIDs.add(acct);
        cont.sAIDs = sAIDs;
        
        Map<id, Material_Sales_Data2__c> materialmap = new Map<id, Material_Sales_Data2__c>();
        materialmap.put(matlist[0].id,matlist[0]);

        rid= 'SelectedRow='+transrecord.Id; 
        ApexPages.currentpage().getparameters().put('rid',rid);
        
        Map<String, List<SAP_Price_Tier__c>> audit_request_tiers_map =new Map<String, List<SAP_Price_Tier__c>>();
        List<SAP_Price_Tier__c> listspt= new List<SAP_Price_Tier__c>();
        listspt.add(spt);
        audit_request_tiers_map.put(transrecord.Id,listspt);
        
        rid= 'SelectedRow='+acct+matlist[0].id+'&'; 
        ApexPages.currentpage().getparameters().put('rid',rid);
       // cont.ShowForm2();
           
        ApexPages.currentpage().getparameters().put('apprids','SelectedAudit='+transrecord.Id+'&');
        
        cont.setapprovalids();
  //    cont.approverecords();
    //  cont.rejectrecords();
        
        
        ApexPages.currentpage().getparameters().put('closerows','SelectedAudit='+transrecord.Id+'&');
    //    cont.CloseRecords();
       //   cont.FetchPendingEntry();
            

           // Price_Requests.getemptypricingtable();
           // cont.getmaterialdata(matlist[0]);
            String units = '5';
           // cont.getstaticpriceform(units, sptList);
           // cont.getincrementalform(sptList);
            Price_Requests.getemptyaccounttable();
            
            Price_Letter__c pl = new Price_Letter__c(Customers__c = 'abc');
            insert pl;
            Price_Letter_Item__c pi = new Price_Letter_Item__c(Account_Material__c = accmat.id,Price_Letter__c = pl.id, CSP_Tiers__c = sp.Id, Quote_Tiers__c = sp.Id );
            insert pi;
            update pl;
            
            string f='plemails=fake%40email.com&plsubject=test&plbody=test';
            cont.price_letter_id = pl.id;
            ApexPages.currentPage().getParameters().put ('plForm', f);
            cont.sendpriceletter();
            
            String mimiacctid = createAccountprice_Requests();

            string mimifilter = 'account-id=' + mimiacctid + '&material-id=' + mat;
            ApexPages.currentpage().getparameters().put('pagenum', '0');
            ApexPages.currentpage().getparameters().put('mimi', mimifilter);
            //cont.submitmimiform();

            cont.generateapprovalsmap();
            cont.generatependingmaps(userinfo.getuserid());
            cont.currentrequests.clear();
            cont.currentrequests = new List<Price_Request_transaction>{new Price_Request_Transaction(transrecord)};
            cont.savepricerequest(true);
            Price_Requests.getemptypricingtable();
            combogriddata objs = Price_Requests.getComboGridData('test', 'Account', 'name', '', 'name', '1');
            set<string> ids = new set<string>();
            //Price_Requests.Lookup_Related_Accounts(ids);
         
    }
    
    public static String createAccountprice_Requests(){
        Account a = new Account(name = 'Test Account');
        insert a;
        return a.Id;
    }
    
    public static  String createMaterial(){
        Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');
        insert m;
        return m.Id;
    }
*/
}