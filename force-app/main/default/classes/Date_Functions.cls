public class Date_Functions {

  public static Date convertDateTimetoDate(DateTime dateTimeIn) {
  
    Date result;
    
    result = Date.newInstance(dateTimeIn.year(),dateTimeIn.month(),dateTimeIn.day());
    
    return result;
  }

  public static Date returnLargestDate(List<Date> DatesIn) {
   
    Date result;
   
    for (Date DateIn:DatesIn)
      {
      if (result != null)
        {
          if (DateIn > result) {result = DateIn;}
        }
      else {result = DateIn;}
      }  
    
    return result;
  }

    public static String getFormattedDate(Date DateIn, Integer formatType) {
    String formattedDate = '';
    if(DateIn!=null)
    {
        if(formatType == 1)
            {
            formattedDate = String.valueOf(DateIn.month()) + '/' + String.valueOf(DateIn.day()) + '/' + String.valueOf(DateIn.year());
            }
    }    
    return formattedDate;
} 

  public static String getYearMonth(DateTime dateTimeIn) {
    Date dateIn = convertDateTimetoDate(dateTimeIn);
    return getYearMonth(dateIn);
  }


    public static String getYearMonth(Date dateIn) {
        String result = '';
        String month = String.valueOf(DateIn.month());
        if (month.length() == 1) {month = '0' + month;}
        result = String.valueOf(DateIn.year()) + month;
        return result;
        }


    public static String getFormattedDateTime(Datetime value, Integer formatType)
    {
        String formattedDate = '';
        if(value!=null)
        {
            if(formatType == 1)        
                formattedDate = value.format('MMM dd, yyyy','GMT - 8:00');
            else if (formatType == 2)        
                formattedDate = value.format('yyyy-MM-dd','GMT - 8:00');
            else if(formatType == 3)
                formattedDate = value.format('MMM dd, yyyy h:mm:ss a (z)','GMT - 8:00');
        }    
        return formattedDate;
    } 


public static Date stringToDate(String s){
      //Date String is in the format mm/dd/yyyy
      Date result;
      
      try {
          String[] stringDate = s.split('/');
          Integer m =  Integer.valueOf(stringDate[0]);
          Integer d = Integer.valueOf(stringDate[1]);
          Integer y = Integer.valueOf(stringDate[2]);
          result = date.newInstance(y,m,d);
          } catch (Exception e) {}
      
      
      return result;
}
//The End
}