public class Nested_Dependancy{

public list<selectoption> Level1{get; set;}
public list<selectoption> Level2{get; set;}
public list<selectoption> Level3{get; set;}
public list<selectoption> level4{get; set;}
public list<selectoption> level5{get; set;}
private string deprectypename{get; set;}
private string field1{get; set;}
private string field2{get; set;}
private string field3{get; set;}
private string field4{get; set;}
private string field5{get; set;}
public boolean field2active{get; set;}
public boolean field3active{get; set;}
public boolean field4active{get; set;}
public boolean field5active{Get; set;}
public boolean rendererror1{Get; set;}
public boolean rendererror2{get; set;}
public boolean rendererror3{get; set;}
public boolean rendererror4{get; set;}
public boolean rendererror5{get; set;}
private string obj{get; set;}
private string rectypename{get; set;}

private Map<String, ID> RTMap{get; set;}

public Nested_Dependancy(string field1, string field2, string field3, string rectype, string objt){
this.field1 = field1;
this.field2 = field2;
this.field3 = field3;
field4 = '';
field5 = '';
init('3', this.field1, rectype, objt);
}

public Nested_Dependancy(string field1, string field2, string field3, string field4, string rectype, string objt){
this.field1 = field1;
this.field2 = field2;
this.field3 = field3;
this.field4 = field4;
field5 = '';
init('4', this.field1, rectype, objt);
}

public Nested_Dependancy(string field1, string field2, string field3, string field4, string field5, string rectype, string objt){
this.field1 = field1;
this.field2 = field2;
this.field3 = field3;
this.field4 = field4;
this.field5 = field5;
init('5', this.field1, rectype, objt);
}

private void init(String numfields, string field1, string rectype, string objt){
   RTMap = RecordType_Functions.RetrieveRecordTypeNameMap('Nested_Dependancy__c');
   Level1 = new list<selectoption>();
   Level2 = new list<selectoption>();
   Level3 = new list<selectoption>();
   Level4 = new list<selectoption>();
   Level5 = new list<selectoption>();
   Level2.add(new selectoption('', '--None--')); 
   Level3.add(new selectoption('', '--None--')); 
   Level4.add(new selectoption('', '--None--')); 
   Level5.add(new selectoption('', '--None--')); 
   field2active = false;
   field3active = false;
   field4active = false;
   field5active = false;
   rendererror1 = false;
   rendererror2 = false;
   rendererror3 = false;
   rendererror4 = false;
   rendererror5 = false;
   obj = objt;
   rectypename = rectype;
   
if(numfields == '3'){
deprectypename = '3 Level';
}
else if (numfields == '4'){
deprectypename = '4 Level';
}
else if (numfields == '5'){
deprectypename = '5 Level';
}
else {deprectypename = '3 Level';}

Level1 = getoptions(field1);
}

public void field1changed(String value1){
  if(value1 != '' && value1 != null){
  level2 = getoptions(field1, value1, field2);
  field2active = true;
  rendererror1 = false;
  }
  else{
  field2active = false;
  field3active = false;
  field4active = false;
  field5active = false;
  rendererror1 = true;
  }
}

public void field2changed(String value1, String value2){
  if(value2 != '' && value2 != null){
  level3 = getoptions(field1, value1, field2, value2, field3);
  field3active = true;
  rendererror2 = false;
  }
  else{
  field3active = false;
  field4active = false;
  field5active = false;
  rendererror2 = true;
  }
}


public void field3changed(String value1, String value2, String value3){
  if(value3 != '' && value3 != null){
    if(deprectypename != '3 Level'){
     level4 = getoptions(field1, value1, field2, value2, field3, value3, field4);
    }
  field4active = true;
  rendererror3 = false;
  }
  else{
  field4active = false;
  field5active = false;
  rendererror3 = true;
  }
}


public void field4changed(String value1,String value2, String value3, String value4){
  if(value4 != '' && value4 != null){
    if(deprectypename == '5 Level'){
     level5 = getoptions(field1, value1, field2, value2, field3, value3, field4, value4, field5);
    }
  field5active = true;
  rendererror4 = false;
  }
  else{
  field5active = false;
  rendererror4 = true;
  }
}

public void field5changed(String value4){
   if(value4 != '' && value4 != null){
   rendererror5 = false;
   } else{
   rendererror5 = true;
   }
}
   
private list<selectoption> getoptions(String f1){
  List<selectoption> returnoptions = new list<selectoption>();
  system.debug('Obj: ' + obj);
  system.debug('f1: ' + f1);
  system.debug('rectypename: ' + rectypename );
  system.debug('RTMap.get(deprectypename): ' + RTMap.get(deprectypename));
  List<Nested_Dependancy__c> options = [select id, field_1_Value__c from Nested_Dependancy__c where object__c = :obj and field_1__c = :f1 and record_type_name__c = :rectypename ORDER BY field_1_Value__c Asc];
   Set<string> tempset = new set<string>();
   returnoptions.add(new selectoption('', '--None--'));
   for(Nested_Dependancy__c nd:options){
     if(!tempset.contains(nd.field_1_Value__c)){
     returnoptions.add(new selectoption(nd.field_1_Value__c, nd.field_1_Value__c));
     tempset.add(nd.field_1_value__c);
     }
   }
  return returnoptions;
}
private list<selectoption> getoptions(String f1, String v1, String f2){
   List<selectoption> returnoptions = new list<selectoption>();
   List<Nested_Dependancy__c> options = [select id, field_2_value__c from Nested_Dependancy__c where object__c = :obj and Field_1__c = :f1 and Field_1_Value__c = :v1 and Field_2__c = :f2
                                         ORDER BY field_2_value__c Asc];
   Set<string> tempset = new set<string>();
   returnoptions.add(new selectoption('', '--None--')); 
   for(Nested_Dependancy__c nd:options){
     if(!tempset.contains(nd.field_2_Value__c)){
     returnoptions.add(new selectoption(nd.field_2_Value__c, nd.field_2_Value__c));
     tempset.add(nd.field_2_value__c);
     }
   }
   return returnoptions;
}

private list<selectoption> getoptions(String f1, String v1, String f2, String v2, String f3){
   List<selectoption> returnoptions = new list<selectoption>();
   List<Nested_Dependancy__c> options = [select id, field_3_value__c from Nested_Dependancy__c where object__c = :obj and Field_1__c = :f1 and Field_1_Value__c = :v1 and 
                                         Field_2__c = :f2 and Field_2_Value__c = :v2 and Field_3__c = :f3
                                         ORDER BY field_3_value__c Asc];
   Set<string> tempset = new set<string>();
    returnoptions.add(new selectoption('', '--None--'));
   for(Nested_Dependancy__c nd:options){
     if(!tempset.contains(nd.field_3_Value__c)){
     returnoptions.add(new selectoption(nd.field_3_Value__c, nd.field_3_Value__c));
     tempset.add(nd.field_3_value__c);
     }
   }
   return returnoptions;
}

private list<selectoption> getoptions(String f1, String v1, String f2, String v2, String f3, String v3, string f4){
   List<selectoption> returnoptions = new list<selectoption>();
   List<Nested_Dependancy__c> options = [select id, field_4_value__c from Nested_Dependancy__c where object__c = :obj and Field_1__c = :f1 and Field_1_Value__c = :v1 and 
                                         Field_2__c = :f2 and Field_2_Value__c = :v2 and Field_3__c = :f3 and Field_3_Value__c = :v3 and Field_4__c = :f4 ORDER BY field_4_value__c Asc
                                         ];
   Set<string> tempset = new set<string>();
    returnoptions.add(new selectoption('', '--None--'));
   for(Nested_Dependancy__c nd:options){
     if(!tempset.contains(nd.field_4_Value__c)&& nd.field_4_Value__c!= null){
     returnoptions.add(new selectoption(nd.field_4_Value__c, nd.field_4_Value__c));
     tempset.add(nd.field_4_value__c);
     }
   }
   return returnoptions;
}

private list<selectoption> getoptions(String f1, String v1, String f2, String v2, String f3, String v3, string f4, string v4, string f5){
   List<selectoption> returnoptions = new list<selectoption>();
   List<Nested_Dependancy__c> options = [select id, field_5_value__c from Nested_Dependancy__c where object__c = :obj and Field_1__c = :f1 and Field_1_Value__c = :v1 and 
                                         Field_2__c = :f2 and Field_2_Value__c = :v2 and Field_3__c = :f3 and Field_3_Value__c = :v3 and 
                                         Field_4__c = :f4 and field_4_Value__c = :v4 and field_5__c = :f5
                                         ];
   Set<string> tempset = new set<string>();
    returnoptions.add(new selectoption('', '--None--'));
   for(Nested_Dependancy__c nd:options){
     if(!tempset.contains(nd.field_5_Value__c)){
     returnoptions.add(new selectoption(nd.field_5_Value__c, nd.field_5_Value__c));
     tempset.add(nd.field_5_value__c);
     }
   }
   return returnoptions;
}

}