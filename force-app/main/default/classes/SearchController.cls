public with sharing class SearchController {

public String searchstring;
public string searchtype;
public String s;
public String myurl;
public string objprefix;
    
public PageReference findsomething() {
        searchstring = apexpages.currentpage().getparameters().get('searchstring');
        searchtype = apexpages.currentpage().getparameters().get('searchtype');
        s = '';
        myurl = '';
        
        String[] sarray;
        if(searchstring.startswith('*')){
        searchstring = searchstring.substring(1);}
        sarray = searchstring.split('\\*');
        
        for(integer i = 0; i<sarray.size(); i++){
        if(i == 0){ s = '%22' + sarray[i] + '%22'; }
        else{ s = s + '+AND+%22' + sarray[i] + '%22';}
        }     
        
        
        if(searchtype == 'Case'){
        objprefix = ObjectPrefixFunctions.getObjectKeyPrefix(searchtype);
        myurl = '/apex/DZ_Search?searchstring=' + searchstring;
        
        }else if(searchtype == 'Prospect'){
        
        objprefix = ObjectPrefixFunctions.getObjectKeyPrefix('Account'); 
        myurl = '/search/SearchResults?searchType=2&str=' + s +  ' and %22Prospect%22&search=Search&sen=' + objprefix;
        }
        else{
        objprefix = ObjectPrefixFunctions.getObjectKeyPrefix(searchtype);
        myurl = '/search/SearchResults?searchType=2&str=' + s + '&search=Search&sen=' + objprefix; 
        }
        
        
        pagereference pr = new pagereference(myurl);
        
        
        return pr;
    }

}