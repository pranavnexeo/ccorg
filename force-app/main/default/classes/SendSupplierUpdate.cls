public class SendSupplierUpdate{

public List<WrapperClass> contacts{Get; set;}
private id supid{Get; set;}
private string supname{Get; set;}
private string templateid{get; set;}
public Supplier_Page_Document_Folder__c SupDocs;

public SendSupplierUpdate(apexpages.standardcontroller sc){
  supid = apexpages.currentpage().getparameters().get('pid');
  supname = apexpages.currentpage().getparameters().get('supname');
  
  contacts = new List<WrapperClass>();
  //List<Supplier_Page_Emails__c> SuppEmails = Supplier_Page_Emails__c.getall().values();
  List<Supplier_Page_Emails__c> SuppEmails = [SELECT Id, Email__c, Name FROM Supplier_Page_Emails__c ORDER BY NAME ASC];
  for(Supplier_Page_Emails__c c: SuppEmails){
      if(c.Email__c!=null){
    contacts.add(new wrapperclass(c));
    }
  }
  
  
}

public class wrapperclass{
  public boolean selected{get; set;}
  public Supplier_Page_Emails__c sc{get; set;}
  public wrapperclass(Supplier_Page_Emails__c sc){
    this.sc = sc;
    selected = false;
  }
}

public pagereference sendEmail(){
            
  List<String> emails = new list<String>();
  
  for(WrapperClass w:contacts){
    if(w.selected)
      emails.add(w.sc.email__c);
  }  
  
  //string url = '/_ui/core/email/author/EmailAuthor?p3_lkid=' + supid + '&retURL=%2F' + supid + '&p24=' + String.join(emails, ',') + '&doc_id='+getCreatedDocId();
  getCreatedDocId();
  string url = '/_ui/core/email/author/EmailAuthor?p3_lkid=' + supid + '&retURL=apex/SendSupplierUpdate?pid=' + supid + '&p24=' + String.join(emails, ',')+'&textmode=r';
  System.debug('Send URL:'+url);
  
  return new pagereference(url);
}

public String getCreatedDocId(){

            SupDocs = Supplier_Page_Document_Folder__c.getInstance('Supplier Page documents');
            
            Blob content;            

            PageReference pr = Page.SavePDFSupplierPage;

            pr.setRedirect(true);

            pr = Page.SavePDFSupplierPage;

            pr.setRedirect(true);

            pr.getParameters().put('ids', supid);

            
            if(!Test.isRunningTest()){

                content = pr.getContentAsPDF();

            }
      
            Document doc = new Document(Name = supname+'_BaseCodes.PDF', Body = content, FolderId = SupDocs.Folder_Id__c, Description='Material base code details salesforce'); //'005E0000004zCLh');

            Database.SaveResult insertResult = Database.Insert(doc, true);
            
           
            /*Database.deleteResult[] srList = Database.delete(docs, false);
                for(Database.DeleteResult dr : srList) {

        if (dr.isSuccess()) {

            // Operation was successful, so get the ID of the record that was processed

            System.debug('Successfully deleted account with ID: ' + dr.getId());

        }

        else {

            // Operation failed, so get all errors               

            for(Database.Error err : dr.getErrors()) {

                System.debug('The following error has occurred.');                   

                System.debug(err.getStatusCode() + ': ' + err.getMessage());

                System.debug('Account fields that affected this error: ' + err.getFields());

            }

        }

    }    */  
             
            
            return doc.Id;
            

       }
        
       
}