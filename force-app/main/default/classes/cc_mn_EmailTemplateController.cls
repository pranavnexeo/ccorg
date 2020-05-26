public class cc_mn_EmailTemplateController {

    public string Receiving_User_FirstName    {get;set;}
    public string Receiving_User_LastName     {get;set;}
    public string Receiving_User_Email        {get;set;}
    public string Community_Url               {get;set;}
    public string userLocale                  {get;set;}
    public string BuyerName_FirstName         {get;set;}
    public string BuyerName_LastName          {get;set;}
    public string Contact_FirstName           {get;set;}
    public string Contact_LastName            {get;set;}
    public string User_FirstName              {get;set;}
    public string User_LastName               {get;set;}
    public string ContactId                   {get;set;}
    public string ContactFirstName            {get;set;}
    public string ContactLastName             {get;set;}
    public string OrderId                     {get;set;}
    
    public string userLocale1{ 
        public get {return setUpCompleteLoad();} 
        public set; 
       // return setUpCompleteLoad();
    }
    
    public cc_mn_EmailTemplateController(){
        setUpCompleteLoad();
    }
    
    public string setUpCompleteLoad() {
        Try{
            userLocale = [select LocaleSidKey from user where ContactId=:ContactId Limit 1].LocaleSidKey;
        }Catch(exception e){}
        
        If(userLocale == null || userLocale == ''){
            userLocale = 'en_US';
        }    
        return userLocale;
    }
    
    public String getReceiving_User() {
        return null;
    }

}