public class hours_of_operation{

public SAP_Plant__c plant{get; set;}

public hours_of_operation(apexpages.standardcontroller sc){
  plant = (SAP_Plant__c)sc.getrecord();
  plant = [select id, name, Time_Zone__c from SAP_Plant__c where id = :plant.id limit 1];
  
}
@RemoteAction 
public static void updateTimeZone(string id, string tz){
  
  Map<string, double> offset = new Map<string, double>();
        Offset.put('EST',  0);
        Offset.put('CST',  -60);
        Offset.put('MST',  -120);
        Offset.put('PST',  -180);
  List<string> fields = new list<String>{'Hours_of_Operation', 'Carrier_Pickup_Hours', 'Carrier_Delivery_Hours', 'Plant_Delivery_Hours',
                                         'Customer_Pickup_Hours', 'Small_Package_Hours', 'Next_Day_Orders'};
  

  string q = 'select id, name, time_zone__c ';
  for(string s:fields)
   q += ',' + s + '_M_F_Value1__c , ' + s + '_M_F_Value2__c, ' + s + '_Sat_Value1__c , ' + s + '_Sat_Value2__c ';
  q += ' from SAP_Plant__c where id = :id limit 1';
  SAP_Plant__c plant = database.query(q);
  plant.time_zone__c = tz;
  
  for(string s:fields){
    double open = 600;
    double close = 720;
    double satopen = 600;
    double satclose = 720;
    if(plant.get(s + '_M_F_Value1__c') != null)
      open = Double.valueof(plant.get(s + '_M_F_Value1__c'));
    if(plant.get(s + '_M_F_Value2__c') != null)
      close = Double.valueof(plant.get(s + '_M_F_Value2__c'));
    if(plant.get(s + '_Sat_Value1__c') != null)
      satopen = Double.valueof(plant.get(s + '_Sat_Value1__c'));
    if(plant.get(s + '_Sat_Value2__c') != null)
      satclose = Double.valueof(plant.get(s + '_Sat_Value2__c'));
    plant.put(s + '_M_F__c',  formatTime(tz, open, close));
    plant.put(s + '_M_F_EST__c',  formatTime('EST', open + offset.get(tz), close + offset.get(tz)));
    plant.put(s + '_Sat__c',  formatTime(tz, satopen, satclose));
    plant.put(s + '_Sat_EST__c',  formatTime('EST', satopen + offset.get(tz), satclose + offset.get(tz)));
  }
  update plant;
}
  
@RemoteAction
public static void updateTime(string id, string field, string tz, double open, double close){
  Map<string, double> offset = new Map<string, double>();
        Offset.put('EST',  0);
        Offset.put('CST',  -60);
        Offset.put('MST',  -120);
        Offset.put('PST',  -180);
        
  SAP_Plant__c plant = [select id, name, Time_Zone__c from SAP_Plant__c where id = :id limit 1];
  plant.time_zone__c = tz;
  if(field == 'Hours of Operation')
  {
      plant.Hours_Of_Operation_M_F_Value1__c = open;
      plant.Hours_Of_Operation_M_F_Value2__c = close;
      plant.Hours_of_Operation_M_F__c = formatTime(tz, open, close);
      plant.Hours_Of_Operation_M_F_EST__c = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
  else if(field == 'Hours of Operation Saturday')
  {
      plant.Hours_Of_Operation_Sat_Value1__c = open;
      plant.Hours_Of_Operation_Sat_Value2__c = close;
      plant.Hours_of_Operation_Sat__c = formatTime(tz, open, close);
      plant.Hours_Of_Operation_Sat_EST__c = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
  else if(field == 'Carrier Pickup Hours')
  {
      plant.Carrier_Pickup_Hours_M_F_Value1__c = open;
      plant.Carrier_Pickup_Hours_M_F_Value2__c = close;
      plant.Carrier_Pickup_Hours_M_F__c = formatTime(tz, open, close);
      plant.Carrier_Pickup_Hours_M_F_EST__c = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
  else if(field == 'Carrier Pickup Hours Saturday')
  {
      plant.Carrier_Pickup_Hours_Sat_Value1__c = open;
      plant.Carrier_Pickup_Hours_Sat_Value2__c = close;
      plant.Carrier_Pickup_Hours_Sat__c = formatTime(tz, open, close);
      plant.Carrier_Pickup_Hours_Sat_EST__c = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
  else if(field == 'Carrier Delivery Hours')
  {
      plant.Carrier_Delivery_Hours_M_F_Value1__c = open;
      plant.Carrier_Delivery_Hours_M_F_Value2__c = close;
      plant.Carrier_Delivery_Hours_M_F__c = formatTime(tz, open, close);
      plant.Carrier_Delivery_Hours_M_F_EST__c = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
    else if(field == 'Carrier Delivery Hours Saturday')
  {
      plant.Carrier_Delivery_Hours_Sat_Value1__c = open;
      plant.Carrier_Delivery_Hours_Sat_Value2__c = close;
      plant.Carrier_Delivery_Hours_Sat__c = formatTime(tz, open, close);
      plant.Carrier_Delivery_Hours_Sat_EST__c = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
  else if(field == 'Plant Delivery Hours')
  {
      plant.Plant_Delivery_Hours_M_F_Value1__c = open;
      plant.Plant_Delivery_Hours_M_F_Value2__c = close;
      plant.Plant_Delivery_Hours_M_F__c = formatTime(tz, open, close);
      plant.Plant_Delivery_Hours_M_F_EST__c = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
  else if(field == 'Plant Delivery Hours Saturday')
  {
      plant.Plant_Delivery_Hours_Sat_Value1__c = open;
      plant.Plant_Delivery_Hours_Sat_Value2__c = close;
      plant.Plant_Delivery_Hours_Sat__c = formatTime(tz, open, close);
      plant.Plant_Delivery_Hours_Sat_EST__c = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
  else if(field == 'Customer Pickup Hours')
  {
      plant.Customer_Pickup_Hours_M_F_Value1__c  = open;
      plant.Customer_Pickup_Hours_M_F_Value2__c = close;
      plant.Customer_Pickup_Hours_M_F__c = formatTime(tz, open, close);
      plant.Customer_Pickup_Hours_M_F_EST__c = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
  else if(field == 'Customer Pickup Hours Saturday')
  {
      plant.Customer_Pickup_Hours_Sat_Value1__c  = open;
      plant.Customer_Pickup_Hours_Sat_Value2__c = close;
      plant.Customer_Pickup_Hours_Sat__c = formatTime(tz, open, close);
      plant.Customer_Pickup_Hours_Sat_EST__c = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
  else if(field == 'Small Package Hours')
  {
      plant.Small_Package_Hours_M_F_Value1__c  = open;
      plant.Small_Package_Hours_M_F_Value2__c    = close;
      plant.Small_Package_Hours_M_F__c = formatTime(tz, open, close);
      plant.Small_Package_Hours_M_F_EST__c   = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
   else if(field == 'Small Package Hours Saturday')
  {
      plant.Small_Package_Hours_Sat_Value1__c  = open;
      plant.Small_Package_Hours_Sat_Value2__c    = close;
      plant.Small_Package_Hours_Sat__c = formatTime(tz, open, close);
      plant.Small_Package_Hours_Sat_EST__c   = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
  else if(field == 'Next Day Orders')
  {
      plant.Next_Day_Orders_M_F_Value1__c  = open;
      plant.Next_Day_Orders_M_F_Value2__c    = close;
      plant.Next_Day_Orders_M_F__c = formatTime(tz, open, close);
      plant.Next_Day_Orders_M_F_EST__c   = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
  else if(field == 'Next Day Orders Saturday')
  {
      plant.Next_Day_Orders_Sat_Value1__c  = open;
      plant.Next_Day_Orders_Sat_Value2__c    = close;
      plant.Next_Day_Orders_Sat__c = formatTime(tz, open, close);
      plant.Next_Day_Orders_Sat_EST__c   = formatTime('EST', (open + offset.get(tz)), (close + offset.get(tz)));
  }
  
  update plant;
}

private static string formatTime(string tz, double open, double close){
        
        if((close - open) == 1440)
        { open = 0; close = 1440; }
        if(open < 0)
        open = 0;
        if(close < 0)
        close = 0;
        if(open > 1440)
        open = 1440;
        if(close > 1440)
        close = 1440;
        
        string toreturn = '';
        integer hours1 = Integer.valueof(Math.floor(open / 60));
        integer minutes1 = Integer.valueof(open - (hours1 * 60));
        string shours1 = '';
        string smin1 = '';
 
        shours1 = string.valueof(hours1);
        smin1 = string.valueof(minutes1);
        
  
        if (shours1.length() == 1) 
           shours1 = '0' + shours1;
        if (smin1.length() == 1) 
           smin1 = '0' + smin1;
        if (minutes1 == 0) 
           smin1 = '00';
        if (hours1 >= 12) {
            if (hours1 == 12) {
                shours1 = string.valueof(hours1);
                smin1 += ' PM';
            } else {
                shours1 = string.valueof(hours1 - 12);
                if (shours1.length() == 1) 
                  shours1 = '0' + shours1;
                smin1 = smin1 + ' PM';
            }
        } else {
            smin1 = smin1 + ' AM';
        }
        if (hours1 == 0) {
            shours1 = '12';
        }

        toreturn = shours1 + ':' + smin1 + ' - ';
        
        integer hours2 = Integer.valueof(Math.floor(close / 60));
        integer minutes2 = integer.valueof(close - (hours2 * 60));
        string shours2 = '';
        string smin2 = '';
 
        shours2 = string.valueof(hours2);
        smin2 = string.valueof(minutes2);
        
        if (shours2.length() == 1) 
           shours2 = '0' + shours2;
        if (smin2.length() == 1) 
           smin2 = '0' + smin2;
        if (minutes2 == 0) 
           smin2 = '00';
        if (hours2 >= 12) {
            if (hours2 == 12) {
                shours2 = string.valueof(hours2);
                smin2 += ' PM';
            } else if (hours2 == 24) {
                shours2 = '12';
                smin2 = '00 AM';

            } else {
                shours2 = string.valueof(hours2 - 12);
                if (shours2.length() == 1) 
                  shours2 = '0' + shours2;
                smin2 += ' PM';
            }
        } else {
            smin2 = smin2 + ' AM';
        }

        toreturn += shours2 + ':' + smin2 + ' ' + tz;
        return toreturn;
}


}