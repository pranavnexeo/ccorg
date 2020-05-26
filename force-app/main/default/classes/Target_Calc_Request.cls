global Class Target_Calc_Request{
  public string SALES_ORG{Get; set;}
  public string DIVISION{get; set;}
  public string CUSTOMER_SIZE{get; set;}
  public String PRICING_ENDMKT{get; set;}
  public String SUB_REGION{Get; set;}
  public String MATERIAL{get; set;}
  
  public Target_Calc_Request(String org, string div, string size, string mkt, string reg, string mat){
    this.SALES_ORG = org;
    this.DIVISION = div;
    this.CUSTOMER_SIZE = size;
    this.PRICING_ENDMKT = mkt;
    this.SUB_REGION = reg;
    this.MATERIAL = mat;
  }  
}