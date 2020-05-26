@isTest
private class PDF_Functions_Test{
    
              
    static testMethod void myPDFFunctionTest(){
      Test.startTest();

        String pageref='';
        String parentid='001E000000CVGcN';
        String name='test.pdf';
        String pdfName='test';
        PageReference p = null;
        //PDF_Functions testpdf = new  PDF_Functions(); 
               
        //Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        
        PageReference p1 = new PageReference( '/apex/PDF_Functions' );
        //pdfPage.getParameters().put('id',id);           
        //Blob pdfBlob = pdfPage.getContent();
        
        //Attachment a = new Attachment(ParentId=ParentId, name=name, body = bodyBlob); 
        //insert a;
        //testpdf.a.name='sdgdfh'; 
         //testpdf.a.body=bodyBlob;
  
         Attachment a1 = PDF_Functions.CreatePDFAttachmentFromPageReference(pageref,name);
        // Attachment a2 = PDF_Functions.CreatePDFAttachmentFromPageReference(pageref,parentid,name);
        // Attachment a3 = PDF_Functions.CreatePDFAttachmentFromPageReference(p1,parentid,name);
        // Attachment a4 = PDF_Functions.CreatePDFAttachmentFromPageReference(p,name);
         //Blob b = PDF_Functions.CreatePDFBlobFromPageReference(pageref,parentid);
       
        Test.stopTest();
        }
        static testMethod void myPDFFunctionTest2(){
      Test.startTest();

        String pageref='';
        String parentid='001E000000CVGcN';
        String name='test.pdf';
        String pdfName='test';
        PageReference p = null;
        
        PageReference p1 = new PageReference( '/apex/PDF_Functions' );
        
         Attachment a2 = PDF_Functions.CreatePDFAttachmentFromPageReference(pageref,parentid,name);
              
        Test.stopTest();
        }
        static testMethod void myPDFFunctionTest3(){
      Test.startTest();

        String pageref='';
        String parentid='001E000000CVGcN';
        String name='test.pdf';
        String pdfName='test';
        PageReference p = null;
        
        PageReference p1 = new PageReference( '/apex/PDF_Functions' );
        
          Attachment a3 = PDF_Functions.CreatePDFAttachmentFromPageReference(p1,parentid,name);
              
        Test.stopTest(); 
        }
        static testMethod void myPDFFunctionTest4(){
      Test.startTest();

        String pageref='';
        String parentid='001E000000CVGcN';
        String name='test.pdf';
        String pdfName='test';
        PageReference p = null;
        //PDF_Functions testpdf = new  PDF_Functions(); 
               
        //Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        
        PageReference p1 = new PageReference( '/apex/PDF_Functions' );
        //pdfPage.getParameters().put('id',id);           
        //Blob pdfBlob = pdfPage.getContent();
        
        //Attachment a = new Attachment(ParentId=ParentId, name=name, body = bodyBlob); 
        //insert a;
        //testpdf.a.name='sdgdfh'; 
         //testpdf.a.body=bodyBlob;

     
        // Attachment a4 = PDF_Functions.CreatePDFAttachmentFromPageReference(p,name);
           Blob b = PDF_Functions.CreatePDFBlobFromPageReference(pageref,parentid);
       
        Test.stopTest(); 
        }
        static testMethod void myPDFFunctionTest5(){
      Test.startTest();

        String pageref='';
        String parentid='001E000000CVGcN';
        String name='test.pdf';
        String pdfName='test';
       // PageReference p = null;
        //PDF_Functions testpdf = new  PDF_Functions(); 
               
        //Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        
        PageReference p1 = new PageReference( '/apex/PDF_Functions' );
        //pdfPage.getParameters().put('id',id);           
        //Blob pdfBlob = pdfPage.getContent();
        
        //Attachment a = new Attachment(ParentId=ParentId, name=name, body = bodyBlob); 
        //insert a;
        //testpdf.a.name='sdgdfh'; 
         //testpdf.a.body=bodyBlob;
             
           Attachment a4 = PDF_Functions.CreatePDFAttachmentFromPageReference(p1,name);
                  
        Test.stopTest(); 
        
    }
}