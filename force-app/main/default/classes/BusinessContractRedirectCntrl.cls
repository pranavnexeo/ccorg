public without sharing class BusinessContractRedirectCntrl {
    public Business_Contract__c busCont{get;set;}
    public Id adBusConRecordTypeId;
    public Boolean isClone{get; set;}
    public BusinessContractRedirectCntrl(ApexPages.StandardController stdcontroller){
        adBusConRecordTypeId = Schema.SObjectType.Business_Contract__c.getRecordTypeInfosByName().get('AD Business Contract').getRecordTypeId();
        busCont = (Business_Contract__c) stdController.getRecord();
        String clone = ApexPages.currentPage().getParameters().get('clone');
        if(clone == '1')
            isClone = true;
        else
            isClone = false;
    }
    public PageReference redirect(){
        if(busCont.id == null){
            List<Schema.RecordTypeInfo> infos = Schema.SObjectType.Business_Contract__c.RecordTypeInfos;
            Id defaultRecordTypeId;
            system.debug('------------------------------'+busCont.recordTypeId);
            if(busCont.recordTypeId != null){
                if(busCont.recordTypeId != adBusConRecordTypeId){
                    String prefix = Business_Contract__c.SObjectType.getDescribe().getKeyPrefix();
                    String param = getParameters();
                    return new PageReference('/'+prefix+'/e?nooverride=1&'+param); 
                }
                else{
                    return new pagereference('/apex/BusinessContractPage');
                }
            }
            else if(busCont.recordTypeId == null){
                for (Schema.RecordTypeInfo info : infos) {
                      if (info.DefaultRecordTypeMapping) {
                        defaultRecordTypeId = info.RecordTypeId;
                      }
                }
                
                if(defaultRecordTypeId != adBusConRecordTypeId){
                    String prefix = Business_Contract__c.SObjectType.getDescribe().getKeyPrefix();
                    String param = getParameters();
                    return new PageReference('/'+prefix+'/e?nooverride=1&'+param);
                }
                else{
                    return new pagereference('/apex/BusinessContractPage');
                }
            }
        }
        else if(busCont.id != null && !isClone){
            if(busCont.recordTypeId != adBusConRecordTypeId){
                String prefix = busCont.id; 
                String param = getParameters();
                return new PageReference('/'+prefix+'/e?nooverride=1&'+param); 
            }
            else{
                return new pagereference('/apex/BusinessContractPage?id=' + busCont.id);
            }
        }
        else if(busCont.id != null && isClone){
            if(busCont.recordTypeId != adBusConRecordTypeId){
                String prefix = busCont.id; 
                String param = getParameters();
                return new PageReference('/'+prefix+'/e?nooverride=1&'+param+'&clone=1'); 
            }
            else{
                return new pagereference('/apex/BusinessContractPage?id='+ busCont.id+'&clone=1');
            }
        }
        return null;
    }
    
    // Inherit previous parameters, more imporatntly, RecordType parameter!
    private String getParameters(){
        string param = '';
        Map<String, String> strMap = ApexPages.currentPage().getParameters();
        String[] keys = new String[]{'RecordType', 'retURL', 'cancelURL'};
        for(String s : keys){
            if(strMap.containsKey(S)) param += s + '=' + strMap.get(s) + '&';
        }
        if(param.length() > 0) param = param.substring(0, param.length()-1);
            return param;
    }
}