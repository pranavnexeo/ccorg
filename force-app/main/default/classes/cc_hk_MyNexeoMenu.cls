global class cc_hk_MyNexeoMenu extends ccrz.cc_hk_Menu{
    global override Map<String,Object> fetch(Map<String,Object> inputData){
        system.debug(' inputData ' + inputData);
         system.debug(' PARAM_MENU ' + PARAM_MENU);
        Map<String,Object> baseData; 
        if(Test.isRunningTest()) {
            baseData = cc_hk_MyNexeoMenu_Test.MENU_ITEM_MAP;
        } else {
            baseData = super.fetch(inputData);
        }
        
        List<ccrz.cc_bean_MenuItem> menus = (List<ccrz.cc_bean_MenuItem>)baseData.get(PARAM_MENU);  
        System.debug('Menu Size: '+ menus.size());
        
        cc_imp_StorefrontSettings__c mynexeosettings=cc_imp_StorefrontSettings__c.getValues('mynexeo');
        
        
        if(ccrz.cc_CallContext.currUserId==mynexeosettings.guest_User_ID__c){
            
            Integer j = 0;
            while (j<menus.size()) { 
                //if(menus.get(j).menuId.startsWith('ES')){ 
                	menus.remove(j);
                    //menus.get(j).displayName=menus.get(j).displayName+' '+a.SAP_DivisionCode__c+' '+ccrz.cc_CallContext.effAccountId;
                //} else {
                 //   j++;
               // }
            }
              return baseData;           
        }
        
        Account a = cc_imp_dao_Account.queryAccountByAccountId(ccrz.cc_CallContext.effAccountId);        
        
     
        
        if(a.SAP_DivisionCode__c!=null){
         
            if(a.SAP_DivisionCode__c=='34')
            {
                Integer j = 0;
                while (j<menus.size()) {
                   if(menus.get(j).menuId.startsWith('PLA')){
                		menus.remove(j);                
                   } else {
                       j++;
                   }
                }
                     
             }else{
                Integer j = 0;
                while (j<menus.size()) {
                   if(menus.get(j).menuId.startsWith('ES')){
                		menus.remove(j);                
                   } else {
                       j++;
                   }
                }                 
			}
        }
        
           
        if(a.AccountNumber.startsWith('P')){
             Integer j = 0;
                while (j<menus.size()) {
                 		menus.remove(j);                
                }
                 
            
        }
        return baseData;
    }
}