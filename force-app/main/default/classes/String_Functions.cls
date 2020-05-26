public class String_Functions {

  public static String convertCRtoBR(String StringIn) {
    String result = '';

    if ((StringIn != null) && (StringIn != ''))
      {    
      List<String> StringLines = StringIn.split('\n',0);
  
      for (String StringLine : StringLines) 
        {
        if ((result != '') && (StringLine != null)) {result += '<BR>';}
        if (StringLine != null) {result += StringLine;}
        }
      }  
    return result;
  }

  public static String convertBRtoCR(String StringIn) {
    String result = '';
    
    if ((StringIn != null) && (StringIn != ''))
      {    
      List<String> StringLines = StringIn.split('<BR>',0);
  
      for (String StringLine : StringLines) 
        {
        if ((result != '') && (StringLine != null)) {result += '\n';}
        if (StringLine != null) {result += StringLine;}
        }
      }  
    return result;
  }

  public static String removeLeadingZeros(String str) {
      String result = null;
      String newStr = '';
      Boolean stopProcessing = false;

      if (str != null)
        {
          newStr = str.trim();
          while ((stopProcessing == false) && (newStr.length() > 1))
            {
            if (newStr.startsWith('0') == true)
              {
              newStr = newStr.subString(1);                
              }
            else
              {stopProcessing = true;}
            }
          result = newStr;  
        }
        
        
    return result;
    }


  public static List<String> trimAllStringsinListString(List<String> lines) {
    List<String> newList = new List<String>();
    String trimmedString = '';
    for (String line:lines)
      {
        trimmedString = line.trim();
        newList.add(trimmedString);
      }
    return newList;  
  }


  public static String Format_ListString_into_HTML_List(String dataIn, String prefix, String suffix) {
    String result = '';
    if ((dataIn != null) && (dataIn != ''))
      {
      List<String> Strings = new List<String>();
      Strings.Add(dataIn);
      result = Format_ListString_into_HTML_List(Strings,prefix,suffix);
      }
    return result;    
  } 

  public static String Format_ListString_into_HTML_List(List<String> dataIn, String prefix, String suffix) {
    String result = '';
    
    if (dataIn.size() > 0)
      {
        result = '<ul type=circle>';
        for(String data:dataIn)
          {
            result += '<li>' + prefix + data + suffix;
          }
        result += '</ul>';
      }
    
    return result;
  }

public static String Right(String str, Integer n)
{
      if (n <= 0)
          return '';
      else if (n > str.length())
          return str;
      else
   {
          Integer iLen = str.length();
          System.debug('iLen = ' + iLen);
          System.debug('n = ' + n);
          System.debug('iLen - n = ' + (iLen - n));
          
          return str.substring(iLen - n,iLen );
      }
}

public static string BeforeParenthesis(String instring){

if(instring.contains('(') & instring.contains(')')){
   return instring.substring(0,instring.lastindexof('(')).trim();}
else{return instring;}
}

public static string inParenthesis(String instring){
if(instring.contains('(') & instring.contains(')')){
  
   return instring.substring(instring.lastindexof('(')+1, instring.length()-1).trim();
}else{return instring;}

}

//******************
//Test Method 
//******************
  static testMethod void TestMe() {

    String result = '';
    
    result = convertCRtoBR('Test1\nTest2\nTest3');
    System.assertEquals('Test1<BR>Test2<BR>Test3',result);


    result = convertBRtoCR('Test1<BR>Test2<BR>Test3');
    System.assertEquals('Test1\nTest2\nTest3',result);

    List<String> test = new List<String>();
    test.add('Line 1 ');
    test.add('Line 2 ');
    
    System.debug(Format_ListString_into_HTML_List(test, 'prefix:', ':suffix'));

    System.debug(Format_ListString_into_HTML_List('test', 'prefix:', ':suffix'));

    test = trimAllStringsinListString(test);

    System.debug(Format_ListString_into_HTML_List(test, 'prefix:', ':suffix'));

    System.assertEquals('12345',removeLeadingZeros('0000000000000000012345'));
    System.assertEquals('0',removeLeadingZeros('000000000000000000'));
    System.assertEquals('0',removeLeadingZeros('0'));
    System.assertEquals(null,removeLeadingZeros(null));

    System.assertEquals('',Right('',10));
    System.assertEquals('0000012345',Right('000000000012345',10));
    System.assertEquals('12345',Right('9999912345',5));


  }

//The End
}