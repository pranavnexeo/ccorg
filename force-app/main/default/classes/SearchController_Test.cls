@isTest
    private class SearchController_Test {
        public static testMethod void testSearchController() {
        SearchController sc = new SearchController();
        //sc.searchstring = 'test123';
        //sc.searchtype = 'test1234';
        sc.s          = 'test12345';
        sc.myurl      = 'test123456';
        sc.objprefix  = 'test1234567';
        apexpages.currentpage().getparameters().put('searchstring','*12');
        apexpages.currentpage().getparameters().put('searchtype','Prospect');
        sc.findsomething();        
        }
    }