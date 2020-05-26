global with sharing class AccountMaterial_Information{

Public Price_Request_Transaction__c prtInfo;
Public Account_Material__c amInfo;
Public String amId;
Public List<SAP_Price_Tier__c> reqTier;
Public String prtId;
Public String prtName {Get; Set;}
Public String prtType {Get; Set;}
Public String prtAppComments {Get; Set;}
Public String ApprOptions{Get; set;}

public AccountMaterial_Information(apexpages.standardcontroller sc){
  //prtId = Apexpages.currentpage().getparameters().get('Id');
  //amId = Apexpages.currentpage().getparameters().get('Id');
  amId = sc.getrecord().id;
  //reqTier = getReqTier();
  String qstring = 'Select Approver_Name__c, Approver__c from Price_Request_Approver__c where User_Is_Active__c = \'true\' '; 
  List<Price_Request_Approver__c> dupprtrecords = database.query(qstring); 
  List<Price_Request_Approver__c> distinctprtrecords = new List<Price_Request_Approver__c>();
  
  for(Price_Request_Approver__c record: dupprtrecords ){
        Boolean found = false;
        for(Price_Request_Approver__c disrecord: distinctprtrecords ){
            if(record.Approver_Name__c == disrecord.Approver_Name__c ){
                found=true;
                break;
            }
        }
        if(!found)
            distinctprtrecords.add(record);
    }

    ApprOptions='';
    for(integer i=1; i<distinctprtrecords.size();i++)
    {
           if(i>1)   
            ApprOptions += '<li> <a href="#">' + distinctprtrecords[i].Approver_Name__c + ' </a> </li>';
    
    
    }
  
}

/*
public Price_Request_Transaction__c getPRTInfo(){
  prtInfo = [Select Name, Id, Account_Material__c, Account_Material__r.Name, Account_Material__r.Account__c, Account_Material__r.SAP_Material__c, Type__c, Ship_To__r.Owner.Name, Comments__c from Price_Request_Transaction__c where id =: prtId];
 return prtInfo;
} */

public Account_Material__c getAccountMaterial(){
  amInfo = [Select Id, Name, Account__c, SAP_Material__c from Account_Material__c where Id = :amId];
return amInfo;
}

/*
public List<SAP_Price_Tier__c> getReqTier(){
  reqTier=[Select Effective_Date__c, Expiration_Date__c, Volume__c, Volume_UoM__c, Price__c, Price_UoM__c, SAP_Price__r.Type__c from SAP_Price_Tier__c where Price_Request_Transaction_Number__c =:prtId and SAP_Price__r.Type__c = 'Requested'];
 return reqTier;
}*/

@RemoteAction
    global static List<Price_Request_Approver__c> getApproversList(){ 

        String qstring = 'select Approver_Name__c, Approver__c from Price_Request_Approver__c where User_Is_Active__c = \'true\' ';
        //qstring += query; 
        system.debug('qstring:'+qstring );
        List<Price_Request_Approver__c> dupprtrecords = database.query(qstring); 
        List<Price_Request_Approver__c> distinctprtrecords = new List<Price_Request_Approver__c>();
       system.debug('dupprtrecords:'+dupprtrecords);
        for(Price_Request_Approver__c record: dupprtrecords ){
            Boolean found = false;
            for(Price_Request_Approver__c disrecord: distinctprtrecords ){
                if(record.Approver_Name__c == disrecord.Approver_Name__c ){
                    found=true;
                    break;
                }
            }
            if(!found)
                distinctprtrecords.add(record);
        }
    
        return distinctprtrecords;

}


}