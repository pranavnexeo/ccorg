public with sharing class redirecttomassemailcontacts{

private string redirecturl;

   public redirecttomassemailcontacts(){
      redirecturl = '/ui/massmail/MassMailStageManager?setupid=MassMailFilter&mm_type=Contact&wizardRetUrl=%2F003%2Fo';
   }
   
   public pagereference redirect(){
      return new pagereference(redirecturl);
   }
}