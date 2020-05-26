Public Class PDF_Functions{

Public static attachment CreatePDFAttachmentFromPageReference(String pageref, String Name){
   PageReference pdfPage = new pagereference(pageref);   
 //  Blob pdfBlob = pdfPage.getContent();
   Blob pdfBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pdfPage.getContent();
   return new Attachment(name=name + '.pdf', body = pdfBlob);

}

Public static attachment CreatePDFAttachmentFromPageReference(String pageref, String ParentId, String Name){
     PageReference pdfPage = new pagereference(pageref);   
     pdfPage.getParameters().put('id', ParentId); 
    // Blob pdfBlob = pdfPage.getContent();
    Blob pdfBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pdfPage.getContent();
     return new Attachment(ParentId=ParentId, name=name + '.pdf', body = pdfBlob);
}

Public static attachment CreatePDFAttachmentFromPageReference(PageReference pdfpage, String ParentId, String Name){
     /* set the quote id on the page definition */
     pdfPage.getParameters().put('id', ParentId);    
    // Blob pdfBlob = pdfPage.getContent();  
     Blob pdfBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pdfPage.getContent();
     return new Attachment(ParentId=ParentId, name=name + '.pdf', body = pdfBlob);

}

Public static attachment CreatePDFAttachmentFromPageReference(PageReference pdfpage, String Name){
     //Blob pdfBlob = pdfPage.getContent();
      Blob pdfBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pdfPage.getContent();
     return new Attachment(name=name + '.pdf', body = pdfBlob);

}

Public static blob CreatePDFBlobFromPageReference(String pageref, String ParentId){
     PageReference pdfPage = new pagereference(pageref);   
     /* set the quote id on the page definition */
     pdfPage.getParameters().put('id', ParentId);   
     /* generate the pdf blob */
    // Blob pdfBlob = pdfPage.getContent();
     //Blob pdfBlob = pdfPage.getContentaspdf();
     Blob pdfBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pdfPage.getContentaspdf();
     return PDFBlob;   
}


}