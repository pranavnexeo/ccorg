@istest
public class cc_mn_EmailTemplateControllerTest{
    public static testMethod void cc_mn_EmailTemplateController(){
        cc_mn_EmailTemplateController emailctrl = new cc_mn_EmailTemplateController();
        emailctrl.Receiving_User_FirstName = '';
        emailctrl.Receiving_User_LastName  = '';
        emailctrl.Receiving_User_Email     = '';
        emailctrl.Community_Url            = '';
        emailctrl.userLocale               = '';
        emailctrl.BuyerName_FirstName      = '';
        emailctrl.BuyerName_LastName       = '';
        emailctrl.Contact_FirstName        = '';
        emailctrl.Contact_LastName         = '';
        emailctrl.User_FirstName           = '';
        emailctrl.User_LastName            = '';
        emailctrl.ContactId                = '';
        emailctrl.ContactFirstName         = '';
        emailctrl.ContactLastName          = '';
        emailctrl.OrderId                  = '';
        emailctrl.userLocale1 = '';
        emailctrl.setUpCompleteLoad();
        emailctrl.getReceiving_User();
    }
}