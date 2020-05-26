public with sharing class cc_mn_ctrl_ViewArchivedPriceLetterDoc {
    
    public Id docIds { get; set; }
    public Id docId { get; set; }
    public String doc { get; set; }
    public String sfid;
    
    
    public pagereference viewPriceLetterDoc(){
        sfid = ApexPages.currentPage().getParameters().get('sfid');
        doc = sfid;
        docIds = Id.valueOf(sfid);
        
        if( sfid != null ) {    
            docId = Id.valueOf(sfid);
            Attachment att = [SELECT Body,BodyLength,ContentType,CreatedById,CreatedDate,Description,Id,IsDeleted,IsPrivate,LastModifiedById,LastModifiedDate,Name,OwnerId,ParentId FROM Attachment WHERE Id =: docId];
        }
        
     	return null;   
    }
}