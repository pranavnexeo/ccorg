/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        01/01/2016
*    Author:             Rohini Bharambe
*   Last Modified:        10/13/2016
*   Last Modified By:     Sneha Likhar
*
*   Short Description:  This is a handler class for loading Product data into Cloudcraze.
*   **********************************************************************************************************************/


Public with sharing class Cloudcraze_Product_Function{

//Call this function on Material_Sales_Data2 upsert
public static void upsert_cloudcraze_product(List<Material_Sales_Data2__c> msd2){
List<ccrz__E_Product__c> ccProductList = new List<ccrz__E_Product__c>();

    
for(Material_Sales_Data2__c m : msd2)
{
    
    //if(!m.Name.startsWith('3DP')){ //Do not exclude SAP 3D Materials from loading into products table
    ccrz__E_Product__c p = new ccrz__E_Product__c();
    p.Name = m.Name;
    p.ccrz__Storefront__c = 'mynexeo';
    p.ccrz__Industry__c = m.PH2_Line__c;
    p.ccrz__LongDesc__c = m.Name;
    p.ccrz__LongDescRT__c = m.Name;
    p.Ext_Material_Group_Code__c = m.Ext_Material_Group_Code__c; //m.Material_General_Data__r.Ext_Material_group_code__c;
    p.ccrz__SKU__c = m.Record_Key__c;
    p.ccrz__UnitOfMeasure__c = m.Material_Container_Abbreviation__c; //m.Material_General_Data__r.Base_UOM_Desc__c;
    p.SalesOrgCode__c = m.Sales_Org_Code__c;
    p.DistChannel_Code__c = m.Dist_Channel_Code__c;
    p.DivisionCode__c = m.Division_Code__c; //Material_General_Data__r.Division_Code__c;
    p.DivisionDesc__c = m.Division_Desc__c;
    p.Base_Code__c = m.Material_Base_Code__c;
    p.Base_Code_Desc__c = m.Material_Base_Code_Desc__c;
    p.ContainerDesc__c = m.Container_Desc_del__c; //m.Material_General_Data__r.Material_Container_Desc__c;
    p.Supplier__c = m.PH4_Supplier__c; //Product_Hierarchy__r.PH4_Supplier__c;
    p.Segment__c = m.PH6_Segment__c; //Product_Hierarchy__r.PH6_Segment__c;
    p.NexeoMaterialId__c = m.id;
    p.SAP_Material__c = m.id;
    p.Product_Number__c = m.Material_Number__c;
    p.Sales_UoM__c = m.Material_Container_Abbreviation__c;
    p.Sales_UoM_Desc__c = m.Sales_UOM_Desc__c;
    system.debug('Marked_for_deletion__c:'+m.Marked_for_deletion__c);
    if(m.Marked_for_Deletion__c == 'TRUE')
        p.ccrz__ProductStatus__c = 'Blocked';
    else
        p.ccrz__ProductStatus__c = 'Released';
    
    ccProductList.add(p);
    //} //end of 3DP
        
}
    if(ccProductList.size()>0){
    List<Database.Upsertresult> upsertResult =  new List<Database.Upsertresult>();
    upsertResult = Database.upsert(ccProductList, ccrz__E_Product__c.ccrz__SKU__c, false);
    
    //Error handling - Store the errors in case of failure
    if(upsertResult.size()>0){
        for(integer i=0; i<upsertResult.size();i++){
            if (upsertResult.get(i).isSuccess()){
                    upsertResult.get(i).getId();
                }
                else if (!upsertResult.get(i).isSuccess()){
                    // Upsert DML operation failed
                    Database.Error error = upsertResult.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    ccProductList.get(i);//failed record from the list
                    system.debug('Failed Material Record Key'+ccProductList.get(i).ccrz__SKU__c);
    
                }
        }
    }
   }
    
}

//Call this function on cc Product Upsert to create Product Category and Product Specification Records for MyNexeo Products
public static void upsert_cloudcraze_product(List<ccrz__E_Product__c> ccProd){

//Map<String, String> mapProdCat = getCategoryMap();
Map<String, String> mapProdSpec = getSpecMap();
List<ccrz__E_Spec__c>spec = new List<ccrz__E_Spec__c>();
//List<ccrz__E_ProductCategory__c> lstprodCat = new List<ccrz__E_ProductCategory__c>();
List<ccrz__E_ProductSpec__c> lstprodSpec = new List<ccrz__E_ProductSpec__c>();

for(ccrz__E_Product__c p: ccProd)
{
    /*ccrz__E_ProductCategory__c prodCat = new ccrz__E_ProductCategory__c();
    prodCat.ccrz__Product__c = p.id;
    
    if(mapProdCat.containsKey(p.DivisionCode__c)){
         prodCat.ccrz__Category__c = mapProdCat.get(p.DivisionCode__c);
     }
     prodCat.ccrz__ProductCategoryId__c = prodCat.ccrz__Product__c +'-'+ prodCat.ccrz__Category__c;
     lstprodCat.add(prodCat);*/
     
     for(String s: mapProdSpec.keySet()) {
        
         if(s == 'Supplier' || s == 'Segment'){  
             ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
             prodSpec.ccrz__Product__c = p.id;   
                 
             if(s == 'Supplier' && (p.Supplier__c != '' && p.Supplier__c != null && p.Supplier__c != 'N/A'))
             {
                 prodSpec.ccrz__Spec__c = mapProdSpec.get('Supplier');
                 prodSpec.ccrz__SpecValue__c = p.Supplier__c;
             }
             if(s == 'Supplier' && (p.Supplier__c != '' && p.Supplier__c != null && p.Supplier__c == 'N/A'))
             {
                 prodSpec.ccrz__Spec__c = mapProdSpec.get('Supplier');
                 prodSpec.ccrz__SpecValue__c = 'General';
             }
             
             if(s == 'Segment' && (p.Segment__c != '' && p.Segment__c != null && p.Segment__c != 'N/A'))
             {
                 prodSpec.ccrz__Spec__c = mapProdSpec.get('Segment');
                 prodSpec.ccrz__SpecValue__c = p.Segment__c;
             }
             if(s == 'Segment' && (p.Segment__c != '' && p.Segment__c != null && p.Segment__c == 'N/A'))
             {
                 prodSpec.ccrz__Spec__c = mapProdSpec.get('Segment');
                 prodSpec.ccrz__SpecValue__c = 'General';
             }
             prodSpec.ProductSpecID__c = prodSpec.ccrz__Product__c +'-'+ prodSpec.ccrz__Spec__c;
             lstprodSpec.add(prodSpec);
        }
     } //end of Specification for
        
}//end of Product for

//List<Database.Upsertresult> upsertProdCat =  new List<Database.Upsertresult>();
//upsertProdCat = Database.upsert(lstprodCat, ccrz__E_ProductCategory__c.ccrz__ProductCategoryId__c, false);
    
List<Database.Upsertresult> upsertProdSpec =  new List<Database.Upsertresult>();
upsertProdSpec = Database.upsert(lstprodSpec, ccrz__E_ProductSpec__c.ProductSpecID__c, false);

//upsert lstprodCat;
 
//upsert lstprodSpec;

/**********Commenting this as SalesArea Price List is not required*********************
//Add the product in Global Price List
List<ccrz__E_PriceListItem__c> lstPLI = new List<ccrz__E_PriceListItem__c>();
List<ccrz__E_PriceList__c> lstPList = new List<ccrz__E_PriceList__c>();
List<ccrz__E_PriceList__c> lstPListNew = new List<ccrz__E_PriceList__c>();
Map<String, String> mapPriceList = new Map<String, String>();

mapPriceList = getPriceListMap();

for(ccrz__E_Product__c p: ccProd)
{
   String sSalesArea = p.SalesOrgCode__c+p.DistChannel_Code__c+p.DivisionCode__c;
   Boolean empty = mapPriceList.isEmpty();
   system.debug('sSalesArea :'+sSalesArea);
    system.debug('empty:'+empty);
   if((!mapPriceList.containsKey(sSalesArea)) || empty)
       { system.debug('Inside loop!!');
           ccrz__E_PriceList__c  recPL = new ccrz__E_PriceList__c();
           recPL.ccrz__PricelistId__c = sSalesArea;
           recPL.SalesArea__c = sSalesArea;
           recPL.Name = sSalesArea;
           recPL.PriceListType__c = 'SalesArea';
           recPL.ccrz__CurrencyISOCode__c = 'USD';
           recPL.ccrz__Storefront__c = 'mynexeo';
           lstPList.add(recPL);
       }
       //put the element in the map with null key in order to avoid the Duplicate External Id Error while upsert DML
       //mapPriceList.put(sSalesArea,''); 
}

List<Database.Upsertresult> upsertPList =  new List<Database.Upsertresult>();
upsertPList = Database.upsert(lstPList, ccrz__E_PriceList__c.ccrz__PricelistId__c, false);

if(upsertPList.size()>0){
        for(integer i=0; i<upsertPList.size();i++){
            if (upsertPList.get(i).isSuccess()){
                    upsertPList.get(i).getId();
                }
                else if (!upsertPList.get(i).isSuccess()){
                    // Upsert DML operation failed
                    Database.Error error = upsertPList.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    lstPList.get(i);//failed record from the list
                    system.debug('Failed Price List Record Key :: '+failedDML+' :: '+lstPList.get(i).ccrz__PricelistId__c);
    
                }
        }
    }

if(lstPList.size()>0){
    //lstPListNew = [Select SalesArea__c, id from ccrz__E_PriceList__c where SalesArea__c IN =: ];
    //Map<String, String> mapPriceListNew = new Map<String, String>(lstPListNew); 
    mapPriceList = getPriceListMap();
}
 
for(ccrz__E_Product__c p: ccProd)
{  //Add only Ext Material Group Code '101' products in Sales Area Price List
   if(p.ccrz__ProductStatus__c != 'Blocked' && p.Ext_Material_Group_Code__c == '101')  
   {
   String sSalesArea = p.SalesOrgCode__c+p.DistChannel_Code__c+p.DivisionCode__c;
         
   ccrz__E_PriceListItem__c PLI = new ccrz__E_PriceListItem__c();
   String sPSalesArea = p.SalesOrgCode__c+p.DistChannel_Code__c+p.DivisionCode__c;
   
   system.debug('SalesArea:'+sSalesArea);
   if(mapPriceList.containsKey(sSalesArea))
       PLI.ccrz__Pricelist__c = mapPriceList.get(sSalesArea);

   PLI.ccrz__Product__c = p.id;
   PLI.ccrz__Price__c = 0;
   PLI.ccrz__PricelistItemId__c = PLI.ccrz__Pricelist__c+'-'+PLI.ccrz__Product__c;
   system.debug('PLI.ccrz__PricelistItemId__c:'+PLI.ccrz__PricelistItemId__c);
   lstPLI.add(PLI);
   }
}

List<Database.Upsertresult> upsertPLI =  new List<Database.Upsertresult>();
upsertPLI = Database.upsert(lstPLI, ccrz__E_PriceListItem__c.ccrz__PricelistItemId__c, false);
*******************************************************************************************************/

}

//Call this function on cc Product Insert to create Product Media Records for MyNexeo Products
public static void insert_product_media(List<ccrz__E_Product__c> ccProd){

List<ccrz__E_ProductMedia__c> lstProdMedia = new List<ccrz__E_ProductMedia__c>();
MyNexeo_Product_Media__c pd =  MyNexeo_Product_Media__c.getOrgDefaults();
String prodimg = pd.ProductImage__c;
String prodSearchImg = pd.ProductSearchImage__c;
String prodThum = pd.ProductThumbnail__c;
String prodimg_DR = pd.ProductImage_DR__c;
String prodSearchImg_DR = pd.ProductSearchImage_DR__c;
String prodThum_DR = pd.ProductThumbnail_DR__c;
String prodimg_IBC = pd.ProductImage_IBC__c;
String prodSearchImg_IBC = pd.ProductSearchImage_IBC__c;
String prodThum_IBC = pd.ProductThumbnail_IBC__c;

for(ccrz__E_Product__c p :ccProd)
{
    ccrz__E_ProductMedia__c mediaRec1 = new ccrz__E_ProductMedia__c();
    mediaRec1.ccrz__Enabled__c = true;
    mediaRec1.ccrz__Locale__c = 'en';
    mediaRec1.ccrz__Product__c = p.id;
    mediaRec1.ccrz__ProductMediaSource__c = 'URI';
    if(p.Sales_UoM__c == 'DR')
        mediaRec1.ccrz__URI__c = prodimg_DR;
    else if(p.Sales_UoM__c == 'IBC')
        mediaRec1.ccrz__URI__c = prodimg_IBC;
    else
        mediaRec1.ccrz__URI__c = prodimg; 
    mediaRec1.ccrz__MediaType__c = 'Product Image';
    mediaRec1.ccrz__ProductMediaId__c = 'Product Image - '+p.id;

    lstProdMedia.add(mediaRec1);
    
    ccrz__E_ProductMedia__c mediaRec2 = new ccrz__E_ProductMedia__c();
    mediaRec2.ccrz__Enabled__c = true;
    mediaRec2.ccrz__Locale__c = 'en';
    mediaRec2.ccrz__Product__c = p.id;
    mediaRec2.ccrz__ProductMediaSource__c = 'URI';
    if(p.Sales_UoM__c == 'DR')
        mediaRec2.ccrz__URI__c = prodThum_DR;
    else if(p.Sales_UoM__c == 'IBC')
        mediaRec2.ccrz__URI__c = prodThum_IBC;
    else
        mediaRec2.ccrz__URI__c = prodThum; 
    mediaRec2.ccrz__MediaType__c = 'Product Image Thumbnail';
    mediaRec2.ccrz__ProductMediaId__c = 'Product Image Thumbnail - '+p.id;
    
    lstProdMedia.add(mediaRec2);
    
    ccrz__E_ProductMedia__c mediaRec3 = new ccrz__E_ProductMedia__c();
    mediaRec3.ccrz__Enabled__c = true;
    mediaRec3.ccrz__Locale__c = 'en';
    mediaRec3.ccrz__Product__c = p.id;
    mediaRec3.ccrz__ProductMediaSource__c = 'URI';
    if(p.Sales_UoM__c == 'DR')
        mediaRec3.ccrz__URI__c = prodSearchImg_DR;
    else if(p.Sales_UoM__c == 'IBC')
        mediaRec3.ccrz__URI__c = prodSearchImg_IBC;
    else
        mediaRec3.ccrz__URI__c = prodSearchImg; 
    mediaRec3.ccrz__MediaType__c = 'Product Search Image';
    mediaRec3.ccrz__ProductMediaId__c = 'Product Search Image - '+p.id;
    
    lstProdMedia.add(mediaRec3);

}
    
    List<Database.Upsertresult> upsertPMedia =  new List<Database.Upsertresult>();
    upsertPMedia = Database.upsert(lstProdMedia, ccrz__E_ProductMedia__c.ccrz__ProductMediaId__c, false);
}

//Call this function on cc Product Upsert to create Product Category and Product Specification Records for nexeo3D Products
public static void upsert_nexeo3D_product(List<ccrz__E_Product__c> ccProd){
/**********************************************************************************/
    Map<String, String> mapTPCCategory = new Map<String, String>();
    Map<String, String> mapPolymideCategory = new Map<String, String>();
    Map<String, String> map3DCategory = new Map<String, String>();
    Map<String,String> german_map = new Map<String,String>();
    german_map.put('Natural White','Natürliches Weiß');
    german_map.put('Natural Translucent','Natürlich Translucid');
    german_map.put('Black','Schwarz');
    german_map.put('White','Weiß');
    german_map.put('Grey','Grau');
    german_map.put('Spool','Spule');
    german_map.put('Sample','Sample');
    
    List<ccrz__E_Category__c> lstCategory = [Select id, ccrz__CategoryID__c, Name, ccrz__ParentCategory__r.Name from ccrz__E_Category__c];
    for(ccrz__E_Category__c c: lstCategory)
    {
         String sCatId = c.Name;         
         if(sCatId != '')
         {
             map3DCategory.put(c.ccrz__CategoryID__c, c.id);
         }
         
     }
    
    
/**********************************************************************************/
//Map<String, String> mapProdCat = get3DCategoryMap();
Map<String, String> mapProdSpec = get3DSpecMap();
List<ccrz__E_Spec__c>spec = new List<ccrz__E_Spec__c>();
List<ccrz__E_ProductCategory__c> lstprodCat = new List<ccrz__E_ProductCategory__c>();
List<ccrz__E_ProductSpec__c> lstprodSpec = new List<ccrz__E_ProductSpec__c>();

for(ccrz__E_Product__c p: ccProd)
{
    //if(p.Category__c == 'TPC' || p.Category__c == 'Polyamide'){
        ccrz__E_ProductCategory__c prodCat = new ccrz__E_ProductCategory__c();
        prodCat.ccrz__Product__c = p.id;
        prodCat.ccrz__Category__c = map3DCategory.get(p.Category__c);
        prodCat.ccrz__ProductCategoryId__c = prodCat.ccrz__Product__c +'-'+ prodCat.ccrz__Category__c;
        lstprodCat.add(prodCat);
    //}

}

for(ccrz__E_Product__c p: ccProd)
{
         
     for(String s: mapProdSpec.keySet()) {
        
          system.debug('sProdCat:'+s);
             ccrz__E_ProductSpec__c prodSpec = new ccrz__E_ProductSpec__c();
             prodSpec.ccrz__Product__c = p.id;   
             
             //if(s == 'Color' || s == 'Weight' || s == 'Diameter' || s == 'Size' || s == 'ProductSpec'){
             if(s.startsWith('Color - ') || s.startsWith('Weight - ') || s.startsWith('Diameter - ') || s.startsWith('Size - ') || s.startsWith('ProductSpec - ')){  
                 if(s.startsWith('Color - ') && (p.Color__c != '' && p.Color__c != null && p.Color__c != 'N/A'))
                 {
                     if(s.split(' - ')[1] == 'en_US')
                     {                         
                         prodSpec.ccrz__Spec__c = mapProdSpec.get(s);
                         prodSpec.ccrz__SpecValue__c = p.Color__c;
                     }
                     else if(s.split(' - ')[1] == 'de_DE')
                     {                         
                         prodSpec.ccrz__Spec__c = mapProdSpec.get(s);
                         prodSpec.ccrz__SpecValue__c = german_map.get(String.valueof(p.Color__c));
                     }                     
                 }              
                 if(s.startsWith('Weight - ') && (p.Weight__c!= '' && p.Weight__c!= null && p.Weight__c != 'N/A'))
                 {
                     prodSpec.ccrz__Spec__c = mapProdSpec.get(s);
                     prodSpec.ccrz__SpecValue__c =  String.valueOf(p.Weight__c);
                 }             
                 if(s.startsWith('Diameter - ') && (p.Diameter__c != '' && p.Diameter__c != null && p.Diameter__c != 'N/A'))
                 {
                     prodSpec.ccrz__Spec__c = mapProdSpec.get(s);
                     prodSpec.ccrz__SpecValue__c = p.Diameter__c;
                 }               
                 if(s.startsWith('Size - ') && (p.Sub_Category__c != '' && p.Sub_Category__c != null && p.Sub_Category__c != 'N/A'))
                 {
                     if(s.split(' - ')[1] == 'en_US')
                     {                         
                         prodSpec.ccrz__Spec__c = mapProdSpec.get(s);
                         prodSpec.ccrz__SpecValue__c = p.Sub_Category__c;
                     }
                     else if(s.split(' - ')[1] == 'de_DE')
                     {                         
                         prodSpec.ccrz__Spec__c = mapProdSpec.get(s);
                         prodSpec.ccrz__SpecValue__c = german_map.get(String.valueof(p.Sub_Category__c));
                     }   
                 }
                 if(s.startsWith('ProductSpec - ') && (p.ProductSpec__c != '' && p.ProductSpec__c != null && p.ProductSpec__c != 'N/A'))
                 {
                     prodSpec.ccrz__Spec__c = mapProdSpec.get(s);
                     prodSpec.ccrz__SpecValue__c = p.ProductSpec__c;
                 }                  
             }
             prodSpec.ProductSpecID__c = prodSpec.ccrz__Product__c +'-'+ prodSpec.ccrz__Spec__c;
             lstprodSpec.add(prodSpec);
        
     } //end of Specification for
        
}//end of Product for

List<Database.Upsertresult> upsertProdCat =  new List<Database.Upsertresult>();
upsertProdCat = Database.upsert(lstprodCat, ccrz__E_ProductCategory__c.ccrz__ProductCategoryId__c, false);
    
List<Database.Upsertresult> upsertProdSpec =  new List<Database.Upsertresult>();
upsertProdSpec = Database.upsert(lstprodSpec, ccrz__E_ProductSpec__c.ProductSpecID__c, false);

}

//Create Category Map for MyNexeo
public static Map<String, String> getCategoryMap() {
    Map<String, String> mapCategory = new Map<String, String>();
    List<ccrz__E_Category__c> lstCategory = [Select id, ccrz__CategoryID__c, Name from ccrz__E_Category__c];
    for(ccrz__E_Category__c c: lstCategory)
    {
         String sCatId = c.ccrz__CategoryID__c;
         
         if(sCatId != null && sCatId.trim().length()>0)
             mapCategory.put(c.ccrz__CategoryID__c,c.id);   
    }
    
   return mapCategory;     
}

//Create Category Map for MyNexeo
/*public static Map<String, String> get3DCategoryMap() {
    Map<String, String> mapTPCCategory = new Map<String, String>();
    Map<String, String> mapPolymideCategory = new Map<String, String>();
    List<ccrz__E_Category__c> lstCategory = [Select id, ccrz__CategoryID__c, Name, ccrz__ParentCategory__c from ccrz__E_Category__c];
    for(ccrz__E_Category__c c: lstCategory)
    {
         String sCatId = c.Name;
         String sParentCat = c.ccrz__ParentCategory__c;
         
         if(sCatId.trim().length()>0 && sParentCat.trim().length()>0){
             if(sParentCat == 'TPC')
                 mapTPCCategory.put(c.Name, c.id);  
                 
             if(sParentCat == 'Polymide')
                 mapPolymideCategory.put(c.Name, c.id);  
         }
    }
    
   return mapCategory;     
}*/

//Create Specification Map for Mynexeo
public static Map<String, String> getSpecMap() {
    Map<String, String> mapSpec = new Map<String, String>();
    List<ccrz__E_Spec__c> lstSpec = [Select id, ccrz__SpecID__c, Name from ccrz__E_Spec__c];
    for(ccrz__E_Spec__c s: lstSpec)
    {
         String sSpecName = s.Name;
          
         if(sSpecName != null && sSpecName.trim().length()>0)
             mapSpec.put(s.Name,s.id);   
    }
     
   return mapSpec;     
}

//Create Specification Map for Nexeo3D
public static Map<String, String> get3DSpecMap() {
    Map<String, String> mapSpec = new Map<String, String>();
    List<ccrz__E_Spec__c> lstSpec = [Select Id, ccrz__SpecID__c, Name, ccrz__Locale__c from ccrz__E_Spec__c];
    for(ccrz__E_Spec__c s: lstSpec)
    {
         String sSpecName = s.Name;
         String sSpecLocale = s.ccrz__Locale__c;
             
         if((sSpecName != null && sSpecName.trim().length()>0) && (sSpecLocale != null && sSpecLocale.trim().length()>0)) 
             mapSpec.put(s.Name+' - '+ sSpecLocale,String.valueof(s.Id));   
    }
     
   return mapSpec;     
}
    
//Get Price List based on Material Sales Area
public static Map<String, String> getPriceListMap() {
   Map<String, String> mapPlist = new Map<String, String>();
   List<ccrz__E_PriceList__c> lstPlist = [Select id, SalesArea__c, ccrz__Storefront__c, Name, PriceListType__c from ccrz__E_PriceList__c where ccrz__Storefront__c = 'mynexeo'];
   for(ccrz__E_PriceList__c p: lstPlist)
   {
        String sSalesArea = p.SalesArea__c;
         
        if(sSalesArea != null && sSalesArea.trim().length()>0)
        {
            mapPlist.put(sSalesArea,p.id);   
        }
   }
   return mapPlist;     
}

//Get Price List based on Material Sales Area
public static Map<String, String> getCPIPriceListMap(Set<String> Pkey) {
    Map<String, String> mapPlist = new Map<String, String>();
    List<ccrz__E_PriceList__c> lstPlist = [Select id, ccrz__PricelistId__c, PriceListType__c from ccrz__E_PriceList__c where ccrz__PricelistId__c IN: Pkey];
    System.debug('FGG Line 501 '+lstPlist.size());
    for(ccrz__E_PriceList__c p: lstPlist)
    {
        System.debug('FGG Line 503 '+p.ccrz__PriceListId__c);
         String sCPI = p.ccrz__PricelistId__c;
          
         if(sCPI != null && sCPI.trim().length()>0) {        
        System.debug('FGG Line in mapPlist '+p.ccrz__PriceListId__c);
             mapPlist.put(sCPI,p.id);   
         }
         /*else{
        System.debug('FGG Line not in map'+p.ccrz__PriceListId__c);
         
          }*/
    }
     
   return mapPlist;     
}

//Get Nexeo Material to ccProduct Map
public static Map<String, String> getMatToProdMap(List<String> MatKey) {
    Map<String, String> mapProdId = new Map<String, String>();
    List<ccrz__E_Product__c> lstProdlist = [Select NexeoMaterialId__c, ccrz__SKU__c, id from ccrz__E_Product__c where ccrz__SKU__c IN : MatKey];
    for(ccrz__E_Product__c p: lstProdlist)
    {
         String sProdId = p.ccrz__SKU__c;
          
         if(sProdId != null && sProdId.trim().length()>0)
             mapProdId.put(sProdId,p.id);   
    }
     
   return mapProdId;     
}

//Write DML errors in Database to retrigger the upload process
public static void writeProductErrors(List<Database.Upsertresult> upsertResults){





}


//================================================================================================================================
//@Future
//Call this function from Account to create Account Group record for an account
public static void add_AccountGroupCreation(List<Id> ids){
List<Account> accList = [select id, YY_Partner__r.record_key__c, YZ_Partner__r.Record_Key__c,YI_Partner__r.record_key__c, ccrz__UsedByCloudcraze__c,Type,SAP_Sales_Org__c,SAP_DistChannel__c,SAP_DivisionCode__c,Account_Number__c,ccrz__E_AccountGroup__c from Account where id IN :ids];
  
string sSalesArea;
List<ccrz__E_AccountGroup__c> accGroupList = new List<ccrz__E_AccountGroup__c>();

for(Account a: accList){
    if(a.ccrz__UsedByCloudcraze__c == true && a.Type == 'Customer'){ 
        sSalesArea = a.SAP_Sales_Org__c+a.SAP_DistChannel__c+a.SAP_DivisionCode__c;
        
        //Create the Account Group if not exist
        if(sSalesArea != '' && a.ccrz__E_AccountGroup__c == null){system.debug('111 is here'+sSalesArea );
            ccrz__E_AccountGroup__c accGroup = new ccrz__E_AccountGroup__c();
            accGroup.Name = a.Account_Number__c; //CISAccountNumber
            accGroup.ccrz__AccountGroupID__c = a.id; //account record id
            accGroup.Account__c = a.id; //account record id lookup
            accGroup.ccrz__PriceListSelectionMethod__c = 'Sequence Order';
            accGroup.SalesArea__c = sSalesArea;
            accGroupList.add(accGroup);}
        } //end of cloudcraze account if check 
}//end of Account for

//Insert Account Group Record and also update Account with lookup id    
if(accGroupList.size()>0){
List<Database.SaveResult> insertAccGroup =  new List<Database.SaveResult>();
insertAccGroup = Database.insert(accGroupList, false);

/////////////////////////Sneha////////////////////////////////////////////////////////

/*List<String> aglistagid = new List<String> ();
List<Account> acclisttoupdate = new List<account> ();
List<ccrz__E_AccountGroup__c> aglist = [select id, ccrz__AccountGroupID__c, Account__c from ccrz__E_AccountGroup__c where id in :accGroupList];
system.debug('AAAA' + aglist);
for(ccrz__E_AccountGroup__c ag: aglist)
{
    
      aglistagid.add(ag.ccrz__AccountGroupID__c);
    
}


List<Account> acnt = [select id, SAP_Sold_To_Account__c, SAP_Sold_To_Account_Id__c, ccrz__UsedByCloudcraze__c, ccrz__E_AccountGroup__c,Account_Number__c, CurrencyIsoCode from account where id in :aglistagid];
system.debug('BBBB' + acnt);

For(Account ant: acnt)
{
   for(ccrz__E_AccountGroup__c ag: aglist){
       if(ant.id == ag.ccrz__AccountGroupID__c){
           ant.ccrz__E_AccountGroup__c = ag.id;
           if(ant.SAP_Sold_To_Account__c != Null && ant.SAP_Sold_To_Account__c.contains('-'))
           {
               ant.SAP_Sold_To_Account_Number__c = ant.SAP_Sold_To_Account__c.split(' - ')[0];
           }
           if(ant.SAP_Sold_To_Account_Id__c != ant.id){
               ant.Parent_Account__c = ant.SAP_Sold_To_Account_Id__c;
           }       
           acclisttoupdate.add(ant);
       }
   }
    
}

//updation.isfutureupdate = true;


if(acclisttoupdate.size()>0)
update acclisttoupdate;*/



//////////////////////////////////////////////////////////////

//update the account record after Account Group Insert 
/*for(ccrz__E_AccountGroup__c g :accGroupList)
{
    for(Integer i=0; i<accList.size(); i++){
        if(g.ccrz__AccountGroupID__c == accList[i].id)
            accList[i].ccrz__E_AccountGroup__c = g.ccrz__AccountGroupID__c;   
    }
         
}*/

//updation.isfutureupdate = true;

//update accList;

}
}//end of add_AccountGroupCreation


//================================================================================================================================
 
//Call this function from Account Group to create Account Group Price List
//@Future
public static void add_AccountGroupPriceListSetup(Set<id> accGroupSet){
    List<ccrz__E_AccountGroup__c> accGroupList = new List<ccrz__E_AccountGroup__c>();
    Map<String, Set<ccrz__E_AccountGroupPriceList__c>> accGroupPLMap = new Map<String, Set<ccrz__E_AccountGroupPriceList__c>>();
    List<String> acclist = new List<String>();
    List<Account_Material__c> amList = new List<Account_Material__c>();
    Set<Id> cpiId = new Set<Id>();
    
    accGroupList = [select id, name, ccrz__AccountGroupID__c, Account__c, Account__r.CurrencyIsoCode, SalesArea__c, ccrz__Desc__c, ccrz__PriceListSelectionMethod__c from ccrz__E_AccountGroup__c where id in :accGroupSet];
    
    if(accGroupList.size()>0){
        for(ccrz__E_AccountGroup__c a :accGroupList){
            acclist.add(a.ccrz__AccountGroupID__c);
            System.debug('FGG acclist '+a.ccrz__AccountGroupID__c);
        }
    }
    System.debug('FGG acclist '+acclist.size());
    amList = [Select Id,Created_From_CPI__c,Account_Division_Code__c,
                Material_Division__c,Hidden__c,Account__c,SAP_Material__c,
                Account_Number__c,Account__r.Sold_To_Customer_Number__c,
                Account_Sales_Org_Code__c,Created_From_CPI__r.Distribution_Channel_Code__c,
                CPI_Deletion_Flag__c,SAP_Material__r.Record_Key__c,
                SAP_Material__r.Division_Code__c,Account__r.CurrencyIsoCode,Account__r.SAP_DivisionCode__c
                from Account_Material__c 
                where Account__c IN : acclist 
                and Hidden__c = false
                and valid_for_portal__c = true 
                and CPI_Deletion_Flag__c != 'X' 
                and Created_From_CPI__r.CPI_Record_Type__c='1'];
        
    /*for(Account_Material__c acc : amList){
        if(acc.Account_Division_Code__c == acc.Material_Division__c){
            cpiId.add(acc.Created_From_CPI__c);
        }
    }
    List<Customer_Product_Info__c>accCPIList = new List<Customer_Product_Info__c>();
    accCPIList = [Select id, Customer_Number__c, ShipTo_Number__c, Sales_Org_Code__c, CPI_Account__c, Chem_Account__c, Distribution_Channel_Code__c, Deletion_Indicator__c, SAP_Material__r.Division_Code__c, SAP_Material__r.Record_Key__c, CPI_Account__r.CurrencyIsoCode, CPI_Account__r.SAP_DivisionCode__c from Customer_Product_Info__c where CPI_Account__c IN : acclist and CPI_Record_Type__c = '1' and Deletion_Indicator__c != 'X'];
    */
    //Map<String, List<Customer_Product_Info__c>> accCPIMap = new Map<String, List<Customer_Product_Info__c>>();
    Map<String, List<Account_Material__c>> accAMMap = new Map<String, List<Account_Material__c>>();
    
    
    //System.debug('FGG Line 652 '+accCPIList.size());
    for(Account_Material__c cpi :amList)
    {
       if(accAMMap.containsKey(cpi.Account__c)) 
           accAMMap.get(cpi.Account__c).add(cpi);
       else 
           accAMMap.put(cpi.Account__c, new List<Account_Material__c>{cpi});
    
    }
    
    System.debug('FGG Line 663 '+accGroupSet);
    
    List<ccrz__E_AccountGroupPriceList__c> accGrpPriceList = new List<ccrz__E_AccountGroupPriceList__c>();
    accGrpPriceList = [Select Id, Type__c, ccrz__AccountGroup__c, ccrz__AccountGroupPriceListID__c, ccrz__Pricelist__c, ccrz__Sequence__c from ccrz__E_AccountGroupPriceList__c where ccrz__AccountGroup__c IN :accGroupSet];
    
    List<ccrz__E_AccountGroupPriceList__c> accGrpPLtoInsert = new List<ccrz__E_AccountGroupPriceList__c>();
    
    //Map<String, String> mapPL = getCPIPriceListMap();
    //System.debug('FGG 671 '+mapPL.size());
    Map<String, Set<String>> plType = new Map<String, Set<String>>();
    
    System.debug('FGG 674 '+accGrpPriceList.size());
    //Create a Map of Account Group and Set of Account Group Price List if Account Group already has some Account Group Price List records associated
    if(accGrpPriceList.size()>0){
        for(ccrz__E_AccountGroupPriceList__c p : accGrpPriceList){
            if(accGroupPLMap.containsKey(p.ccrz__AccountGroup__c))    
                accGroupPLMap.get(p.ccrz__AccountGroup__c).add(p);
            else
                accGroupPLMap.put(p.ccrz__AccountGroup__c, new Set<ccrz__E_AccountGroupPriceList__c>{p});   
    }
    }
    
    for(ccrz__E_AccountGroup__c ag :accGroupList)
    {
        if(accGroupPLMap.get(ag.id) == null)
            accGroupPLMap.put(ag.id, new Set<ccrz__E_AccountGroupPriceList__c>{});
    
    }
    
    //If no Account Group Price Lists are associated to Account Group, create AGPL records
    //This is for associating 'SalesArea - All Products' Price List 
    for(ccrz__E_AccountGroup__c ag :accGroupList){
        if(accGroupPLMap.get(ag.id).size() > 0){
            for(ccrz__E_AccountGroupPriceList__c p :accGroupPLMap.get(ag.id)){
            //check if SalesArea price list is added in Account Group
            /*if(p.Type__c == 'SalesAreaPriceList'){
                if((plType.isEmpty()) || (!plType.get(ag.id).contains('SalesAreaPriceList'))) 
                    plType.put(ag.id, new Set<String>{'SalesAreaPriceList'});}
            else */
            
            if(p.Type__c == 'CPIPriceList'){ //Check if CPIPriceList is added in the Account Group
                if(!plType.get(ag.id).contains('CPIPriceList')) {
                    plType.put(ag.id, new Set<String>{'CPIPriceList'});}
                    }
            /*else if(p.Type__c == '3DPriceList'){ //Check if 3DPriceList is added in the Account Group
                if(!plType.get(ag.id).contains('3DPriceList')) {
                    plType.put(ag.id, new Set<String>{'3DPriceList'});}
                    } */
                    }//end of for p
             } //end of accGroupPLMap.get(ag.id).size() check
             else if(accGroupPLMap.get(ag.id).size() == 0){
                 plType.put(ag.id, new Set<String>{});
             
             }
                    
                    
    }
    
    
    
    for(ccrz__E_AccountGroup__c ag :accGroupList){
    system.debug('plType.size():'+plType.size());
    system.debug('(ag.id):'+ag.id);
    if(plType.get(ag.id)!= null)
        system.debug('plType.get(ag.id):'+plType.get(ag.id).size());
        
        /*if((plType.isEmpty()) || (!plType.get(ag.id).contains('SalesAreaPriceList'))){
            ccrz__E_AccountGroupPriceList__c agpl = new ccrz__E_AccountGroupPriceList__c();
            agpl.ccrz__AccountGroup__c = ag.id;
            agpl.ccrz__Pricelist__c =  mapPL.get(ag.SalesArea__c);      
            agpl.Type__c = 'SalesAreaPriceList';
            agpl.ccrz__Sequence__c = 700;
            agpl.ccrz__AccountGroupPriceListID__c = ag.id+'-'+agpl.Type__c; 
            accGrpPLtoInsert.add(agpl);  } 
        */
            
        /*if((plType.isEmpty()) || (!plType.get(ag.id).contains('3DPriceList'))){
            ccrz__E_AccountGroupPriceList__c agpl = new ccrz__E_AccountGroupPriceList__c();
            agpl.ccrz__AccountGroup__c = ag.id;
            agpl.ccrz__Pricelist__c =  mapPL.get('nexeo3d');      
            agpl.Type__c = 'nexeo3d';
            agpl.ccrz__Sequence__c = 600;
            agpl.ccrz__AccountGroupPriceListID__c = ag.id+'-'+agpl.Type__c; 
            accGrpPLtoInsert.add(agpl);  }   */   
    } 
        
    List<ccrz__E_PriceList__c> lstCPIPList = new List<ccrz__E_PriceList__c>();
    List<ccrz__E_PriceList__c> lstPListnew = new List<ccrz__E_PriceList__c>();
    
    System.debug('FGG Line 744');
    for(ccrz__E_AccountGroup__c ag :accGroupList){
        
    System.debug('FGG Line 747 inside for accoungroup');
        
        if((plType.isEmpty()) || (!plType.get(ag.id).contains('CPIPriceList'))){        
        System.debug('FGG Line 750 inside If');
            //Call the function to create CPI Price List for account
            //and create Account Group Price List for CPI Price List
           
            System.debug('FGG Line 754 accCPIMap size '+accAMMap.size()); 
            if(!accAMMap.isEmpty() && accAMMap.get(ag.ccrz__AccountGroupID__c) != null){
            
            System.debug('FGG Line 755 inside for accCPIMap is not empty');
            system.debug('@@ ag.ccrz__AccountGroupID__c is :' +ag.ccrz__AccountGroupID__c);
            if(accAMMap.get(ag.ccrz__AccountGroupID__c).size()>0){
            System.debug('FGG Line 758 inside for accCPIMap size > 0');
                List<Account_Material__c> temp = accAMMap.get(ag.ccrz__AccountGroupID__c);
                system.debug('@@ temp.size() is :' +temp.size());
                if(temp.size()>0){
                    
            System.debug('FGG Line 763 inside if Temp size > 0');
                    lstCPIPList = create_CPI_PriceList(accAMMap.get(ag.ccrz__AccountGroupID__c));
                    System.debug('FGG lstCPIPList '+lstCPIPList);
             } }
             }
             
             else{
             if(ag.name!=''){
                   System.debug('FGG CPIPriceList '+ag.name);
                   ccrz__E_PriceList__c  recPL = new ccrz__E_PriceList__c();
                   recPL.ccrz__PricelistId__c = ag.name;
                   recPL.SalesArea__c = ag.name;
                   recPL.Name = ag.name;
                   recPL.ccrz__CurrencyISOCode__c = ag.Account__r.CurrencyIsoCode;
                   recPL.ccrz__Storefront__c = 'mynexeo';
                   recPL.PriceListType__c = 'CPIPriceList';
                   lstPListnew.add(recPL); 
                   if(lstCPIPList.isempty())
                        lstCPIPList.add(recPL);
        
                }
             
             }
                
         }
    }
    System.debug('lstPListnew.size is : '+lstPListnew.size());
    List<Database.Upsertresult> upsertPList =  new List<Database.Upsertresult>();
    upsertPList = Database.upsert(lstPListnew, ccrz__E_PriceList__c.ccrz__PricelistId__c, false);
    
    //Error handling - Store the errors in case of failure
        if(upsertPList.size()>0){
            for(integer i=0; i<upsertPList.size();i++){
                if (upsertPList.get(i).isSuccess()){
                        upsertPList.get(i).getId();
                    }
                    else if (!upsertPList.get(i).isSuccess()){
                        // Upsert DML operation failed
                        Database.Error error = upsertPList.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        lstPListnew.get(i);//failed record from the list
                        system.debug('Failed Material Record Key : '+lstPListnew.get(i).ccrz__PricelistId__c+': '+failedDML);
        
                    }
            }
        }
    system.debug('lstCPIPList.size():'+lstCPIPList.size());
    Map<String, String> mapPL = new Map<String,String>();
    //mapPL = getCPIPriceListMap();
    //Scenario: For New Users registering on website for new SAP Customer
    //Create a CPI Account Group Price List even if there is no CPI associated to the Account 
    //if(lstCPIPList.size() > 0){system.debug('inside size : 1');
    
    for(ccrz__E_PriceList__c p: lstCPIPList){
        if(!mapPL.containsKey(p.SalesArea__c)){system.debug('inside size 2:');
            mapPL.put(p.SalesArea__c, p.id);}
    
    }
    
    Set<Id> accId = new Set<Id>();
        
    for(ccrz__E_AccountGroup__c ag :accGroupList){
    
        if((plType.isEmpty()) || (!plType.get(ag.id).contains('CPIPriceList'))){
            ccrz__E_AccountGroupPriceList__c agpl = new ccrz__E_AccountGroupPriceList__c();
            agpl.ccrz__AccountGroup__c = ag.id;
            agpl.ccrz__Pricelist__c =  mapPL.get(ag.Name);      
            agpl.Type__c = 'CPIPriceList';
            agpl.ccrz__Sequence__c = 500;
            agpl.ccrz__AccountGroupPriceListID__c = ag.id+'-'+agpl.Type__c; 
            accGrpPLtoInsert.add(agpl);  }
            accId.add(ag.ccrz__AccountGroupID__c);
    }    
        
    //}
    
    if(accGrpPLtoInsert.size()>0){
    List<Database.upsertResult> insertResult =  new List<Database.upsertResult>();
    insertResult = Database.upsert(accGrpPLtoInsert, ccrz__E_AccountGroupPriceList__c.ccrz__AccountGroupPriceListID__c, false);
    
    //Error handling - Store the errors in case of failure
        if(insertResult.size()>0){
            for(integer i=0; i<insertResult.size();i++){
                if (insertResult.get(i).isSuccess()){
                        insertResult.get(i).getId();
                    }
                    else if (!insertResult.get(i).isSuccess()){
                        // Upsert DML operation failed
                        Database.Error error = insertResult.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        accGrpPLtoInsert.get(i);//failed record from the list
                        system.debug('Failed Material Record Key : '+accGrpPLtoInsert.get(i).ccrz__AccountGroupPriceListID__c +': '+failedDML);
        
                    }
            }
        }
        }
        
        
    List<Account> acnt = [select id, SAP_Sold_To_Account__c, SAP_Sold_To_Account_Id__c, ccrz__UsedByCloudcraze__c, ccrz__E_AccountGroup__c,Account_Number__c, CurrencyIsoCode from account where id in :accId];
    List<Account> acclisttoupdate = new List<account> ();
    system.debug('BBBB' + acnt);
    
    For(Account ant: acnt)
    {
       for(ccrz__E_AccountGroup__c ag: accGroupList){
           if(ant.id == ag.ccrz__AccountGroupID__c){
               ant.ccrz__E_AccountGroup__c = ag.id;
               if(ant.SAP_Sold_To_Account__c != Null && ant.SAP_Sold_To_Account__c.contains('-'))
               {
                   ant.SAP_Sold_To_Account_Number__c = ant.SAP_Sold_To_Account__c.split(' - ')[0];
               }
               if(ant.SAP_Sold_To_Account_Id__c != ant.id){
                   ant.Parent_Account__c = ant.SAP_Sold_To_Account_Id__c;
               }
               ant.cc_imp_MyProductList__c = mapPL.get(ag.Name);
               acclisttoupdate.add(ant);
           }
       }
        
    }
    
    //updation.isfutureupdate = true;
    
    
    if(acclisttoupdate.size()>0)
    update acclisttoupdate;
    
}//end of function add_AccountGroupPriceListSetup


//========================================================================================================================


//Call this function from CPI if CPI Customer is using portal
public static List<ccrz__E_PriceList__c> create_CPI_PriceList(List<Account_Material__c> cpiList){
//Check if the Customer is a Portal user and then execute the code --this is remaining!!

    Map<String, String> mapCPIPriceList = new Map<String, String>();
    Set<String> plid = new Set<String>();
    for(Account_Material__c cpi : cpiList)
        {     
            String sRecKey = cpi.Account_Number__c+cpi.Account_Sales_Org_Code__c+cpi.Created_From_CPI__r.Distribution_Channel_Code__c+cpi.Account__r.SAP_DivisionCode__c;
            plid.add(sRecKey);
        }
    mapCPIPriceList = getCPIPriceListMap(plid);
    List<ccrz__E_PriceList__c> lstCPIPList = new List<ccrz__E_PriceList__c>();
    List<ccrz__E_PriceListItem__c> lstPLI = new List<ccrz__E_PriceListItem__c>();
    
    Map<String, String> mapMatToProd = new Map<String, String>();
    List<String> prodMatId = new List<String>();
    Set<String> recKeyPLlst = new Set<String>();
    System.debug('FGG SIZE '+cpiList.size());
    System.debug('FGG cpiList '+cpiList);
    
    for(Account_Material__c cpi : cpiList)
    {    //Need to confirm the record key for this!!!
       String sRecKey = cpi.Account_Number__c+cpi.Account_Sales_Org_Code__c+cpi.Created_From_CPI__r.Distribution_Channel_Code__c+cpi.Account__r.SAP_DivisionCode__c;   
       //String sRecKey = cpi.ShipTo_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c+cpi.CPI_Account__r.SAP_DivisionCode__c;   
       
       system.debug('sRecKey :'+sRecKey);
       System.debug('FGG Line 887 '+mapCPIPriceList.size());
       System.debug('FGG Line 888 '+mapCPIPriceList);
       if(mapCPIPriceList.isEmpty() || !mapCPIPriceList.containsKey(sRecKey))
       {
        System.debug('FGG Line 891 Inside If');
               if(!recKeyPLlst.contains(sRecKey)){
                   ccrz__E_PriceList__c  recPL = new ccrz__E_PriceList__c();
                   recPL.ccrz__PricelistId__c = sRecKey;
                   recPL.SalesArea__c = sRecKey;
                   recPL.Name = sRecKey;
                   recPL.ccrz__CurrencyISOCode__c = cpi.Account__r.CurrencyIsoCode;
                   recPL.ccrz__Storefront__c = 'mynexeo';
                   recPL.PriceListType__c = 'CPIPriceList';
                   lstCPIPList.add(recPL);
               recKeyPLlst.add(sRecKey);}
        }
        prodMatId.add(cpi.SAP_Material__r.Record_Key__c);
    }
    
    mapMatToProd = getMatToProdMap(prodMatId);
    
    
    System.debug('lstCPIPList.size is : '+lstCPIPList.size());
    System.debug('FGG lstCPIPList.size '+lstCPIPList);
    List<Database.Upsertresult> upsertPList =  new List<Database.Upsertresult>();
    upsertPList = Database.upsert(lstCPIPList, ccrz__E_PriceList__c.ccrz__PricelistId__c, false);
    
    //Error handling - Store the errors in case of failure
        if(upsertPList.size()>0){
            for(integer i=0; i<upsertPList.size();i++){
                if (upsertPList.get(i).isSuccess()){
                        upsertPList.get(i).getId();
                    }
                    else if (!upsertPList.get(i).isSuccess()){
                        // Upsert DML operation failed
                        Database.Error error = upsertPList.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        lstCPIPList.get(i);//failed record from the list
                        system.debug('Failed Material Record Key : '+lstCPIPList.get(i).ccrz__PricelistId__c+': '+failedDML);
        
                    }
            }
        }
    System.debug('FGG lstCPIPList'+lstCPIPList.size());
    if(lstCPIPList.size()>0){
        //lstPListNew = [Select SalesArea__c, id from ccrz__E_PriceList__c where SalesArea__c IN =: ];
        //Map<String, String> mapPriceListNew = new Map<String, String>(lstPListNew); 
        mapCPIPriceList = getCPIPriceListMap(plid);
    }
    
    Set<String> recKeyPLIlst = new Set<String>();
    
    for(Account_Material__c cpi : cpiList)
    {
       //Need to decide on this key 
       String sRecKey = cpi.Account_Number__c+cpi.Account_Sales_Org_Code__c+cpi.Created_From_CPI__r.Distribution_Channel_Code__c+cpi.Account__r.SAP_DivisionCode__c;
       //String sRecKey = cpi.ShipTo_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c+cpi.CPI_Account__r.SAP_DivisionCode__c;
       system.debug('sRecKey:'+sRecKey);
       
       if(!recKeyPLIlst.contains(sRecKey)){         
           ccrz__E_PriceListItem__c PLI = new ccrz__E_PriceListItem__c();
           
           if(mapCPIPriceList.containsKey(sRecKey))
               PLI.ccrz__Pricelist__c = mapCPIPriceList.get(sRecKey);
           //get the product record for corresponding SAP Material record
           if(mapMatToProd.containsKey(cpi.SAP_Material__r.Record_Key__c))
               PLI.ccrz__Product__c = mapMatToProd.get(cpi.SAP_Material__r.Record_Key__c);
           PLI.ccrz__Price__c = 0;
           PLI.ccrz__PricelistItemId__c = PLI.ccrz__Pricelist__c+'-'+PLI.ccrz__Product__c+'-'+cpi.id;
           //PLI.CPI_Deletion_Indicator__c = cpi.Deletion_Indicator__c;
           PLI.CPI__c = cpi.Created_From_CPI__c;
           PLI.Account_Material__c = cpi.id;
           system.debug('PLI.ccrz__PricelistItemId__c:'+PLI.ccrz__PricelistItemId__c);
           lstPLI.add(PLI);
           recKeyPLIlst.add(PLI.ccrz__PricelistItemId__c);
       }
    
    }
    
    //upsert the CPI related Price List Item in CPI Price List
    List<Database.Upsertresult> upsertPLI =  new List<Database.Upsertresult>();
    upsertPLI = Database.upsert(lstPLI, ccrz__E_PriceListItem__c.ccrz__PricelistItemId__c, false);
    
    //Error handling - Store the errors in case of failure
        if(upsertPLI.size()>0){
            for(integer i=0; i<upsertPLI.size();i++){
                if (upsertPLI.get(i).isSuccess()){
                        upsertPLI.get(i).getId();
                        system.debug('Material Upserted : '+lstPLI.get(i).ccrz__PricelistItemId__c+' Material '+lstPLI.get(i).ccrz__Product__c);
                    }
                    else if (!upsertPLI.get(i).isSuccess()){
                        // Upsert DML operation failed
                        Database.Error error = upsertPLI.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        lstPLI.get(i);//failed record from the list
                        system.debug('Failed Material Record Key : '+lstPLI.get(i).ccrz__PricelistItemId__c+'Material '+lstPLI.get(i).ccrz__Product__c+': '+failedDML);
        
                    }
            }
        }
    
    return lstCPIPList;
    }//end of create_CPI_PriceList function
    
    //========================================================================================================================

public static void create_newCPI_CCProduct(List<Customer_Product_Info__c> cpiList){

    List<Material_Sales_Data2__c> lstMaterials = new List<Material_Sales_Data2__c>();
    List<Material_Sales_Data2__c> lstMaterialsToUpdate = new List<Material_Sales_Data2__c>();
    List<Id> lstMaterialIds = new List<Id>();
    
    for(Customer_Product_Info__c cpi :cpiList){
            lstMaterialIds.add(cpi.SAP_Material__c);
    }
        
    lstMaterials = [Select Id, Create_CC_Product__c from Material_Sales_Data2__c where Id IN : lstMaterialIds];
        
    for(Material_Sales_Data2__c msd :lstMaterials){
       if(msd.Create_CC_Product__c == false)
          msd.Create_CC_Product__c = true; 
          lstMaterialsToUpdate.add(msd);
     }
        
     update lstMaterialsToUpdate;


}


//========================================================================================================================

//Call this function from CPI to add/update CPI item in CPIPrice List if CPI Customer is using portal
public static void update_CPI_PriceList(List<Account_Material__c> amList){

    Map<String, String> mapPL = new Map<String, String>();
    Map<String, String> mapCpiMaterial = new Map<String, String>();
    Map<String, String> mapCpiId = new Map<String, String>();
    Map<String, String> mapPLItem = new Map<String, String>();
    List<ccrz__E_PriceListItem__c> plItemList = new List<ccrz__E_PriceListItem__c>(); 
    List<ccrz__E_PriceList__c> plst = new List<ccrz__E_PriceList__c>();
    List<ccrz__E_PriceListItem__c> lstPLI = new List<ccrz__E_PriceListItem__c>();
    List<String> keyList = new List<String>();
    List<id> matId = new List<id>();
    List<Material_Sales_Data2__c> lstMaterialsToUpdate = new List<Material_Sales_Data2__c>();
    List<Id> lstMaterialIds = new List<Id>();
    List<Account_Material__c> cpiList = new List<Account_Material__c>();
    Set<id> accids = new Set<id>();
    
    for(Account_Material__c am : amList){
        if(am.Account__c !=null){
            accids.add(am.Account__c);
        }
    }
    
    if(!accids.isempty()){
        cpiList = [Select Id,Account__c,Account__r.ccrz__UsedByCloudcraze__c,Account_Number__c,
                          Account_Sales_Org_Code__c,Created_From_CPI__c,Created_From_CPI__r.Distribution_Channel_Code__c,
                          Account__r.SAP_DivisionCode__c,SAP_Material__c,Account__r.Type,SAP_Material__r.Create_CC_Product__c,
                          SAP_Material__r.Division_Code__c
                    from Account_Material__c
                    where Account__c In:accids 
                    and Account__r.ccrz__UsedByCloudcraze__c = true 
                    and Account__r.Type = 'Customer'
                    and Hidden__c = false 
                    and valid_for_portal__c = true 
                    and CPI_Deletion_Flag__c != 'X' 
                    and Created_From_CPI__r.CPI_Record_Type__c='1'];
    }
    
    for(Account_Material__c cpi :cpiList){
         if(cpi.SAP_Material__r.Create_CC_Product__c == false){
            lstMaterialIds.add(cpi.SAP_Material__r.id);}
        }
        
    lstMaterialsToUpdate = [Select Id, Create_CC_Product__c from Material_Sales_Data2__c where Id IN : lstMaterialIds];
    
    for(Material_Sales_Data2__c msd : lstMaterialsToUpdate){
        msd.Create_CC_Product__c = true;
    }
       
    if(lstMaterialsToUpdate.size()>0) {
        update lstMaterialsToUpdate;}
    
    for(Account_Material__c cpi: cpiList)
    {              
        matId.add(cpi.SAP_Material__c);
        //Need to decide on this key
        String sRecKey = cpi.Account_Number__c+cpi.Account_Sales_Org_Code__c+cpi.Created_From_CPI__r.Distribution_Channel_Code__c+cpi.Account__r.SAP_DivisionCode__c;
        //String sRecKey = cpi.ShipTo_Number__c+cpi.Sales_Org_Code__c+cpi.Distribution_Channel_Code__c+cpi.SAP_Material__r.Division_Code__c;    
        keyList.add(sRecKey);
        system.debug('sRecKey:'+sRecKey);
        String CPIrecKey = cpi.Account_Number__c+cpi.Account_Sales_Org_Code__c+cpi.Created_From_CPI__r.Distribution_Channel_Code__c+cpi.Account__r.SAP_DivisionCode__c+'-'+cpi.SAP_Material__c;    
   
        if(mapPL.isEmpty() || !mapPL.containsKey(sRecKey))
            mapPL.put(sRecKey, cpi.id);
        
        if(mapCpiMaterial.isEmpty() || !mapCpiMaterial.containsKey(CPIrecKey)){
           mapCpiMaterial.put(CPIrecKey, cpi.Id);
           if(cpi.Created_From_CPI__c != null)
              mapCpiId.put(CPIreckey,cpi.Created_From_CPI__c);
        }
    
        system.debug('Initial mapCpiMaterial.size: '+mapCpiMaterial.size());

    }
    system.debug('matId:'+matId);
    List<ccrz__E_Product__c> prodList = [select id, name, SAP_Material__c from ccrz__E_Product__c where SAP_Material__c in : matId ];
    system.debug('prodList.size is :'+prodList.size());
    
    if(keyList.size()>0)
    {
        plItemList = [select id, ccrz__Pricelist__r.Id,ccrz__Pricelist__r.Name, ccrz__Pricelist__c, ccrz__Product__c,ccrz__Product__r.SAP_Material__c from ccrz__E_PriceListItem__c where ccrz__Pricelist__r.Name in:keyList];
        
    }
    system.debug('plItemList.size is :'+plItemList.size());
    if(plItemList.size()>0)
    
    {
        For(ccrz__E_PriceListItem__c plilist: plItemList)
        {
            String plItemKey = plilist.ccrz__Pricelist__r.Name+'-'+plilist.ccrz__Product__r.SAP_Material__c;
             if(mapPLItem.isEmpty() || !mapPLItem.containsKey(plItemKey))
                mapPLItem.put(plItemKey, plilist.ccrz__Product__c);
        }       
        system.debug('mapPLItem: '+mapPLItem.Keyset());
    
    }
    List<ccrz__E_PriceList__c> listPriceList = [select Id,Name from ccrz__E_PriceList__c where Name in:keyList];
    
    
        system.debug('mapCpiMaterial.Keyset() : '+mapCpiMaterial.Keyset());
        for(String keyId: mapCpiMaterial.Keyset()){
           if(mapPLItem.keyset().contains(keyId)){
               system.debug('Entered if : ');
               mapCpiMaterial.remove(keyId);
           }
        }
        system.debug('mapCpiMaterial.size() is '+mapCpiMaterial.size());       
   
        for(String keyId:mapCpiMaterial.Keyset()){
            if(listPriceList.size()>0){
                for(ccrz__E_PriceList__c c: listPriceList){
                    if(c.Name!= ''  && c.name == keyId.split('-')[0]){
                        if(prodList.size()>0){
                            system.debug('Entered Second for');
                            for(ccrz__E_Product__c p: prodList){
                                if(p.Sap_Material__c != null && p.Sap_Material__c == keyId.split('-')[1]){
                                    system.debug('Entered Third for');
                                    ccrz__E_PriceListItem__c PLI = new ccrz__E_PriceListItem__c();      
                                    PLI.ccrz__Pricelist__c = c.id;            
                                    PLI.ccrz__Product__c = p.id;
                                    PLI.ccrz__Price__c = 0;
                                    PLI.ccrz__PricelistItemId__c = PLI.ccrz__Pricelist__c+'-'+PLI.ccrz__Product__c+'-'+mapCpiMaterial.get(keyId);
                                    PLI.CPI__c = mapCpiId.containskey(keyId) ? mapCpiId.get(keyId) : null;
                                    PLI.Account_Material__c = mapCpiMaterial.get(keyId);
                                    system.debug('PLI.ccrz__PricelistItemId__c:'+PLI.ccrz__PricelistItemId__c);
                                    lstPLI.add(PLI);                                                                              
                                 
                                 }
                              }
                          }    
                      }
                  }
               }                
           }
        

         
   
   system.debug('lstPLIsize:'+lstPLI.size()); 
   system.debug('lstPLIsize:'+lstPLI);

        if(lstPLI.size()>0){
        //upsert the CPI related Price List Item in CPI Price List
        List<Database.Upsertresult> upsertPLI =  new List<Database.Upsertresult>();
        upsertPLI = Database.upsert(lstPLI, ccrz__E_PriceListItem__c.ccrz__PricelistItemId__c, false);
        
        //Error handling - Store the errors in case of failure
            if(upsertPLI.size()>0){
                for(integer i=0; i<upsertPLI.size();i++){
                    if (upsertPLI.get(i).isSuccess()){
                            upsertPLI.get(i).getId();
                        }
                        else if (!upsertPLI.get(i).isSuccess()){
                            // Upsert DML operation failed
                            Database.Error error = upsertPLI.get(i).getErrors().get(0);
                            String failedDML = error.getMessage();
                            lstPLI.get(i);//failed record from the list
                            system.debug('Failed Material Record Key : '+lstPLI.get(i).ccrz__PricelistItemId__c+': '+failedDML);
            
                        }
                   }
             }
        } 
    }

}