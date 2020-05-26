public class Rolling_Product_Sales_Info_Line {

    public Rolling_Product_Sales_Info_Line(Id LineItemId,
                                           Rolling_Product_Sales_Info__c LineItemRec,
                                           String MaterialName) {
        this.LineItemId = LineItemId;
        this.LineItemRec = LineItemRec;          
        this.MaterialName = MaterialName;
        this.ValueType = 'VolumeinLB';      
    }

    public Id     LineItemId { get; set; }     
    public Rolling_Product_Sales_Info__c LineItemRec { get; set; }
    public String MaterialName { get; set; }

    public String ValueType { get; set; }     
    
    private Boolean Month_01_Populated() {
    	if ((LineItemRec.Amount_Month_01__c       != 0.0) || 
    	    (LineItemRec.GM_Month_01__c           != 0.0) || 
    	    (LineItemRec.GMpct_Month_01__c        != 0.0) || 
    	    (LineItemRec.Volume_in_KG_Month_01__c != 0.0) || 
            (LineItemRec.Volume_in_LB_Month_01__c != 0.0) || 
            (LineItemRec.Volume_in_GL_Month_01__c != 0.0) || 
            (LineItemRec.Volume_in_PT_Month_01__c != 0.0) || 
    	    (LineItemRec.Volume_in_UN_Month_01__c != 0.0)
    	   ) {return true;} 
    	else {return false;}
    }

    private Boolean Month_02_Populated() {
        if ((LineItemRec.Amount_Month_02__c       != 0.0) || 
            (LineItemRec.GM_Month_02__c           != 0.0) || 
            (LineItemRec.GMpct_Month_02__c        != 0.0) || 
            (LineItemRec.Volume_in_KG_Month_02__c != 0.0) || 
            (LineItemRec.Volume_in_LB_Month_02__c != 0.0) || 
            (LineItemRec.Volume_in_GL_Month_02__c != 0.0) || 
            (LineItemRec.Volume_in_PT_Month_02__c != 0.0) || 
            (LineItemRec.Volume_in_UN_Month_02__c != 0.0)
           ) {return true;} 
        else {return false;}
    }

    private Boolean Month_03_Populated() {
        if ((LineItemRec.Amount_Month_03__c       != 0.0) || 
            (LineItemRec.GM_Month_03__c           != 0.0) || 
            (LineItemRec.GMpct_Month_03__c        != 0.0) || 
            (LineItemRec.Volume_in_KG_Month_03__c != 0.0) || 
            (LineItemRec.Volume_in_LB_Month_03__c != 0.0) || 
            (LineItemRec.Volume_in_GL_Month_03__c != 0.0) || 
            (LineItemRec.Volume_in_PT_Month_03__c != 0.0) || 
            (LineItemRec.Volume_in_UN_Month_03__c != 0.0)
           ) {return true;} 
        else {return false;}
    }

    private Boolean Month_04_Populated() {
        if ((LineItemRec.Amount_Month_04__c       != 0.0) || 
            (LineItemRec.GM_Month_04__c           != 0.0) || 
            (LineItemRec.GMpct_Month_04__c        != 0.0) || 
            (LineItemRec.Volume_in_KG_Month_04__c != 0.0) || 
            (LineItemRec.Volume_in_LB_Month_04__c != 0.0) || 
            (LineItemRec.Volume_in_GL_Month_04__c != 0.0) || 
            (LineItemRec.Volume_in_PT_Month_04__c != 0.0) || 
            (LineItemRec.Volume_in_UN_Month_04__c != 0.0)
           ) {return true;} 
        else {return false;}
    }

    private Boolean Month_05_Populated() {
        if ((LineItemRec.Amount_Month_05__c       != 0.0) || 
            (LineItemRec.GM_Month_05__c           != 0.0) || 
            (LineItemRec.GMpct_Month_05__c        != 0.0) || 
            (LineItemRec.Volume_in_KG_Month_05__c != 0.0) || 
            (LineItemRec.Volume_in_LB_Month_05__c != 0.0) || 
            (LineItemRec.Volume_in_GL_Month_05__c != 0.0) || 
            (LineItemRec.Volume_in_PT_Month_05__c != 0.0) || 
            (LineItemRec.Volume_in_UN_Month_05__c != 0.0)
           ) {return true;} 
        else {return false;}
    }

    private Boolean Month_06_Populated() {
        if ((LineItemRec.Amount_Month_06__c       != 0.0) || 
            (LineItemRec.GM_Month_06__c           != 0.0) || 
            (LineItemRec.GMpct_Month_06__c        != 0.0) || 
            (LineItemRec.Volume_in_KG_Month_06__c != 0.0) || 
            (LineItemRec.Volume_in_LB_Month_06__c != 0.0) || 
            (LineItemRec.Volume_in_GL_Month_06__c != 0.0) || 
            (LineItemRec.Volume_in_PT_Month_06__c != 0.0) || 
            (LineItemRec.Volume_in_UN_Month_06__c != 0.0)
           ) {return true;} 
        else {return false;}
    }

    private Boolean Month_07_Populated() {
        if ((LineItemRec.Amount_Month_07__c       != 0.0) || 
            (LineItemRec.GM_Month_07__c           != 0.0) || 
            (LineItemRec.GMpct_Month_07__c        != 0.0) || 
            (LineItemRec.Volume_in_KG_Month_07__c != 0.0) || 
            (LineItemRec.Volume_in_LB_Month_07__c != 0.0) || 
            (LineItemRec.Volume_in_GL_Month_07__c != 0.0) || 
            (LineItemRec.Volume_in_PT_Month_07__c != 0.0) || 
            (LineItemRec.Volume_in_UN_Month_07__c != 0.0)
           ) {return true;} 
        else {return false;}
    }

    private Boolean Month_08_Populated() {
        if ((LineItemRec.Amount_Month_08__c       != 0.0) || 
            (LineItemRec.GM_Month_08__c           != 0.0) || 
            (LineItemRec.GMpct_Month_08__c        != 0.0) || 
            (LineItemRec.Volume_in_KG_Month_08__c != 0.0) || 
            (LineItemRec.Volume_in_LB_Month_08__c != 0.0) || 
            (LineItemRec.Volume_in_GL_Month_08__c != 0.0) || 
            (LineItemRec.Volume_in_PT_Month_08__c != 0.0) || 
            (LineItemRec.Volume_in_UN_Month_08__c != 0.0)
           ) {return true;} 
        else {return false;}
    }

    private Boolean Month_09_Populated() {
        if ((LineItemRec.Amount_Month_09__c       != 0.0) || 
            (LineItemRec.GM_Month_09__c           != 0.0) || 
            (LineItemRec.GMpct_Month_09__c        != 0.0) || 
            (LineItemRec.Volume_in_KG_Month_09__c != 0.0) || 
            (LineItemRec.Volume_in_LB_Month_09__c != 0.0) || 
            (LineItemRec.Volume_in_GL_Month_09__c != 0.0) || 
            (LineItemRec.Volume_in_PT_Month_09__c != 0.0) || 
            (LineItemRec.Volume_in_UN_Month_09__c != 0.0)
           ) {return true;} 
        else {return false;}
    }

    private Boolean Month_10_Populated() {
        if ((LineItemRec.Amount_Month_10__c       != 0.0) || 
            (LineItemRec.GM_Month_10__c           != 0.0) || 
            (LineItemRec.GMpct_Month_10__c        != 0.0) || 
            (LineItemRec.Volume_in_KG_Month_10__c != 0.0) || 
            (LineItemRec.Volume_in_LB_Month_10__c != 0.0) || 
            (LineItemRec.Volume_in_GL_Month_10__c != 0.0) || 
            (LineItemRec.Volume_in_PT_Month_10__c != 0.0) || 
            (LineItemRec.Volume_in_UN_Month_10__c != 0.0)
           ) {return true;} 
        else {return false;}
    }

    private Boolean Month_11_Populated() {
        if ((LineItemRec.Amount_Month_11__c       != 0.0) || 
            (LineItemRec.GM_Month_11__c           != 0.0) || 
            (LineItemRec.GMpct_Month_11__c        != 0.0) || 
            (LineItemRec.Volume_in_KG_Month_11__c != 0.0) || 
            (LineItemRec.Volume_in_LB_Month_11__c != 0.0) || 
            (LineItemRec.Volume_in_GL_Month_11__c != 0.0) || 
            (LineItemRec.Volume_in_PT_Month_11__c != 0.0) || 
            (LineItemRec.Volume_in_UN_Month_11__c != 0.0)
           ) {return true;} 
        else {return false;}
    }

    private Boolean Month_12_Populated() {
        if ((LineItemRec.Amount_Month_12__c       != 0.0) || 
            (LineItemRec.GM_Month_12__c           != 0.0) || 
            (LineItemRec.GMpct_Month_12__c        != 0.0) || 
            (LineItemRec.Volume_in_KG_Month_12__c != 0.0) || 
            (LineItemRec.Volume_in_LB_Month_12__c != 0.0) || 
            (LineItemRec.Volume_in_GL_Month_12__c != 0.0) || 
            (LineItemRec.Volume_in_PT_Month_12__c != 0.0) || 
            (LineItemRec.Volume_in_UN_Month_12__c != 0.0)
           ) {return true;} 
        else {return false;}
    }

    private Boolean Month_13_Populated() {
        if ((LineItemRec.Amount_Month_13__c       != 0.0) || 
            (LineItemRec.GM_Month_13__c           != 0.0) || 
            (LineItemRec.GMpct_Month_13__c        != 0.0) || 
            (LineItemRec.Volume_in_KG_Month_13__c != 0.0) || 
            (LineItemRec.Volume_in_LB_Month_13__c != 0.0) || 
            (LineItemRec.Volume_in_GL_Month_13__c != 0.0) || 
            (LineItemRec.Volume_in_PT_Month_13__c != 0.0) || 
            (LineItemRec.Volume_in_UN_Month_13__c != 0.0)
           ) {return true;} 
        else {return false;}
    }

    private String getCellStyle1(Double valueIn) {
        String result = 'text-align:right;';
        if (valueIn == 0.0) {result='text-align:center;';}
        else if (valueIn < 0.0) {result +='color:red;';} 
        return result;
    }

    private String getCellStyle1(Decimal valueIn) {
    	if (valueIn == null) {return '';}
        return getCellStyle1(valueIn.doubleValue());
    }

    private String styleAmount(Decimal valueIn,Boolean recPopulated) {return getCellStyle1(valueIn);}

    private String styleGM(Decimal valueIn,Boolean recPopulated) {return getCellStyle1(valueIn);}

    private String styleGMpct(Decimal valueIn,Boolean recPopulated) {return getCellStyle1(valueIn);}

    private String styleVolumeinKG(Double valueIn,Boolean recPopulated) {return getCellStyle1(valueIn);}

    private String styleVolumeinLB(Double valueIn,Boolean recPopulated) {return getCellStyle1(valueIn);}

    private String styleVolumeinUN(Double valueIn,Boolean recPopulated) {return getCellStyle1(valueIn);}

    private String styleVolumeinGL(Double valueIn,Boolean recPopulated) {return getCellStyle1(valueIn);}

    private String styleVolumeinPT(Double valueIn,Boolean recPopulated) {return getCellStyle1(valueIn);}

    public String getValue_Month_01() {
        String result = '';
        if (ValueType=='Amount') {result = getAmount_Month_01_formatted();}
        else if (ValueType=='GM') {result = getGM_Month_01_formatted();}        
        else if (ValueType=='GMpct') {result = getGMpct_Month_01_formatted();}      
        else if (ValueType=='VolumeinKG') {result = getVolume_in_KG_Month_01_formatted();}      
        else if (ValueType=='VolumeinLB') {result = getVolume_in_LB_Month_01_formatted();}      
        else if (ValueType=='VolumeinUN') {result = getVolume_in_UN_Month_01_formatted();}      
        else if (ValueType=='VolumeinGL') {result = getVolume_in_GL_Month_01_formatted();}      
        else if (ValueType=='VolumeinPT') {result = getVolume_in_PT_Month_01_formatted();}      
        return result;
    }

    public String getStyle_Month_01() {
        String result = '';
        if      (ValueType=='Amount')     {result=styleAmount(LineItemRec.Amount_Month_01__c,Month_01_Populated());}
        else if (ValueType=='GM')         {result=styleGM(LineItemRec.GM_Month_01__c,Month_01_Populated());}
        else if (ValueType=='GMpct')      {result=styleGMpct(LineItemRec.GMpct_Month_01__c,Month_01_Populated());}
        else if (ValueType=='VolumeinKG') {result=styleVolumeinKG(LineItemRec.Volume_in_KG_Month_01__c,Month_01_Populated());}
        else if (ValueType=='VolumeinLB') {result=styleVolumeinLB(LineItemRec.Volume_in_LB_MOnth_01__c,Month_01_Populated());} 
        else if (ValueType=='VolumeinUN') {result=styleVolumeinUN(LineItemRec.Volume_in_UN_MOnth_01__c,Month_01_Populated());} 
        else if (ValueType=='VolumeinGL') {result=styleVolumeinGL(LineItemRec.Volume_in_GL_MOnth_01__c,Month_01_Populated());} 
        else if (ValueType=='VolumeinPT') {result=styleVolumeinPT(LineItemRec.Volume_in_PT_MOnth_01__c,Month_01_Populated());} 
        else {result='';}
        return result;
    }

    public String getValue_Month_02() {
        String result = '';
        if (ValueType=='Amount') {result = getAmount_Month_02_formatted();}
        else if (ValueType=='GM') {result = getGM_Month_02_formatted();}        
        else if (ValueType=='GMpct') {result = getGMpct_Month_02_formatted();}      
        else if (ValueType=='VolumeinKG') {result = getVolume_in_KG_Month_02_formatted();}      
        else if (ValueType=='VolumeinLB') {result = getVolume_in_LB_Month_02_formatted();}      
        else if (ValueType=='VolumeinUN') {result = getVolume_in_UN_Month_02_formatted();}      
        else if (ValueType=='VolumeinGL') {result = getVolume_in_GL_Month_02_formatted();}      
        else if (ValueType=='VolumeinPT') {result = getVolume_in_PT_Month_02_formatted();}      
        return result;
    }

    public String getStyle_Month_02() {
        String result = '';
        if      (ValueType=='Amount')     {result=styleAmount(LineItemRec.Amount_Month_02__c,Month_02_Populated());}
        else if (ValueType=='GM')         {result=styleGM(LineItemRec.GM_Month_02__c,Month_02_Populated());}
        else if (ValueType=='GMpct')      {result=styleGMpct(LineItemRec.GMpct_Month_02__c,Month_02_Populated());}
        else if (ValueType=='VolumeinKG') {result=styleVolumeinKG(LineItemRec.Volume_in_KG_Month_02__c,Month_02_Populated());}
        else if (ValueType=='VolumeinLB') {result=styleVolumeinLB(LineItemRec.Volume_in_LB_MOnth_02__c,Month_02_Populated());} 
        else if (ValueType=='VolumeinUN') {result=styleVolumeinUN(LineItemRec.Volume_in_UN_MOnth_02__c,Month_02_Populated());} 
        else if (ValueType=='VolumeinGL') {result=styleVolumeinGL(LineItemRec.Volume_in_GL_MOnth_02__c,Month_02_Populated());} 
        else if (ValueType=='VolumeinPT') {result=styleVolumeinPT(LineItemRec.Volume_in_PT_MOnth_02__c,Month_02_Populated());} 
        else {result='';}
        return result;
    }

    public String getValue_Month_03() {
        String result = '';
        if (ValueType=='Amount') {result = getAmount_Month_03_formatted();}
        else if (ValueType=='GM') {result = getGM_Month_03_formatted();}        
        else if (ValueType=='GMpct') {result = getGMpct_Month_03_formatted();}      
        else if (ValueType=='VolumeinKG') {result = getVolume_in_KG_Month_03_formatted();}      
        else if (ValueType=='VolumeinLB') {result = getVolume_in_LB_Month_03_formatted();}      
        else if (ValueType=='VolumeinUN') {result = getVolume_in_UN_Month_03_formatted();}      
        else if (ValueType=='VolumeinGL') {result = getVolume_in_GL_Month_03_formatted();}      
        else if (ValueType=='VolumeinPT') {result = getVolume_in_PT_Month_03_formatted();}      
        return result;
    }

    public String getStyle_Month_03() {
        String result = '';
        if      (ValueType=='Amount')     {result=styleAmount(LineItemRec.Amount_Month_03__c,Month_03_Populated());}
        else if (ValueType=='GM')         {result=styleGM(LineItemRec.GM_Month_03__c,Month_03_Populated());}
        else if (ValueType=='GMpct')      {result=styleGMpct(LineItemRec.GMpct_Month_03__c,Month_03_Populated());}
        else if (ValueType=='VolumeinKG') {result=styleVolumeinKG(LineItemRec.Volume_in_KG_Month_03__c,Month_03_Populated());}
        else if (ValueType=='VolumeinLB') {result=styleVolumeinLB(LineItemRec.Volume_in_LB_MOnth_03__c,Month_03_Populated());} 
        else if (ValueType=='VolumeinUN') {result=styleVolumeinUN(LineItemRec.Volume_in_UN_MOnth_03__c,Month_03_Populated());} 
        else if (ValueType=='VolumeinGL') {result=styleVolumeinGL(LineItemRec.Volume_in_GL_MOnth_03__c,Month_03_Populated());} 
        else if (ValueType=='VolumeinPT') {result=styleVolumeinPT(LineItemRec.Volume_in_PT_MOnth_03__c,Month_03_Populated());} 
        else {result='';}
        return result;
    }

    public String getValue_Month_04() {
        String result = '';
        if (ValueType=='Amount') {result = getAmount_Month_04_formatted();}
        else if (ValueType=='GM') {result = getGM_Month_04_formatted();}        
        else if (ValueType=='GMpct') {result = getGMpct_Month_04_formatted();}      
        else if (ValueType=='VolumeinKG') {result = getVolume_in_KG_Month_04_formatted();}      
        else if (ValueType=='VolumeinLB') {result = getVolume_in_LB_Month_04_formatted();}      
        else if (ValueType=='VolumeinUN') {result = getVolume_in_UN_Month_04_formatted();}      
        else if (ValueType=='VolumeinGL') {result = getVolume_in_GL_Month_04_formatted();}      
        else if (ValueType=='VolumeinPT') {result = getVolume_in_PT_Month_04_formatted();}      
        return result;
    }

    public String getStyle_Month_04() {
        String result = '';
        if      (ValueType=='Amount')     {result=styleAmount(LineItemRec.Amount_Month_04__c,Month_04_Populated());}
        else if (ValueType=='GM')         {result=styleGM(LineItemRec.GM_Month_04__c,Month_04_Populated());}
        else if (ValueType=='GMpct')      {result=styleGMpct(LineItemRec.GMpct_Month_04__c,Month_04_Populated());}
        else if (ValueType=='VolumeinKG') {result=styleVolumeinKG(LineItemRec.Volume_in_KG_Month_04__c,Month_04_Populated());}
        else if (ValueType=='VolumeinLB') {result=styleVolumeinLB(LineItemRec.Volume_in_LB_MOnth_04__c,Month_04_Populated());} 
        else if (ValueType=='VolumeinUN') {result=styleVolumeinUN(LineItemRec.Volume_in_UN_MOnth_04__c,Month_04_Populated());} 
        else if (ValueType=='VolumeinGL') {result=styleVolumeinGL(LineItemRec.Volume_in_GL_MOnth_04__c,Month_04_Populated());} 
        else if (ValueType=='VolumeinPT') {result=styleVolumeinPT(LineItemRec.Volume_in_PT_MOnth_04__c,Month_04_Populated());} 
        else {result='';}
        return result;
    }

    public String getValue_Month_05() {
        String result = '';
        if (ValueType=='Amount') {result = getAmount_Month_05_formatted();}
        else if (ValueType=='GM') {result = getGM_Month_05_formatted();}        
        else if (ValueType=='GMpct') {result = getGMpct_Month_05_formatted();}      
        else if (ValueType=='VolumeinKG') {result = getVolume_in_KG_Month_05_formatted();}      
        else if (ValueType=='VolumeinLB') {result = getVolume_in_LB_Month_05_formatted();}      
        else if (ValueType=='VolumeinUN') {result = getVolume_in_UN_Month_05_formatted();}      
        else if (ValueType=='VolumeinGL') {result = getVolume_in_GL_Month_05_formatted();}      
        else if (ValueType=='VolumeinPT') {result = getVolume_in_PT_Month_05_formatted();}      
        return result;
    }

    public String getStyle_Month_05() {
        String result = '';
        if      (ValueType=='Amount')     {result=styleAmount(LineItemRec.Amount_Month_05__c,Month_05_Populated());}
        else if (ValueType=='GM')         {result=styleGM(LineItemRec.GM_Month_05__c,Month_05_Populated());}
        else if (ValueType=='GMpct')      {result=styleGMpct(LineItemRec.GMpct_Month_05__c,Month_05_Populated());}
        else if (ValueType=='VolumeinKG') {result=styleVolumeinKG(LineItemRec.Volume_in_KG_Month_05__c,Month_05_Populated());}
        else if (ValueType=='VolumeinLB') {result=styleVolumeinLB(LineItemRec.Volume_in_LB_MOnth_05__c,Month_05_Populated());} 
        else if (ValueType=='VolumeinUN') {result=styleVolumeinUN(LineItemRec.Volume_in_UN_MOnth_05__c,Month_05_Populated());} 
        else if (ValueType=='VolumeinGL') {result=styleVolumeinGL(LineItemRec.Volume_in_GL_MOnth_05__c,Month_05_Populated());} 
        else if (ValueType=='VolumeinPT') {result=styleVolumeinPT(LineItemRec.Volume_in_PT_MOnth_05__c,Month_05_Populated());} 
        else {result='';}
        return result;
    }

    public String getValue_Month_06() {
        String result = '';
        if (ValueType=='Amount') {result = getAmount_Month_06_formatted();}
        else if (ValueType=='GM') {result = getGM_Month_06_formatted();}        
        else if (ValueType=='GMpct') {result = getGMpct_Month_06_formatted();}      
        else if (ValueType=='VolumeinKG') {result = getVolume_in_KG_Month_06_formatted();}      
        else if (ValueType=='VolumeinLB') {result = getVolume_in_LB_Month_06_formatted();}      
        else if (ValueType=='VolumeinUN') {result = getVolume_in_UN_Month_06_formatted();}      
        else if (ValueType=='VolumeinGL') {result = getVolume_in_GL_Month_06_formatted();}      
        else if (ValueType=='VolumeinPT') {result = getVolume_in_PT_Month_06_formatted();}      
        return result;
    }

    public String getStyle_Month_06() {
        String result = '';
        if      (ValueType=='Amount')     {result=styleAmount(LineItemRec.Amount_Month_06__c,Month_06_Populated());}
        else if (ValueType=='GM')         {result=styleGM(LineItemRec.GM_Month_06__c,Month_06_Populated());}
        else if (ValueType=='GMpct')      {result=styleGMpct(LineItemRec.GMpct_Month_06__c,Month_06_Populated());}
        else if (ValueType=='VolumeinKG') {result=styleVolumeinKG(LineItemRec.Volume_in_KG_Month_06__c,Month_06_Populated());}
        else if (ValueType=='VolumeinLB') {result=styleVolumeinLB(LineItemRec.Volume_in_LB_MOnth_06__c,Month_06_Populated());} 
        else if (ValueType=='VolumeinUN') {result=styleVolumeinUN(LineItemRec.Volume_in_UN_MOnth_06__c,Month_06_Populated());} 
        else if (ValueType=='VolumeinGL') {result=styleVolumeinGL(LineItemRec.Volume_in_GL_MOnth_06__c,Month_06_Populated());} 
        else if (ValueType=='VolumeinPT') {result=styleVolumeinPT(LineItemRec.Volume_in_PT_MOnth_06__c,Month_06_Populated());} 
        else {result='';}
        return result;
    }

    public String getValue_Month_07() {
        String result = '';
        if (ValueType=='Amount') {result = getAmount_Month_07_formatted();}
        else if (ValueType=='GM') {result = getGM_Month_07_formatted();}        
        else if (ValueType=='GMpct') {result = getGMpct_Month_07_formatted();}      
        else if (ValueType=='VolumeinKG') {result = getVolume_in_KG_Month_07_formatted();}      
        else if (ValueType=='VolumeinLB') {result = getVolume_in_LB_Month_07_formatted();}      
        else if (ValueType=='VolumeinUN') {result = getVolume_in_UN_Month_07_formatted();}      
        else if (ValueType=='VolumeinGL') {result = getVolume_in_GL_Month_07_formatted();}      
        else if (ValueType=='VolumeinPT') {result = getVolume_in_PT_Month_07_formatted();}      
        return result;
    }

    public String getStyle_Month_07() {
        String result = '';
        if      (ValueType=='Amount')     {result=styleAmount(LineItemRec.Amount_Month_07__c,Month_07_Populated());}
        else if (ValueType=='GM')         {result=styleGM(LineItemRec.GM_Month_07__c,Month_07_Populated());}
        else if (ValueType=='GMpct')      {result=styleGMpct(LineItemRec.GMpct_Month_07__c,Month_07_Populated());}
        else if (ValueType=='VolumeinKG') {result=styleVolumeinKG(LineItemRec.Volume_in_KG_Month_07__c,Month_07_Populated());}
        else if (ValueType=='VolumeinLB') {result=styleVolumeinLB(LineItemRec.Volume_in_LB_MOnth_07__c,Month_07_Populated());} 
        else if (ValueType=='VolumeinUN') {result=styleVolumeinUN(LineItemRec.Volume_in_UN_MOnth_07__c,Month_07_Populated());} 
        else if (ValueType=='VolumeinGL') {result=styleVolumeinGL(LineItemRec.Volume_in_GL_MOnth_07__c,Month_07_Populated());} 
        else if (ValueType=='VolumeinPT') {result=styleVolumeinPT(LineItemRec.Volume_in_PT_MOnth_07__c,Month_07_Populated());} 
        else {result='';}
        return result;
    }

    public String getValue_Month_08() {
        String result = '';
        if (ValueType=='Amount') {result = getAmount_Month_08_formatted();}
        else if (ValueType=='GM') {result = getGM_Month_08_formatted();}        
        else if (ValueType=='GMpct') {result = getGMpct_Month_08_formatted();}      
        else if (ValueType=='VolumeinKG') {result = getVolume_in_KG_Month_08_formatted();}      
        else if (ValueType=='VolumeinLB') {result = getVolume_in_LB_Month_08_formatted();}      
        else if (ValueType=='VolumeinUN') {result = getVolume_in_UN_Month_08_formatted();}      
        else if (ValueType=='VolumeinGL') {result = getVolume_in_GL_Month_08_formatted();}      
        else if (ValueType=='VolumeinPT') {result = getVolume_in_PT_Month_08_formatted();}      
        return result;
    }

    public String getStyle_Month_08() {
        String result = '';
        if      (ValueType=='Amount')     {result=styleAmount(LineItemRec.Amount_Month_08__c,Month_08_Populated());}
        else if (ValueType=='GM')         {result=styleGM(LineItemRec.GM_Month_08__c,Month_08_Populated());}
        else if (ValueType=='GMpct')      {result=styleGMpct(LineItemRec.GMpct_Month_08__c,Month_08_Populated());}
        else if (ValueType=='VolumeinKG') {result=styleVolumeinKG(LineItemRec.Volume_in_KG_Month_08__c,Month_08_Populated());}
        else if (ValueType=='VolumeinLB') {result=styleVolumeinLB(LineItemRec.Volume_in_LB_MOnth_08__c,Month_08_Populated());} 
        else if (ValueType=='VolumeinUN') {result=styleVolumeinUN(LineItemRec.Volume_in_UN_MOnth_08__c,Month_08_Populated());} 
        else if (ValueType=='VolumeinGL') {result=styleVolumeinGL(LineItemRec.Volume_in_GL_MOnth_08__c,Month_08_Populated());} 
        else if (ValueType=='VolumeinPT') {result=styleVolumeinPT(LineItemRec.Volume_in_PT_MOnth_08__c,Month_08_Populated());} 
        else {result='';}
        return result;
    }

    public String getValue_Month_09() {
        String result = '';
        if (ValueType=='Amount') {result = getAmount_Month_09_formatted();}
        else if (ValueType=='GM') {result = getGM_Month_09_formatted();}        
        else if (ValueType=='GMpct') {result = getGMpct_Month_09_formatted();}      
        else if (ValueType=='VolumeinKG') {result = getVolume_in_KG_Month_09_formatted();}      
        else if (ValueType=='VolumeinLB') {result = getVolume_in_LB_Month_09_formatted();}      
        else if (ValueType=='VolumeinUN') {result = getVolume_in_UN_Month_09_formatted();}      
        else if (ValueType=='VolumeinGL') {result = getVolume_in_GL_Month_09_formatted();}      
        else if (ValueType=='VolumeinPT') {result = getVolume_in_PT_Month_09_formatted();}      
        return result;
    }

    public String getStyle_Month_09() {
        String result = '';
        if      (ValueType=='Amount')     {result=styleAmount(LineItemRec.Amount_Month_09__c,Month_09_Populated());}
        else if (ValueType=='GM')         {result=styleGM(LineItemRec.GM_Month_09__c,Month_09_Populated());}
        else if (ValueType=='GMpct')      {result=styleGMpct(LineItemRec.GMpct_Month_09__c,Month_09_Populated());}
        else if (ValueType=='VolumeinKG') {result=styleVolumeinKG(LineItemRec.Volume_in_KG_Month_09__c,Month_09_Populated());}
        else if (ValueType=='VolumeinLB') {result=styleVolumeinLB(LineItemRec.Volume_in_LB_MOnth_09__c,Month_09_Populated());} 
        else if (ValueType=='VolumeinUN') {result=styleVolumeinUN(LineItemRec.Volume_in_UN_MOnth_09__c,Month_09_Populated());} 
        else if (ValueType=='VolumeinGL') {result=styleVolumeinGL(LineItemRec.Volume_in_GL_MOnth_09__c,Month_09_Populated());} 
        else if (ValueType=='VolumeinPT') {result=styleVolumeinPT(LineItemRec.Volume_in_PT_MOnth_09__c,Month_09_Populated());} 
        else {result='';}
        return result;
    }

    public String getValue_Month_10() {
        String result = '';
        if (ValueType=='Amount') {result = getAmount_Month_10_formatted();}
        else if (ValueType=='GM') {result = getGM_Month_10_formatted();}        
        else if (ValueType=='GMpct') {result = getGMpct_Month_10_formatted();}      
        else if (ValueType=='VolumeinKG') {result = getVolume_in_KG_Month_10_formatted();}      
        else if (ValueType=='VolumeinLB') {result = getVolume_in_LB_Month_10_formatted();}      
        else if (ValueType=='VolumeinUN') {result = getVolume_in_UN_Month_10_formatted();}      
        else if (ValueType=='VolumeinGL') {result = getVolume_in_GL_Month_10_formatted();}      
        else if (ValueType=='VolumeinPT') {result = getVolume_in_PT_Month_10_formatted();}      
        return result;
    }

    public String getStyle_Month_10() {
        String result = '';
        if      (ValueType=='Amount')     {result=styleAmount(LineItemRec.Amount_Month_10__c,Month_10_Populated());}
        else if (ValueType=='GM')         {result=styleGM(LineItemRec.GM_Month_10__c,Month_10_Populated());}
        else if (ValueType=='GMpct')      {result=styleGMpct(LineItemRec.GMpct_Month_10__c,Month_10_Populated());}
        else if (ValueType=='VolumeinKG') {result=styleVolumeinKG(LineItemRec.Volume_in_KG_Month_10__c,Month_10_Populated());}
        else if (ValueType=='VolumeinLB') {result=styleVolumeinLB(LineItemRec.Volume_in_LB_MOnth_10__c,Month_10_Populated());} 
        else if (ValueType=='VolumeinUN') {result=styleVolumeinUN(LineItemRec.Volume_in_UN_MOnth_10__c,Month_10_Populated());} 
        else if (ValueType=='VolumeinGL') {result=styleVolumeinGL(LineItemRec.Volume_in_GL_MOnth_10__c,Month_10_Populated());} 
        else if (ValueType=='VolumeinPT') {result=styleVolumeinPT(LineItemRec.Volume_in_PT_MOnth_10__c,Month_10_Populated());} 
        else {result='';}
        return result;
    }

    public String getValue_Month_11() {
        String result = '';
        if (ValueType=='Amount') {result = getAmount_Month_11_formatted();}
        else if (ValueType=='GM') {result = getGM_Month_11_formatted();}        
        else if (ValueType=='GMpct') {result = getGMpct_Month_11_formatted();}      
        else if (ValueType=='VolumeinKG') {result = getVolume_in_KG_Month_11_formatted();}      
        else if (ValueType=='VolumeinLB') {result = getVolume_in_LB_Month_11_formatted();}      
        else if (ValueType=='VolumeinUN') {result = getVolume_in_UN_Month_11_formatted();}      
        else if (ValueType=='VolumeinGL') {result = getVolume_in_GL_Month_11_formatted();}      
        else if (ValueType=='VolumeinPT') {result = getVolume_in_PT_Month_11_formatted();}      
        return result;
    }

    public String getStyle_Month_11() {
        String result = '';
        if      (ValueType=='Amount')     {result=styleAmount(LineItemRec.Amount_Month_11__c,Month_11_Populated());}
        else if (ValueType=='GM')         {result=styleGM(LineItemRec.GM_Month_11__c,Month_11_Populated());}
        else if (ValueType=='GMpct')      {result=styleGMpct(LineItemRec.GMpct_Month_11__c,Month_11_Populated());}
        else if (ValueType=='VolumeinKG') {result=styleVolumeinKG(LineItemRec.Volume_in_KG_Month_11__c,Month_11_Populated());}
        else if (ValueType=='VolumeinLB') {result=styleVolumeinLB(LineItemRec.Volume_in_LB_MOnth_11__c,Month_11_Populated());} 
        else if (ValueType=='VolumeinUN') {result=styleVolumeinUN(LineItemRec.Volume_in_UN_MOnth_11__c,Month_11_Populated());} 
        else if (ValueType=='VolumeinGL') {result=styleVolumeinGL(LineItemRec.Volume_in_GL_MOnth_11__c,Month_11_Populated());} 
        else if (ValueType=='VolumeinPT') {result=styleVolumeinPT(LineItemRec.Volume_in_PT_MOnth_11__c,Month_11_Populated());} 
        else {result='';}
        return result;
    }

    public String getValue_Month_12() {
        String result = '';
        if (ValueType=='Amount') {result = getAmount_Month_12_formatted();}
        else if (ValueType=='GM') {result = getGM_Month_12_formatted();}        
        else if (ValueType=='GMpct') {result = getGMpct_Month_12_formatted();}      
        else if (ValueType=='VolumeinKG') {result = getVolume_in_KG_Month_12_formatted();}      
        else if (ValueType=='VolumeinLB') {result = getVolume_in_LB_Month_12_formatted();}      
        else if (ValueType=='VolumeinUN') {result = getVolume_in_UN_Month_12_formatted();}      
        else if (ValueType=='VolumeinGL') {result = getVolume_in_GL_Month_12_formatted();}      
        else if (ValueType=='VolumeinPT') {result = getVolume_in_PT_Month_12_formatted();}      
        return result;
    }

    public String getStyle_Month_12() {
        String result = '';
        if      (ValueType=='Amount')     {result=styleAmount(LineItemRec.Amount_Month_12__c,Month_12_Populated());}
        else if (ValueType=='GM')         {result=styleGM(LineItemRec.GM_Month_12__c,Month_12_Populated());}
        else if (ValueType=='GMpct')      {result=styleGMpct(LineItemRec.GMpct_Month_12__c,Month_12_Populated());}
        else if (ValueType=='VolumeinKG') {result=styleVolumeinKG(LineItemRec.Volume_in_KG_Month_12__c,Month_12_Populated());}
        else if (ValueType=='VolumeinLB') {result=styleVolumeinLB(LineItemRec.Volume_in_LB_MOnth_12__c,Month_12_Populated());} 
        else if (ValueType=='VolumeinUN') {result=styleVolumeinUN(LineItemRec.Volume_in_UN_MOnth_12__c,Month_12_Populated());} 
        else if (ValueType=='VolumeinGL') {result=styleVolumeinGL(LineItemRec.Volume_in_GL_MOnth_12__c,Month_12_Populated());} 
        else if (ValueType=='VolumeinPT') {result=styleVolumeinPT(LineItemRec.Volume_in_PT_MOnth_12__c,Month_12_Populated());} 
        else {result='';}
        return result;
    }

    public String getValue_Month_13() {
        String result = '';
        if (ValueType=='Amount') {result = getAmount_Month_13_formatted();}
        else if (ValueType=='GM') {result = getGM_Month_13_formatted();}        
        else if (ValueType=='GMpct') {result = getGMpct_Month_13_formatted();}      
        else if (ValueType=='VolumeinKG') {result = getVolume_in_KG_Month_13_formatted();}      
        else if (ValueType=='VolumeinLB') {result = getVolume_in_LB_Month_13_formatted();}      
        else if (ValueType=='VolumeinUN') {result = getVolume_in_UN_Month_13_formatted();}      
        else if (ValueType=='VolumeinGL') {result = getVolume_in_GL_Month_13_formatted();}      
        else if (ValueType=='VolumeinPT') {result = getVolume_in_PT_Month_13_formatted();}      
        return result;
    }

    public String getStyle_Month_13() {
        String result = '';
        if      (ValueType=='Amount')     {result=styleAmount(LineItemRec.Amount_Month_13__c,Month_13_Populated());}
        else if (ValueType=='GM')         {result=styleGM(LineItemRec.GM_Month_13__c,Month_13_Populated());}
        else if (ValueType=='GMpct')      {result=styleGMpct(LineItemRec.GMpct_Month_13__c,Month_13_Populated());}
        else if (ValueType=='VolumeinKG') {result=styleVolumeinKG(LineItemRec.Volume_in_KG_Month_13__c,Month_13_Populated());}
        else if (ValueType=='VolumeinLB') {result=styleVolumeinLB(LineItemRec.Volume_in_LB_MOnth_13__c,Month_13_Populated());} 
        else if (ValueType=='VolumeinUN') {result=styleVolumeinUN(LineItemRec.Volume_in_UN_MOnth_13__c,Month_13_Populated());} 
        else if (ValueType=='VolumeinGL') {result=styleVolumeinGL(LineItemRec.Volume_in_GL_MOnth_13__c,Month_13_Populated());} 
        else if (ValueType=='VolumeinPT') {result=styleVolumeinPT(LineItemRec.Volume_in_PT_MOnth_13__c,Month_13_Populated());} 
        else {result='';}
        return result;
    }

    private String format_Amount(Decimal valueIn,Boolean recPopulated) {
        String result = '';
        result = Math_Functions.formatNumber(valueIn.doubleValue(),0,true,true);
        if ((result != '0') || (recPopulated)) 
             {result += ' ' + LineItemRec.CurrencyIsoCode;} 
        else {result = '-';}
        return result;
    }

    public String getAmount_Month_01_formatted() { return format_Amount(LineItemRec.Amount_Month_01__c,Month_01_Populated()); }
    public String getAmount_Month_02_formatted() { return format_Amount(LineItemRec.Amount_Month_02__c,Month_02_Populated()); }
    public String getAmount_Month_03_formatted() { return format_Amount(LineItemRec.Amount_Month_03__c,Month_03_Populated()); }
    public String getAmount_Month_04_formatted() { return format_Amount(LineItemRec.Amount_Month_04__c,Month_04_Populated()); }
    public String getAmount_Month_05_formatted() { return format_Amount(LineItemRec.Amount_Month_05__c,Month_05_Populated()); }
    public String getAmount_Month_06_formatted() { return format_Amount(LineItemRec.Amount_Month_06__c,Month_06_Populated()); }
    public String getAmount_Month_07_formatted() { return format_Amount(LineItemRec.Amount_Month_07__c,Month_07_Populated()); }
    public String getAmount_Month_08_formatted() { return format_Amount(LineItemRec.Amount_Month_08__c,Month_08_Populated()); }
    public String getAmount_Month_09_formatted() { return format_Amount(LineItemRec.Amount_Month_09__c,Month_09_Populated()); }
    public String getAmount_Month_10_formatted() { return format_Amount(LineItemRec.Amount_Month_10__c,Month_10_Populated()); }
    public String getAmount_Month_11_formatted() { return format_Amount(LineItemRec.Amount_Month_11__c,Month_11_Populated()); }
    public String getAmount_Month_12_formatted() { return format_Amount(LineItemRec.Amount_Month_12__c,Month_12_Populated()); }
    public String getAmount_Month_13_formatted() { return format_Amount(LineItemRec.Amount_Month_13__c,Month_13_Populated()); }

    public String getLabel_Month_01_formatted() { return LineItemRec.Label_Month_01__c; }
    public String getLabel_Month_02_formatted() { return LineItemRec.Label_Month_02__c; }
    public String getLabel_Month_03_formatted() { return LineItemRec.Label_Month_03__c; }
    public String getLabel_Month_04_formatted() { return LineItemRec.Label_Month_04__c; }
    public String getLabel_Month_05_formatted() { return LineItemRec.Label_Month_05__c; }
    public String getLabel_Month_06_formatted() { return LineItemRec.Label_Month_06__c; }
    public String getLabel_Month_07_formatted() { return LineItemRec.Label_Month_07__c; }
    public String getLabel_Month_08_formatted() { return LineItemRec.Label_Month_08__c; }
    public String getLabel_Month_09_formatted() { return LineItemRec.Label_Month_09__c; }
    public String getLabel_Month_10_formatted() { return LineItemRec.Label_Month_10__c; }
    public String getLabel_Month_11_formatted() { return LineItemRec.Label_Month_11__c; }
    public String getLabel_Month_12_formatted() { return LineItemRec.Label_Month_12__c; }
    public String getLabel_Month_13_formatted() { return LineItemRec.Label_Month_13__c; }

    private String format_GM(Decimal valueIn,Boolean recPopulated) {
        String result = '';
        result = Math_Functions.formatNumber(valueIn.doubleValue(),2,true,true);
        if ((result != '0.00') || (recPopulated)) {result += ' ' + LineItemRec.CurrencyIsoCode;} else {result = '-';}
        return result;

    }

    public String getGM_Month_01_formatted() { return format_GM(LineItemRec.GM_Month_01__c,Month_01_Populated()); }
    public String getGM_Month_02_formatted() { return format_GM(LineItemRec.GM_Month_02__c,Month_02_Populated()); }
    public String getGM_Month_03_formatted() { return format_GM(LineItemRec.GM_Month_03__c,Month_03_Populated()); }
    public String getGM_Month_04_formatted() { return format_GM(LineItemRec.GM_Month_04__c,Month_04_Populated()); }
    public String getGM_Month_05_formatted() { return format_GM(LineItemRec.GM_Month_05__c,Month_05_Populated()); }
    public String getGM_Month_06_formatted() { return format_GM(LineItemRec.GM_Month_06__c,Month_06_Populated()); }
    public String getGM_Month_07_formatted() { return format_GM(LineItemRec.GM_Month_07__c,Month_07_Populated()); }
    public String getGM_Month_08_formatted() { return format_GM(LineItemRec.GM_Month_08__c,Month_08_Populated()); }
    public String getGM_Month_09_formatted() { return format_GM(LineItemRec.GM_Month_09__c,Month_09_Populated()); }
    public String getGM_Month_10_formatted() { return format_GM(LineItemRec.GM_Month_10__c,Month_10_Populated()); }
    public String getGM_Month_11_formatted() { return format_GM(LineItemRec.GM_Month_11__c,Month_11_Populated()); }
    public String getGM_Month_12_formatted() { return format_GM(LineItemRec.GM_Month_12__c,Month_12_Populated()); }
    public String getGM_Month_13_formatted() { return format_GM(LineItemRec.GM_Month_13__c,Month_13_Populated()); }

    private String format_GMpct(Decimal valueIn,Boolean recPopulated) {
        String result = '';
        result = Math_Functions.formatNumber(valueIn.doubleValue(),2,true,true);
        if (result == '0.00')
            {
            if (recPopulated) {result = 'X';} else {result = '-';}  
            }
        else {result += ' %';}
        return result;
    }

    public String getGMpct_Month_01_formatted() { return format_GMpct(LineItemRec.GMpct_Month_01__c,Month_01_Populated()); }
    public String getGMpct_Month_02_formatted() { return format_GMpct(LineItemRec.GMpct_Month_02__c,Month_02_Populated()); }
    public String getGMpct_Month_03_formatted() { return format_GMpct(LineItemRec.GMpct_Month_03__c,Month_03_Populated()); }
    public String getGMpct_Month_04_formatted() { return format_GMpct(LineItemRec.GMpct_Month_04__c,Month_04_Populated()); }
    public String getGMpct_Month_05_formatted() { return format_GMpct(LineItemRec.GMpct_Month_05__c,Month_05_Populated()); }
    public String getGMpct_Month_06_formatted() { return format_GMpct(LineItemRec.GMpct_Month_06__c,Month_06_Populated()); }
    public String getGMpct_Month_07_formatted() { return format_GMpct(LineItemRec.GMpct_Month_07__c,Month_07_Populated()); }
    public String getGMpct_Month_08_formatted() { return format_GMpct(LineItemRec.GMpct_Month_08__c,Month_08_Populated()); }
    public String getGMpct_Month_09_formatted() { return format_GMpct(LineItemRec.GMpct_Month_09__c,Month_09_Populated()); }
    public String getGMpct_Month_10_formatted() { return format_GMpct(LineItemRec.GMpct_Month_10__c,Month_10_Populated()); }
    public String getGMpct_Month_11_formatted() { return format_GMpct(LineItemRec.GMpct_Month_11__c,Month_11_Populated()); }
    public String getGMpct_Month_12_formatted() { return format_GMpct(LineItemRec.GMpct_Month_12__c,Month_12_Populated()); }
    public String getGMpct_Month_13_formatted() { return format_GMpct(LineItemRec.GMpct_Month_13__c,Month_13_Populated()); }

    private String format_Volume_in_KG(Double valueIn,Boolean recPopulated) {
        String result = '';
        result = Math_Functions.formatNumber(valueIn,0,true,true);
        if (result != '0') {result += ' KG';} else {result = '-';}
        return result;
    }

    public String getVolume_in_KG_Month_01_formatted() { return format_Volume_in_KG(LineItemRec.Volume_in_KG_Month_01__c,Month_01_Populated()); }
    public String getVolume_in_KG_Month_02_formatted() { return format_Volume_in_KG(LineItemRec.Volume_in_KG_Month_02__c,Month_02_Populated()); }
    public String getVolume_in_KG_Month_03_formatted() { return format_Volume_in_KG(LineItemRec.Volume_in_KG_Month_03__c,Month_03_Populated()); }
    public String getVolume_in_KG_Month_04_formatted() { return format_Volume_in_KG(LineItemRec.Volume_in_KG_Month_04__c,Month_04_Populated()); }
    public String getVolume_in_KG_Month_05_formatted() { return format_Volume_in_KG(LineItemRec.Volume_in_KG_Month_05__c,Month_05_Populated()); }
    public String getVolume_in_KG_Month_06_formatted() { return format_Volume_in_KG(LineItemRec.Volume_in_KG_Month_06__c,Month_06_Populated()); }
    public String getVolume_in_KG_Month_07_formatted() { return format_Volume_in_KG(LineItemRec.Volume_in_KG_Month_07__c,Month_07_Populated()); }
    public String getVolume_in_KG_Month_08_formatted() { return format_Volume_in_KG(LineItemRec.Volume_in_KG_Month_08__c,Month_08_Populated()); }
    public String getVolume_in_KG_Month_09_formatted() { return format_Volume_in_KG(LineItemRec.Volume_in_KG_Month_09__c,Month_09_Populated()); }
    public String getVolume_in_KG_Month_10_formatted() { return format_Volume_in_KG(LineItemRec.Volume_in_KG_Month_10__c,Month_10_Populated()); }
    public String getVolume_in_KG_Month_11_formatted() { return format_Volume_in_KG(LineItemRec.Volume_in_KG_Month_11__c,Month_11_Populated()); }
    public String getVolume_in_KG_Month_12_formatted() { return format_Volume_in_KG(LineItemRec.Volume_in_KG_Month_12__c,Month_12_Populated()); }
    public String getVolume_in_KG_Month_13_formatted() { return format_Volume_in_KG(LineItemRec.Volume_in_KG_Month_13__c,Month_13_Populated()); }

    private String format_Volume_in_LB(Double valueIn,Boolean recPopulated) {
        String result = '';
        result = Math_Functions.formatNumber(valueIn,0,true,true);
        if (result != '0') {result += ' LB';} else {result = '-';}
        return result;
    }

    public String getVolume_in_LB_Month_01_formatted() { return format_Volume_in_LB(LineItemRec.Volume_in_LB_Month_01__c,Month_01_Populated()); }
    public String getVolume_in_LB_Month_02_formatted() { return format_Volume_in_LB(LineItemRec.Volume_in_LB_Month_02__c,Month_02_Populated()); }
    public String getVolume_in_LB_Month_03_formatted() { return format_Volume_in_LB(LineItemRec.Volume_in_LB_Month_03__c,Month_03_Populated()); }
    public String getVolume_in_LB_Month_04_formatted() { return format_Volume_in_LB(LineItemRec.Volume_in_LB_Month_04__c,Month_04_Populated()); }
    public String getVolume_in_LB_Month_05_formatted() { return format_Volume_in_LB(LineItemRec.Volume_in_LB_Month_05__c,Month_05_Populated()); }
    public String getVolume_in_LB_Month_06_formatted() { return format_Volume_in_LB(LineItemRec.Volume_in_LB_Month_06__c,Month_06_Populated()); }
    public String getVolume_in_LB_Month_07_formatted() { return format_Volume_in_LB(LineItemRec.Volume_in_LB_Month_07__c,Month_07_Populated()); }
    public String getVolume_in_LB_Month_08_formatted() { return format_Volume_in_LB(LineItemRec.Volume_in_LB_Month_08__c,Month_08_Populated()); }
    public String getVolume_in_LB_Month_09_formatted() { return format_Volume_in_LB(LineItemRec.Volume_in_LB_Month_09__c,Month_09_Populated()); }
    public String getVolume_in_LB_Month_10_formatted() { return format_Volume_in_LB(LineItemRec.Volume_in_LB_Month_10__c,Month_10_Populated()); }
    public String getVolume_in_LB_Month_11_formatted() { return format_Volume_in_LB(LineItemRec.Volume_in_LB_Month_11__c,Month_11_Populated()); }
    public String getVolume_in_LB_Month_12_formatted() { return format_Volume_in_LB(LineItemRec.Volume_in_LB_Month_12__c,Month_12_Populated()); }
    public String getVolume_in_LB_Month_13_formatted() { return format_Volume_in_LB(LineItemRec.Volume_in_LB_Month_13__c,Month_13_Populated()); }

    private String format_Volume_in_UN(Double valueIn,Boolean recPopulated) {
        String result = '';
        result = Math_Functions.formatNumber(valueIn,0,true,true);
        if (result != '0') {result += ' UN';} else {result = '-';}
        return result;
    }

    public String getVolume_in_UN_Month_01_formatted() { return format_Volume_in_UN(LineItemRec.Volume_in_UN_Month_01__c,Month_01_Populated()); }
    public String getVolume_in_UN_Month_02_formatted() { return format_Volume_in_UN(LineItemRec.Volume_in_UN_Month_02__c,Month_02_Populated()); }
    public String getVolume_in_UN_Month_03_formatted() { return format_Volume_in_UN(LineItemRec.Volume_in_UN_Month_03__c,Month_03_Populated()); }
    public String getVolume_in_UN_Month_04_formatted() { return format_Volume_in_UN(LineItemRec.Volume_in_UN_Month_04__c,Month_04_Populated()); }
    public String getVolume_in_UN_Month_05_formatted() { return format_Volume_in_UN(LineItemRec.Volume_in_UN_Month_05__c,Month_05_Populated()); }
    public String getVolume_in_UN_Month_06_formatted() { return format_Volume_in_UN(LineItemRec.Volume_in_UN_Month_06__c,Month_06_Populated()); }
    public String getVolume_in_UN_Month_07_formatted() { return format_Volume_in_UN(LineItemRec.Volume_in_UN_Month_07__c,Month_07_Populated()); }
    public String getVolume_in_UN_Month_08_formatted() { return format_Volume_in_UN(LineItemRec.Volume_in_UN_Month_08__c,Month_08_Populated()); }
    public String getVolume_in_UN_Month_09_formatted() { return format_Volume_in_UN(LineItemRec.Volume_in_UN_Month_09__c,Month_09_Populated()); }
    public String getVolume_in_UN_Month_10_formatted() { return format_Volume_in_UN(LineItemRec.Volume_in_UN_Month_10__c,Month_10_Populated()); }
    public String getVolume_in_UN_Month_11_formatted() { return format_Volume_in_UN(LineItemRec.Volume_in_UN_Month_11__c,Month_11_Populated()); }
    public String getVolume_in_UN_Month_12_formatted() { return format_Volume_in_UN(LineItemRec.Volume_in_UN_Month_12__c,Month_12_Populated()); }
    public String getVolume_in_UN_Month_13_formatted() { return format_Volume_in_UN(LineItemRec.Volume_in_UN_Month_13__c,Month_13_Populated()); }

    private String format_Volume_in_GL(Double valueIn,Boolean recPopulated) {
        String result = '';
        result = Math_Functions.formatNumber(valueIn,0,true,true);
        if (result != '0') {result += ' GL';} else {result = '-';}
        return result;
    }

    public String getVolume_in_GL_Month_01_formatted() { return format_Volume_in_GL(LineItemRec.Volume_in_GL_Month_01__c,Month_01_Populated()); }
    public String getVolume_in_GL_Month_02_formatted() { return format_Volume_in_GL(LineItemRec.Volume_in_GL_Month_02__c,Month_02_Populated()); }
    public String getVolume_in_GL_Month_03_formatted() { return format_Volume_in_GL(LineItemRec.Volume_in_GL_Month_03__c,Month_03_Populated()); }
    public String getVolume_in_GL_Month_04_formatted() { return format_Volume_in_GL(LineItemRec.Volume_in_GL_Month_04__c,Month_04_Populated()); }
    public String getVolume_in_GL_Month_05_formatted() { return format_Volume_in_GL(LineItemRec.Volume_in_GL_Month_05__c,Month_05_Populated()); }
    public String getVolume_in_GL_Month_06_formatted() { return format_Volume_in_GL(LineItemRec.Volume_in_GL_Month_06__c,Month_06_Populated()); }
    public String getVolume_in_GL_Month_07_formatted() { return format_Volume_in_GL(LineItemRec.Volume_in_GL_Month_07__c,Month_07_Populated()); }
    public String getVolume_in_GL_Month_08_formatted() { return format_Volume_in_GL(LineItemRec.Volume_in_GL_Month_08__c,Month_08_Populated()); }
    public String getVolume_in_GL_Month_09_formatted() { return format_Volume_in_GL(LineItemRec.Volume_in_GL_Month_09__c,Month_09_Populated()); }
    public String getVolume_in_GL_Month_10_formatted() { return format_Volume_in_GL(LineItemRec.Volume_in_GL_Month_10__c,Month_10_Populated()); }
    public String getVolume_in_GL_Month_11_formatted() { return format_Volume_in_GL(LineItemRec.Volume_in_GL_Month_11__c,Month_11_Populated()); }
    public String getVolume_in_GL_Month_12_formatted() { return format_Volume_in_GL(LineItemRec.Volume_in_GL_Month_12__c,Month_12_Populated()); }
    public String getVolume_in_GL_Month_13_formatted() { return format_Volume_in_GL(LineItemRec.Volume_in_GL_Month_13__c,Month_13_Populated()); }

    private String format_Volume_in_PT(Double valueIn,Boolean recPopulated) {
        String result = '';
        result = Math_Functions.formatNumber(valueIn,0,true,true);
        if (result != '0') {result += ' PT';} else {result = '-';}
        return result;
    }

    public String getVolume_in_PT_Month_01_formatted() { return format_Volume_in_PT(LineItemRec.Volume_in_PT_Month_01__c,Month_01_Populated()); }
    public String getVolume_in_PT_Month_02_formatted() { return format_Volume_in_PT(LineItemRec.Volume_in_PT_Month_02__c,Month_02_Populated()); }
    public String getVolume_in_PT_Month_03_formatted() { return format_Volume_in_PT(LineItemRec.Volume_in_PT_Month_03__c,Month_03_Populated()); }
    public String getVolume_in_PT_Month_04_formatted() { return format_Volume_in_PT(LineItemRec.Volume_in_PT_Month_04__c,Month_04_Populated()); }
    public String getVolume_in_PT_Month_05_formatted() { return format_Volume_in_PT(LineItemRec.Volume_in_PT_Month_05__c,Month_05_Populated()); }
    public String getVolume_in_PT_Month_06_formatted() { return format_Volume_in_PT(LineItemRec.Volume_in_PT_Month_06__c,Month_06_Populated()); }
    public String getVolume_in_PT_Month_07_formatted() { return format_Volume_in_PT(LineItemRec.Volume_in_PT_Month_07__c,Month_07_Populated()); }
    public String getVolume_in_PT_Month_08_formatted() { return format_Volume_in_PT(LineItemRec.Volume_in_PT_Month_08__c,Month_08_Populated()); }
    public String getVolume_in_PT_Month_09_formatted() { return format_Volume_in_PT(LineItemRec.Volume_in_PT_Month_09__c,Month_09_Populated()); }
    public String getVolume_in_PT_Month_10_formatted() { return format_Volume_in_PT(LineItemRec.Volume_in_PT_Month_10__c,Month_10_Populated()); }
    public String getVolume_in_PT_Month_11_formatted() { return format_Volume_in_PT(LineItemRec.Volume_in_PT_Month_11__c,Month_11_Populated()); }
    public String getVolume_in_PT_Month_12_formatted() { return format_Volume_in_PT(LineItemRec.Volume_in_PT_Month_12__c,Month_12_Populated()); }
    public String getVolume_in_PT_Month_13_formatted() { return format_Volume_in_PT(LineItemRec.Volume_in_PT_Month_13__c,Month_13_Populated()); }

//******************
//Test Method 
//******************

    public static testMethod void testMe() {

    }

//The End


}