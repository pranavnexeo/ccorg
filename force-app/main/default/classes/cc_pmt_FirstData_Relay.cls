public with sharing class cc_pmt_FirstData_Relay {
    public String theJSON {get;private set;}

    public cc_pmt_FirstData_Relay() {
        
    }
    // Have to post to the 'true' URL:
    // https://c.na30.visual.force.com/apex/AuthNetResults
    // not
    // https://na30.salesforce.com/apex/AuthNetResults
    // For craze02 -- https://c.cs42.visual.force.com/apex/cc_bos_AuthNetResults
    /**
     *
     *  This method does NOT place the order for the user.  It is expected that the returned page will
     *  use front-end logic to advance to the order confirmation page
     */
    public static final String storefront = 'Store';
    public void postPaymentResponse(){
        theJSON = JSON.serialize(ApexPages.currentPage().getParameters());
        theJSON = theJSON.replaceAll('\\\\', '\\\\\\\\');
        System.debug('AuthNetResults json: ' + theJSON);
    }
}