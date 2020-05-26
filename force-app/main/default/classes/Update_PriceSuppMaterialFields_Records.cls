Global class Update_PriceSuppMaterialFields_Records{
 
    public void update_Method(){
        
        List<Material_Sales_Data2__c> MaterialList = new List<Material_Sales_Data2__c>();
        List<Price_Support__c> priceSupportListBuy = new List<Price_Support__c>();
        List<Price_Support__c> priceSupportListSelling= new List<Price_Support__c>();
        List<String> matIds = new List<String>();
        
        // select account ids as per checkbox
        MaterialList = [select id,Material_Group2_Code__c,Material_Number__c,Material_Desc__c,Material_Base_Code__c,Material_General_Data__r.Material_Container_Desc__c from Material_Sales_Data2__c where Update_Material__c = TRUE];
      
        Map<String,Material_Sales_Data2__c> MaterialIdandMatRecord =new Map<String,Material_Sales_Data2__c>();
       
        for(Material_Sales_Data2__c mat: MaterialList ){
             MaterialIdandMatRecord.put(mat.Id,mat);
             mat.Update_Material__c = FALSE;
             matIds.add(mat.Id);
        }
        update MaterialList ;
        // select price support objects which are related to accounts queried
        priceSupportListBuy = [select id,Material_Group_2_Buying__c,Customer_soldto__c,Status__c,SAP_Transfer__c,Customer_Type__c,Support_Type__c,Material_Buying__c,Material_Description_Buying__c from Price_Support__c where  Material_Buying__c IN: matIds];
        
        priceSupportListSelling = [select id,Customer_soldto__c,Status__c,Support_Type__c,Customer_Type__c,SAP_Transfer__c,Material_Selling__c,Material_Description_Selling__c from Price_Support__c where Material_Selling__c IN: matIds];
        // update price support records with new values
        for(Price_Support__c ps: priceSupportListBuy ){
            if(ps.Customer_Type__c=='PY-Payer'){
                if(ps.Support_Type__c == 'Rebate' && ps.Customer_soldto__c!=null  && ps.Status__c!='Rejected' && ps.Status__c!='Cancelled'&& (ps.Status__c=='Approved'||ps.Status__c=='Expired')){
                    ps.SAP_Transfer__c = 'OPEN';
                    ps.Material_Description_Buying__c = MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Desc__c;
                    ps.Material_Code_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Number__c;
                    ps.Base_Material_Code_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Base_Code__c;
                    ps.Container_Type_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_General_Data__r.Material_Container_Desc__c;
                    ps.Material_Group_2_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Group2_Code__c;
                
                }
                else{
                    ps.Material_Description_Buying__c = MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Desc__c;
                    ps.Material_Code_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Number__c;
                    ps.Base_Material_Code_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Base_Code__c;
                    ps.Container_Type_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_General_Data__r.Material_Container_Desc__c;
                    ps.Material_Group_2_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Group2_Code__c;
                }
            }else if(ps.Support_Type__c == 'Rebate' && ps.Status__c!='Rejected' && ps.Status__c!='Cancelled'){
            if(ps.Status__c=='Approved'||ps.Status__c=='Expired'){
                   ps.SAP_Transfer__c = 'OPEN';
                   ps.Material_Description_Buying__c = MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Desc__c;
                   ps.Material_Code_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Number__c;
                   ps.Base_Material_Code_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Base_Code__c;
                   ps.Container_Type_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_General_Data__r.Material_Container_Desc__c;
                   ps.Material_Group_2_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Group2_Code__c;
                }
                else{
                   ps.Material_Description_Buying__c = MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Desc__c;
                   ps.Material_Code_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Number__c;
                   ps.Base_Material_Code_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Base_Code__c;
                   ps.Container_Type_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_General_Data__r.Material_Container_Desc__c;
                   ps.Material_Group_2_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Group2_Code__c;
                }
            }
            if(ps.Support_Type__c == 'Upfront'  && ps.Status__c!='Rejected' && ps.Status__c!='Cancelled'){
                  
                    ps.Material_Description_Buying__c = MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Desc__c;
                    ps.Material_Code_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Number__c;
                    ps.Base_Material_Code_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Base_Code__c;
                    ps.Container_Type_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_General_Data__r.Material_Container_Desc__c;
                    ps.Material_Group_2_Buying__c= MaterialIdandMatRecord.get(ps.Material_Buying__c).Material_Group2_Code__c;
                }    
            
        }
          for(Price_Support__c ps: priceSupportListSelling ){
            if(ps.Customer_Type__c=='PY-Payer'){
                if(ps.Support_Type__c == 'Rebate' && ps.Customer_soldto__c!=null  && ps.Status__c!='Rejected' && ps.Status__c!='Cancelled'&&(ps.Status__c=='Approved'||ps.Status__c=='Expired')){
                    ps.SAP_Transfer__c = 'OPEN';
                    ps.Material_Description_Selling__c = MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Desc__c;
                    ps.Material_Code_Selling__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Number__c;
                    ps.Base_Material_Code_Selling__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Base_Code__c;
                    ps.Container_Type__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_General_Data__r.Material_Container_Desc__c;
                }
                else{
                    ps.Material_Description_Selling__c = MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Desc__c;
                    ps.Material_Code_Selling__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Number__c;
                    ps.Base_Material_Code_Selling__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Base_Code__c;
                    ps.Container_Type__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_General_Data__r.Material_Container_Desc__c;  
                }
            }else if(ps.Support_Type__c == 'Rebate' && ps.Status__c!='Rejected' && ps.Status__c!='Cancelled'){
              if(ps.Status__c=='Approved'||ps.Status__c=='Expired'){
                ps.SAP_Transfer__c = 'OPEN';
                ps.Material_Description_Selling__c = MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Desc__c;
                ps.Material_Code_Selling__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Number__c;
                ps.Base_Material_Code_Selling__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Base_Code__c;
                ps.Container_Type__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_General_Data__r.Material_Container_Desc__c;
                }
                else {
                ps.Material_Description_Selling__c = MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Desc__c;
                ps.Material_Code_Selling__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Number__c;
                ps.Base_Material_Code_Selling__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Base_Code__c;
                ps.Container_Type__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_General_Data__r.Material_Container_Desc__c;
                }
            }
               if(ps.Support_Type__c == 'Upfront'  && ps.Status__c!='Rejected' && ps.Status__c!='Cancelled'){
                ps.Material_Description_Selling__c = MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Desc__c;
                ps.Material_Code_Selling__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Number__c;
                ps.Base_Material_Code_Selling__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_Base_Code__c;
                ps.Container_Type__c= MaterialIdandMatRecord.get(ps.Material_Selling__c).Material_General_Data__r.Material_Container_Desc__c;
               
               }
        }
        update priceSupportListBuy ;
        update priceSupportListSelling ;       
    }
}