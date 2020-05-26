@isTest

public class CustomException_Test{

    public static testMethod void testMe(){
        test.startTest();
        list<string> msgs = new list<string>();
        string str = 'test message';
        msgs.add(str);
        try{
            CustomException.throwException(msgs);
        }
        catch(exception e){
            try{
                CustomException.throwException(e);
            }
            catch(exception ex){
            
            }
        }
        test.stopTest();
    }
}