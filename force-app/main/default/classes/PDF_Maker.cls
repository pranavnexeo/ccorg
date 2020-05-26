Public Class PDF_Maker{
Private String Id{Get; set;}
Private String PDF_Page{get; set;}
private String FileName{get; set;}
private String PDFURL{Get; set;}
public String returl{get; set;}



Public PDF_Maker(){
id = ApexPages.currentPage().getParameters().get('id');
PDF_Page = ApexPages.currentPage().getParameters().get('PDF');
FileName = ApexPages.currentPage().getParameters().get('f');
if(ApexPages.currentPage().getParameters().containskey('returl'))
   returl = APexPages.currentPage().getParameters().get('returl');
else
   returl = '/' + id;
   
Set<String> parameters = new set<String>{'id', 'PDF', 'f', 'returl'};
PDFURL = '/apex/' + PDF_Page + '?id=' + id;
for(String s:ApexPages.currentPage().getParameters().values())
 IF( !parameters.contains(s))
  PDFURL += '&' + s + '=' + ApexPages.currentPage().getParameters().get(s);

}

Public pagereference makePDF(){
  Attachment a = PDF_Functions.CreatePDFAttachmentFromPageReference(new pagereference(PDFURL), FileName);
  a.parentid = id;
  insert a;
  return new pagereference(returl);
}


}