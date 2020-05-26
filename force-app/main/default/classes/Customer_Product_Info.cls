global class Customer_Product_Info
{
       
    webservice static Customer_Product_Info__c retrieveCustomerProductInfo(String salesOrgCode,
                                                                           String distributionChannelCode,
                                                                           Id accId,
                                                                           String shipToNumber,
                                                                           String materialNumber)
    {
        
        Customer_Product_Info__c resultCustProdInfo = new Customer_Product_Info__c();
        List<Customer_Product_Info__c> listCustProdInfo = new List<Customer_Product_Info__c>();
        List<Customer_Product_Info__c> tempListCustProdInfo = new List<Customer_Product_Info__c>();
    	Account acc = [select Id, SAP_INCO_Terms1__c, SAP_ShippingPlant__c
    	                 from Account
    	                where Id = :accId
    	              ];
        List<Material_Plant2__c> plants = null;
        try {
	        plants = Material_Sales_Data_Functions.getPlants(materialNumber, 
	                                                         salesOrgCode, 
	                                                         distributionChannelCode);
        } catch (Exception e) {}
        Id SoldToId;
        SoldToId = CISRelationships_Functions.Lookup_Related_Sold_To(accId);
        
        if (SoldToId == null) {SoldToId = accId;}
        
        String customerNumber = [Select AccountNumber from Account where Id =:SoldToId].AccountNumber;

        if(shipToNumber != '')
        {
            listCustProdInfo = [Select INCO_Terms1__c, Plant_Code__c,
                               Item_Usage__c, Primary_Indicator__c from Customer_Product_Info__c 
                               where CPI_Record_Type__c = '1' AND 
                               Sales_Org_Code__c =:salesOrgCode AND
                               Distribution_Channel_Code__c =:distributionChannelCode AND 
                               Customer_Number__c =:customerNumber AND 
                               ShipTo_Number__c =:shipToNumber AND 
                               Material_Number__c =:materialNumber AND
                               Deletion_Indicator__c != 'X'];
        }                                                   
        if(listCustProdInfo.size() == 0)       
        {
            listCustProdInfo = [Select INCO_Terms1__c, Plant_Code__c,
                               Item_Usage__c, Primary_Indicator__c from Customer_Product_Info__c 
                               where CPI_Record_Type__c = '2' AND 
                               Sales_Org_Code__c =:salesOrgCode AND
                               Distribution_Channel_Code__c =:distributionChannelCode AND 
                               Customer_Number__c =:customerNumber AND 
                               Material_Number__c =:materialNumber AND
                               Deletion_Indicator__c != 'X'];
        
            if(listCustProdInfo.size() == 0)
            {
                    Id parentId = [Select ParentId from Account where Id =:accId].ParentId;
                                        
                    if (parentId != null)
                    {
                        customerNumber = [Select AccountNumber from Account where Id =:parentId].AccountNumber;
               
                        listCustProdInfo = [Select INCO_Terms1__c, Plant_Code__c,
                                       Item_Usage__c, Primary_Indicator__c from Customer_Product_Info__c 
                                       where CPI_Record_Type__c = '3' AND 
                                       Sales_Org_Code__c =:salesOrgCode AND
                                       Distribution_Channel_Code__c =:distributionChannelCode AND 
                                       Customer_Number__c =:customerNumber AND 
                                       Material_Number__c =:materialNumber AND
                                       Deletion_Indicator__c != 'X'];
                    }
            }
        }
                    
        if(listCustProdInfo.size() > 1)
        {
            for(Customer_Product_Info__c c : listCustProdInfo)
            {
                if(c.Primary_Indicator__c == 'X')
                tempListCustProdInfo.add(c);
            }
            if(tempListCustProdInfo.size() > 0)
            resultCustProdInfo = tempListCustProdInfo[0];
            else resultCustProdInfo = listCustProdInfo[0];
        }
        else if(listCustProdInfo.size() == 1)
        resultCustProdInfo = listCustProdInfo[0];
        else if(listCustProdInfo.size() == 0)
        resultCustProdInfo = getDefaultCPI(acc);
        
        if (isNull(resultCustProdInfo.Plant_Code__c)) {
        	setDefaultPlant(resultCustProdInfo, acc, plants);
        }
        
        return resultCustProdInfo;
    }
    
    private static Customer_Product_Info__c getDefaultCPI(Account acc) {
    	Customer_Product_Info__c cpi = new Customer_Product_Info__c();
        cpi.INCO_Terms1__c = acc.SAP_INCO_Terms1__c;
        cpi.Plant_Code__c = acc.SAP_ShippingPlant__c;
        return cpi;
    }
    
    private static Boolean isNull(String s) {
    	return (s == null || s.trim().length() == 0);
    }
    
    private static void setDefaultPlant(Customer_Product_Info__c cpi,
                                        Account acc, 
                                        List<Material_Plant2__c> plants) {
		if (plants != null && !plants.isEmpty()) {
			for (Material_Plant2__c mp : plants) {
				if (mp.Deletion_Flag__c != 'X' && 
				    mp.Plant_Code__c == acc.SAP_ShippingPlant__c) {
					cpi.Plant_Code__c = acc.SAP_ShippingPlant__c;
				}
			}
		}
	}        
    
/*
test methods
*/    
    public static testMethod void test01() {  
        Customer_Product_Info__c resultCustProdInfo = new Customer_Product_Info__c();
    /*
        resultCustProdInfo = retrieveCustomerProductInfo('1021',
                                    '50',
                                    '001Q00000080W5B',
                                    '0000570668',
                                    '000000000000050539');

        system.debug(resultCustProdInfo);
    */

    }
}