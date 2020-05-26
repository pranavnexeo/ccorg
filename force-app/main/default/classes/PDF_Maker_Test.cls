@isTest
private class PDF_Maker_Test{
    static String Id;
    static String PDF_Page;
    static String FileName;
    static String PDFURL;
    static String returl; 
     
    static testMethod void myPDFMakerTest(){
        Test.startTest(); 
        APexPages.currentPage().getParameters().put('returl','returl');
        APexPages.currentPage().getParameters().put('returl','');
        //List<String> s = ApexPages.currentPage().getParameters().values();
         //IF( !parameters.contains(s))
         //String parameters = '';
  //PDFURL += '&' + s + '=' + ApexPages.currentPage().getParameters().get(s);

        /*Blob b = Blob.valueOf('Test Data');   

        Attachment att = new Attachment();
          att.parentid = parentid;
          att.Name = 'pdf Attachment';
          att.Body = b;
          insert att;*/
  /*String encodedContentsString = System.currentPageReference().getParameters().get('fileContents');
  Id accountId = System.currentPageReference().getParameters().get('accountID');
  
  Attachment a = new Attachment();
  a.Body = Blob.valueOf(encodedContentsString);
  a.Name = String.valueOf('test.txt');
  a.ParentId = accountId; 
  insert a;*/ 
        PDF_Maker pm = new PDF_Maker();
      try{
      pm.makepdf();
        }catch(exception e){}
        Test.stopTest();        
    }
}