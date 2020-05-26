global class cc_mn_ProfilesController {
public String email {get; set;}
   // public String extendedLifeCycleReportsJSON {get; set;}
    public list<WrapProfile> lstWrapprofile{get;set;}
    public cc_mn_ProfilesController()
    {
     /*  user u =[select id,contactid from user where id =:userinfo.getuserid()];//'00544000007xkh3'
       contact con = new contact();
       if(u.contactid != null)
           con = [select id,account.AccountNumber from contact where id =:u.contactid];
       */    
       lstWrapprofile= new list<WrapProfile>();
       string strAcid='';
       if(test.isRunningtest())
       {
          strAcid ='abcd12'; 
       }
       else
       {
           strAcid=ccrz.cc_CallContext.entAccount.AccountNumber;
           //strAcid=con.Account.AccountNumber;
       }
         //system.debug('test=='+con.Account.AccountNumber);
         if(strAcid != null)
         {
            list<cc_mn_json_ProfileResponse> lstR = FetchProfileDetail(strAcid);
            if(lstR != null)
            {
                for(cc_mn_json_ProfileResponse obj :lstR)
                {
                    lstWrapprofile.add(new WrapProfile(obj.profile,obj.profile_desc,obj.appr_exp_date,obj.specification,obj.disposer_name ));
                    
                } 
            }
        }
         system.debug('lstWrapprofile=='+lstWrapprofile);
       
    }
    
    public list<cc_mn_json_ProfileResponse>  FetchProfileDetail(string accountid)
    {
        try
        {
                Account acc= new account();
                if(test.isrunningtest())
                {
                    acc.SAP_Sales_Org__c='34321';
                    acc.SAP_DistChannel__c='34321';
                    acc.SAP_DivisionCode__c  ='34321';
                    
                   // response.document='test';
                }
                else
                {
                    for(account a :[select id,SAP_Customer_Number__c,SAP_Sales_Org__c,SAP_DistChannel__c ,SAP_DivisionCode__c    from account where AccountNumber=:accountid])
                    {
                        acc =a;
                    }
                }
        
            list<cc_mn_json_ProfileResponse> lstResponse = new list<cc_mn_json_ProfileResponse>();
            cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('mynexeo');
            Http http = new Http();
            HttpRequest httpRequest = new HttpRequest();
            system.debug('httpRequest=='+httpRequest);
            
            String endpointPath = storefrontSettings.ProfilePath__c;
            
            List<WrapRequest> wrpReq = new List<WrapRequest>();
            WrapRequest objR = new WrapRequest();
            objR.CUSTOMER= accountid;//acc.SAP_Customer_Number__c;
            objR.SALES_ORG = acc.SAP_Sales_Org__c;
            objR.DISTR_CHAN = acc.SAP_DistChannel__c;
            objR.DIVISION = acc.SAP_DivisionCode__c;
            wrpReq.add(objR);
           // String formattedRequestBody =  '[{"CUSTOMER":"'+accountid+'"}]';
            
            String formattedRequestBody =  JSON.serialize(wrpReq,true);
            system.debug('body'+formattedRequestBody);
            
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setBody(formattedRequestBody);
            httpRequest.setendpoint('callout:Nexeo_SAP_Endpoint/'+ endpointPath);
            httpRequest.setMethod('GET');
            httpRequest.settimeout(60000);
            system.debug('httpRequest=='+httpRequest);
            
            HttpResponse httpResponse = http.send(httpRequest);
            system.debug('httpResponse::'+httpResponse);
            string responseBody = httpResponse.getBody();
            system.debug('httpResponse.StatusCode::'+responseBody);
            if (String.isNotBlank(httpResponse.getBody()) && httpResponse.getStatusCode() == 200) 
            {
                responseBody = httpResponse.getBody().unescapeEcmaScript();
                lstResponse = cc_mn_json_ProfileResponse.parse(responseBody);   
            }
            return lstResponse;
            }
        Catch(Exception e){return null;}

    }
    public class WrapRequest
    {
        public string CUSTOMER;
        public string SALES_ORG;
        public string DISTR_CHAN;
        public string DIVISION;
    }
    public class WrapProfile 
    {
        public string strPName{get;set;}
        public string strPDesc{get;set;}
        public date expDate{get;set;}
        public string strProfileId{get;set;}
        public string strDisposerName{get;set;}
        public WrapProfile(string strpN,string strpD,string eD,string strprId,string dispName)
        {
            strPName =strpN;
            strPDesc = strpD;
            strDisposerName = dispName;
            system.debug('ed==='+ed);
            if(eD != null && ed.length()>7)
            {
                string year = ed.substring(0,4);
                string mon = ed.substring(4,6);
                string day = ed.substring(6,8);
                system.debug('expDate ==='+year +'=='+mon+'=='+day );
                expDate =  Date.newInstance(integer.valueof(year),integer.valueof(mon),integer.valueof(day));
            }
           
            strProfileId = strprId;
        }
        
        
    }
       
}