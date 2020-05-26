Public class cc_imp_mn_ViewSDSDoc
{
    public string strMaterialID;
    public string doc{get;set;}
    public id docId{get;set;}
    public string strBatchNumber;
    public string StrDocType;
    public string sfid;
    public string strinvoiceID;
    public pagereference ViewSDSDoc()
    {
        strMaterialID= ApexPages.currentPage().getParameters().get('materialId');
        strBatchNumber= ApexPages.currentPage().getParameters().get('batchNumber');
        StrDocType = ApexPages.currentPage().getParameters().get('StrDocType');
        sfid= ApexPages.currentPage().getParameters().get('sfid');
        strinvoiceID= ApexPages.currentPage().getParameters().get('invoiceID');
        doc = '';
        system.debug('StrDocType =='+StrDocType );
        if(StrDocType != null )
        {
            if(StrDocType =='SDS')
            {
               docId= fetchSDSAttachment(strMaterialID,sfid);
            }
            else if(StrDocType =='COA')
            {
                docId= fetchCOAAttachment(strMaterialID,strBatchNumber,sfid);
            }
            else if(StrDocType =='invoice')
            {
               docId= fetchMyInvoiceAttachment( strinvoiceID, sfid);
            }
            doc=docId;
        }
        return null;
    }
    public id fetchSDSAttachment( String materialId,string sfid) {
        cc_mn_json_MSDSResponse sdsCallOutResponse = cc_mn_api_FetchSDS.fetchMSDS(materialId);
        String theId = null;
        if (!String.isBlank(sdsCallOutResponse.document)) {
            theId = InsertAttachment(materialId,sfid,sdsCallOutResponse.document); 
            
        }
        return theId ;
    }
    public id fetchCOAAttachment( String materialId,String batchNumber,string sfid) 
    {
        cc_mn_json_CofAResponse calloutResponse = cc_mn_api_CofA.fetchCofA(ccrz.cc_CallContext.storefront,materialId, batchNumber);
        String theId = null;
        if (!String.isBlank(callOutResponse.document)) {
            theId = InsertAttachment((materialId + '-' + batchNumber),sfid,callOutResponse.document); 
        }

        system.debug('theId=='+theId);
        return theId ;
    }
    public id  fetchMyInvoiceAttachment( String invoiceId, String sfid)
    {
        cc_mn_json_myInvoiceResponse invoiceCallOutResponse = cc_mn_api_FetchInvoice.fetchMyInvoiceEncodedPdf(invoiceId);
        String theId = null;
        if (!String.isBlank(invoiceCallOutResponse.document)) {
            theId = InsertAttachment(invoiceId,sfid,invoiceCallOutResponse.document);
        }
        return theId ;
    }
    
    public id InsertAttachment(string Docname,string sfid,string doc)
    {
        Attachment attach = new Attachment(Name = Docname + '.pdf', Description = cc_imp_mn_AttachmentCleanup.ATTACHMENT_DESCRIPTION, ParentId = sfid);
        attach.body = EncodingUtil.base64Decode(doc);
        insert attach;
        return attach.id;
    }
}