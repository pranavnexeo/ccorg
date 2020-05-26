@isTest
private class google_places_result_test{
static testMethod void myUnitTest() {
        list<string> si = new list<string>();
        si.add('test');
        List<google_places_result.event> events = new list<google_places_result.event>();
        events.add(new google_places_result.event('t',2,'t','t'));
        
        list<google_places_result.address_component> adcomp = new list<google_places_result.address_component>();
        adcomp.add(new google_places_result.address_component('test','test',si) );
        
        google_places_result.geometry g = new google_places_result.geometry(new google_places_result.location(12,54,7,3, 8),'test1');
        
        list<google_places_result.photo> plist = new list<google_places_result.photo>();
        plist.add(new google_places_result.photo('test',56,43,si));
        
        list<google_places_result.day_time>  day_time = new list<google_places_result.day_time>();
        day_time.add(new google_places_result.day_time(1,2));
        
        list<google_places_result.period> p1 = new list<google_places_result.period>();
        
        
        google_places_result.Opening_Hours o = new google_places_result.Opening_Hours(true,p1, '');
        Integer x =2;
        Double y =22;
        string t = 'test';
       
        google_places_result gg = new google_places_result(x, t, t, y, t, adcomp, g, t, t, plist, si, o,events, t, t, t, t, si);



}
}