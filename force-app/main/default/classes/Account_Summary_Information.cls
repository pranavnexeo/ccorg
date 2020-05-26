public class Account_Summary_Information {

    private static final Date CY_StartDate = Rolling_Product_Sales_Info_Functions2.getStartDate();
    
    public Account_Summary_Information(){init();}
    
    private Date CFY_StartDate, CFY_EndDate, PFY_StartDate, PFY_EndDate;

    Map<Integer,String> MonthLabels = new Map<Integer,String>{1 => 'JAN',
                                                              2 => 'FEB',
                                                              3 => 'MAR',
                                                              4 => 'APR',
                                                              5 => 'MAY',
                                                              6 => 'JUN',
                                                              7 => 'JUL',
                                                              8 => 'AUG',
                                                              9 => 'SEP',
                                                             10 => 'OCT',
                                                             11 => 'NOV',
                                                             12 => 'DEC'};

    private Date CM_StartDate;
    private Date CM_EndDate;
    private Double CM_Volume_in_LB;     
    private Double CM_Volume_in_KG;     
    private Double CM_Volume_in_UN;     
    private Double CM_Volume_in_GL;     
    private Double CM_Volume_in_PT;     
    private Decimal CM_Amount;     
    private Decimal CM_GM;     
    private Double CM_GMpct;     
    private String CM_Currency;     

    private Date PYCM_StartDate;
    private Date PYCM_EndDate;
    private Double PYCM_Volume_in_LB;     
    private Double PYCM_Volume_in_KG;     
    private Double PYCM_Volume_in_UN;     
    private Double PYCM_Volume_in_GL;     
    private Double PYCM_Volume_in_PT;     
    private Decimal PYCM_Amount;     
    private Decimal PYCM_GM;     
    private Double PYCM_GMpct;     
    private String PYCM_Currency;     

    private Double CMvsPYCM_Volume_in_LB_Variance { get{try {return CM_Volume_in_LB - PYCM_Volume_in_LB;} catch (exception e) {return null;}} }     
    private Double CMvsPYCM_Volume_in_KG_Variance { get{try {return CM_Volume_in_KG - PYCM_Volume_in_KG;} catch (exception e) {return null;}} }      
    private Double CMvsPYCM_Volume_in_UN_Variance { get{try {return CM_Volume_in_UN - PYCM_Volume_in_UN;} catch (exception e) {return null;}} }      
    private Double CMvsPYCM_Volume_in_GL_Variance { get{try {return CM_Volume_in_GL - PYCM_Volume_in_GL;} catch (exception e) {return null;}} }      
    private Double CMvsPYCM_Volume_in_PT_Variance { get{try {return CM_Volume_in_PT - PYCM_Volume_in_PT;} catch (exception e) {return null;}} }      
    private Decimal CMvsPYCM_Amount_Variance { get{try {return CM_Amount - PYCM_Amount;} catch (exception e) {return null;}} }     
    private Decimal CMvsPYCM_GM_Variance { get{try {return CM_GM - PYCM_GM;} catch (exception e) {return null;}} }     
    private Double CMvsPYCM_GMpct_Variance { get{try {return CM_GMpct - PYCM_GMpct;} catch (exception e) {return null;}} }     
    private String CMvsPYCM_Currency { get{return CM_Currency;} }     

    private Date FYTD_StartDate;
    private Date FYTD_EndDate;
    private Double FYTD_Volume_in_LB;     
    private Double FYTD_Volume_in_KG;     
    private Double FYTD_Volume_in_UN;     
    private Double FYTD_Volume_in_GL;     
    private Double FYTD_Volume_in_PT;     
    private Decimal FYTD_Amount;     
    private Decimal FYTD_GM;     
    private Double FYTD_GMpct;     
    private String FYTD_Currency;     

    private Date PFYTD_StartDate;
    private Date PFYTD_EndDate;
    private Double PFYTD_Volume_in_LB;     
    private Double PFYTD_Volume_in_KG;     
    private Double PFYTD_Volume_in_UN;     
    private Double PFYTD_Volume_in_GL;     
    private Double PFYTD_Volume_in_PT;     
    private Decimal PFYTD_Amount;     
    private Decimal PFYTD_GM;     
    private Double PFYTD_GMpct;     
    private String PFYTD_Currency;     

    private Double FYTDvsPFYTD_Volume_in_LB_Variance { get{if (( FYTD_Volume_in_LB == null) || (PFYTD_Volume_in_LB == null)) {return null;} 
                                                           else {return FYTD_Volume_in_LB - PFYTD_Volume_in_LB;} } }
    private Double FYTDvsPFYTD_Volume_in_KG_Variance { get{if (( FYTD_Volume_in_KG == null) || (PFYTD_Volume_in_KG == null)) {return null;} 
                                                           else {return FYTD_Volume_in_KG - PFYTD_Volume_in_KG;} } }
    private Double FYTDvsPFYTD_Volume_in_UN_Variance { get{if (( FYTD_Volume_in_UN == null) || (PFYTD_Volume_in_UN == null)) {return null;} 
                                                           else {return FYTD_Volume_in_UN - PFYTD_Volume_in_UN;} } }
    private Double FYTDvsPFYTD_Volume_in_GL_Variance { get{if (( FYTD_Volume_in_GL == null) || (PFYTD_Volume_in_GL == null)) {return null;} 
                                                           else {return FYTD_Volume_in_GL - PFYTD_Volume_in_GL;} } }
    private Double FYTDvsPFYTD_Volume_in_PT_Variance { get{if (( FYTD_Volume_in_PT == null) || (PFYTD_Volume_in_PT == null)) {return null;} 
                                                           else {return FYTD_Volume_in_PT - PFYTD_Volume_in_PT;} } }
    private Double FYTDvsPFYTD_Amount_Variance { get{if (( FYTD_Amount == null) || (PFYTD_Amount == null)) {return null;} 
                                                           else {return FYTD_Amount - PFYTD_Amount;} } }
    private Double FYTDvsPFYTD_GM_Variance { get{if (( FYTD_GM == null) || (PFYTD_GM == null)) {return null;} 
                                                           else {return FYTD_GM - PFYTD_GM;} } }
    private Double FYTDvsPFYTD_GMpct_Variance { get{if (( FYTD_GMpct == null) || (PFYTD_GMpct == null)) {return null;} 
                                                           else {return FYTD_GMpct - PFYTD_GMpct;} } }
    private String FYTDvsPFYTD_Currency { get{return FYTD_Currency;} }     

    public String FYTDvsPFYTD_Volume_in_LB_Direction{ get{if (FYTDvsPFYTD_Volume_in_LB_Variance == null) {return 'null';}
                                                     else if (FYTDvsPFYTD_Volume_in_LB_Variance > 0.0) {return 'up';}
                                                     else if (FYTDvsPFYTD_Volume_in_LB_Variance < 0.0) {return 'down';} else {return 'equal';}} }
    public Boolean FYTDvsPFYTD_Volume_in_LB_Up { get{if (FYTDvsPFYTD_Volume_in_LB_Direction=='up') {return true;} else {return false;}}}                                                    
    public Boolean FYTDvsPFYTD_Volume_in_LB_Down { get{if (FYTDvsPFYTD_Volume_in_LB_Direction=='down') {return true;} else {return false;}}}                                                    

    public String FYTDvsPFYTD_Volume_in_KG_Direction{ get{if (FYTDvsPFYTD_Volume_in_KG_Variance == null) {return 'equal';}
                                                     else if (FYTDvsPFYTD_Volume_in_KG_Variance > 0.0) {return 'up';}
                                                     else if (FYTDvsPFYTD_Volume_in_KG_Variance < 0.0) {return 'down';} else {return 'equal';}} }
    public Boolean FYTDvsPFYTD_Volume_in_KG_Up { get{if (FYTDvsPFYTD_Volume_in_KG_Direction=='up') {return true;} else {return false;}}}                                                    
    public Boolean FYTDvsPFYTD_Volume_in_KG_Down { get{if (FYTDvsPFYTD_Volume_in_KG_Direction=='down') {return true;} else {return false;}}}                                                    
                                                    
    public String FYTDvsPFYTD_Volume_in_UN_Direction{ get{if (FYTDvsPFYTD_Volume_in_UN_Variance == null) {return 'equal';}
                                                     else if (FYTDvsPFYTD_Volume_in_UN_Variance > 0.0) {return 'up';}
                                                     else if (FYTDvsPFYTD_Volume_in_UN_Variance < 0.0) {return 'down';} else {return 'equal';}} }
    public Boolean FYTDvsPFYTD_Volume_in_UN_Up { get{if (FYTDvsPFYTD_Volume_in_UN_Direction=='up') {return true;} else {return false;}}}                                                    
    public Boolean FYTDvsPFYTD_Volume_in_UN_Down { get{if (FYTDvsPFYTD_Volume_in_UN_Direction=='down') {return true;} else {return false;}}}                                                    
                                                    
    public String FYTDvsPFYTD_Volume_in_GL_Direction{ get{if (FYTDvsPFYTD_Volume_in_GL_Variance == null) {return 'equal';}
                                                     else if (FYTDvsPFYTD_Volume_in_GL_Variance > 0.0) {return 'up';}
                                                     else if (FYTDvsPFYTD_Volume_in_GL_Variance < 0.0) {return 'down';} else {return 'equal';}} }
    public Boolean FYTDvsPFYTD_Volume_in_GL_Up { get{if (FYTDvsPFYTD_Volume_in_GL_Direction=='up') {return true;} else {return false;}}}                                                    
    public Boolean FYTDvsPFYTD_Volume_in_GL_Down { get{if (FYTDvsPFYTD_Volume_in_GL_Direction=='down') {return true;} else {return false;}}}                                                    
                                                    
    public String FYTDvsPFYTD_Volume_in_PT_Direction{ get{if (FYTDvsPFYTD_Volume_in_PT_Variance == null) {return 'equal';}
                                                     else if (FYTDvsPFYTD_Volume_in_PT_Variance > 0.0) {return 'up';}
                                                     else if (FYTDvsPFYTD_Volume_in_PT_Variance < 0.0) {return 'down';} else {return 'equal';}} }
    public Boolean FYTDvsPFYTD_Volume_in_PT_Up { get{if (FYTDvsPFYTD_Volume_in_PT_Direction=='up') {return true;} else {return false;}}}                                                    
    public Boolean FYTDvsPFYTD_Volume_in_PT_Down { get{if (FYTDvsPFYTD_Volume_in_PT_Direction=='down') {return true;} else {return false;}}}                                                    
                                                    
    public String FYTDvsPFYTD_Amount_Direction{ get{if (FYTDvsPFYTD_Amount_Variance == null) {return 'null';}
                                               else if (FYTDvsPFYTD_Amount_Variance > 0.0) {return 'up';}
                                               else if (FYTDvsPFYTD_Amount_Variance < 0.0) {return 'down';} else {return 'equal';}} }
    public Boolean FYTDvsPFYTD_Amount_Up { get{if (FYTDvsPFYTD_Amount_Direction=='up') {return true;} else {return false;}}}                                                    
    public Boolean FYTDvsPFYTD_Amount_Down { get{if (FYTDvsPFYTD_Amount_Direction=='down') {return true;} else {return false;}}}                                                    

    public String FYTDvsPFYTD_GM_Direction{ get{if (FYTDvsPFYTD_GM_Variance == null) {return 'null';}
                                           else if (FYTDvsPFYTD_GM_Variance > 0.0) {return 'up';}
                                           else if (FYTDvsPFYTD_GM_Variance < 0.0) {return 'down';} else {return 'equal';}} }
    public Boolean FYTDvsPFYTD_GM_Up { get{if (FYTDvsPFYTD_GM_Direction=='up') {return true;} else {return false;}}}                                                    
    public Boolean FYTDvsPFYTD_GM_Down { get{if (FYTDvsPFYTD_GM_Direction=='down') {return true;} else {return false;}}}                                                    

    public String FYTDvsPFYTD_GMpct_Direction{ get{if (FYTDvsPFYTD_GMpct_Variance == null) {return 'null';}
                                              else if (FYTDvsPFYTD_GMpct_Variance > 0.0) {return 'up';}
                                              else if (FYTDvsPFYTD_GMpct_Variance < 0.0) {return 'down';} else {return 'equal';}} }
    public Boolean FYTDvsPFYTD_GMpct_Up { get{if (FYTDvsPFYTD_GMpct_Direction=='up') {return true;} else {return false;}}}                                                  
    public Boolean FYTDvsPFYTD_GMpct_Down { get{if (FYTDvsPFYTD_GMpct_Direction=='down') {return true;} else {return false;}}}                                                  

    public String CM_Label { 
        get{
            return 'Current Month - ' + MonthLabels.get(CM_StartDate.month()) + '-' + CM_StartDate.year();
           } 
        }
    public String CM_Volume_in_LB_formatted { get{return format_Volume(CM_Volume_in_LB,'LB');} }     
    public String CM_Volume_in_KG_formatted { get{return format_Volume(CM_Volume_in_KG,'KG');} }     
    public String CM_Volume_in_UN_formatted { get{return format_Volume(CM_Volume_in_UN,'UN');} }     
    public String CM_Volume_in_GL_formatted { get{return format_Volume(CM_Volume_in_GL,'GL');} }     
    public String CM_Volume_in_PT_formatted { get{return format_Volume(CM_Volume_in_PT,'PT');} }     
    public String CM_Amount_formatted { get{return format_Amount(CM_Amount,CM_Currency);} }     
    public String CM_GM_formatted { get{return format_GM(CM_GM,CM_Currency);} }     
    public String CM_GMpct_formatted { get{return format_GMpct(CM_GMpct);} }     

    public String PYCM_Label { 
        get{
            return 'Prior Year Current Month - ' + MonthLabels.get(PYCM_StartDate.month()) + '-' + PYCM_StartDate.year();
           } 
        }
    public String PYCM_Volume_in_LB_formatted { get{return format_Volume(PYCM_Volume_in_LB,'LB');} }     
    public String PYCM_Volume_in_KG_formatted { get{return format_Volume(PYCM_Volume_in_KG,'KG');} }     
    public String PYCM_Volume_in_UN_formatted { get{return format_Volume(PYCM_Volume_in_UN,'UN');} }     
    public String PYCM_Volume_in_GL_formatted { get{return format_Volume(PYCM_Volume_in_GL,'GL');} }     
    public String PYCM_Volume_in_PT_formatted { get{return format_Volume(PYCM_Volume_in_PT,'PT');} }     
    public String PYCM_Amount_formatted { get{return format_Amount(PYCM_Amount,PYCM_Currency);} }     
    public String PYCM_GM_formatted { get{return format_GM(PYCM_GM,PYCM_Currency);} }     
    public String PYCM_GMpct_formatted { get{return format_GMpct(PYCM_GMpct);} }     

    public String CMvsPYCM_Label { 
        get{
            return 'CM vs PYCM Variance';
           } 
        }
    public String CMvsPYCM_Volume_in_LB_Variance_formatted { get{return format_Volume(CMvsPYCM_Volume_in_LB_Variance,'LB');} }     
    public String CMvsPYCM_Volume_in_KG_Variance_formatted { get{return format_Volume(CMvsPYCM_Volume_in_KG_Variance,'KG');} }     
    public String CMvsPYCM_Volume_in_UN_Variance_formatted { get{return format_Volume(CMvsPYCM_Volume_in_UN_Variance,'UN');} }     
    public String CMvsPYCM_Volume_in_GL_Variance_formatted { get{return format_Volume(CMvsPYCM_Volume_in_GL_Variance,'GL');} }     
    public String CMvsPYCM_Volume_in_PT_Variance_formatted { get{return format_Volume(CMvsPYCM_Volume_in_PT_Variance,'PT');} }     
    public String CMvsPYCM_Amount_Variance_formatted { get{return format_Amount(CMvsPYCM_Amount_Variance,CMvsPYCM_Currency);} }     
    public String CMvsPYCM_GM_Variance_formatted { get{return format_GM(CMvsPYCM_GM_Variance,CMvsPYCM_Currency);} }     
    public String CMvsPYCM_GMpct_Variance_formatted { get{return format_GMpct_Variance(CMvsPYCM_GMpct_Variance);} }     

    public String FYTD_Label { 
        get{if ((FYTD_StartDate != null) && (FYTD_EndDate != null)) 
                return 'FYTD (' + MonthLabels.get(FYTD_StartDate.month()) + '-' + FYTD_StartDate.year() + ' - ' + MonthLabels.get(FYTD_EndDate.month()) + '-' + FYTD_EndDate.year() + ')';
            else return '';
           } 
        }
    public String FYTD_Volume_in_LB_formatted { get{return format_Volume(FYTD_Volume_in_LB,'LB');} }     
    public String FYTD_Volume_in_KG_formatted { get{return format_Volume(FYTD_Volume_in_KG,'KG');} }     
    public String FYTD_Volume_in_UN_formatted { get{return format_Volume(FYTD_Volume_in_UN,'UN');} }     
    public String FYTD_Volume_in_GL_formatted { get{return format_Volume(FYTD_Volume_in_GL,'GL');} }     
    public String FYTD_Volume_in_PT_formatted { get{return format_Volume(FYTD_Volume_in_PT,'PT');} }     
    public String FYTD_Amount_formatted { get{return format_Amount(FYTD_Amount,FYTD_Currency);} }     
    public String FYTD_GM_formatted { get{return format_GM(FYTD_GM,FYTD_Currency);} }     
    public String FYTD_GMpct_formatted { get{return format_GMpct(FYTD_GMpct);} }     

    public String PFYTD_Label { 
        get{if ((PFYTD_StartDate != null) && (PFYTD_EndDate != null))
                return 'PFYTD (' + MonthLabels.get(PFYTD_StartDate.month()) + '-' + PFYTD_StartDate.year() + ' - ' + MonthLabels.get(PFYTD_EndDate.month()) + '-' + PFYTD_EndDate.year() + ')';
            else return '';
           } 
        }
    public String PFYTD_Volume_in_LB_formatted { get{return format_Volume(PFYTD_Volume_in_LB,'LB');} }     
    public String PFYTD_Volume_in_KG_formatted { get{return format_Volume(PFYTD_Volume_in_KG,'KG');} }     
    public String PFYTD_Volume_in_UN_formatted { get{return format_Volume(PFYTD_Volume_in_UN,'UN');} }     
    public String PFYTD_Volume_in_GL_formatted { get{return format_Volume(PFYTD_Volume_in_GL,'GL');} }     
    public String PFYTD_Volume_in_PT_formatted { get{return format_Volume(PFYTD_Volume_in_PT,'PT');} }     
    public String PFYTD_Amount_formatted { get{return format_Amount(PFYTD_Amount,PFYTD_Currency);} }     
    public String PFYTD_GM_formatted { get{return format_GM(PFYTD_GM,PFYTD_Currency);} }     
    public String PFYTD_GMpct_formatted { get{return format_GMpct(PFYTD_GMpct);} }     

    public String FYTDvsPFYTD_Label { 
        get{
            return 'FYTD vs PFYTD Variance';
           } 
        }
    public String FYTDvsPFYTD_Volume_in_LB_Variance_formatted { get{return format_Volume(FYTDvsPFYTD_Volume_in_LB_Variance,'LB');} }     
    public String FYTDvsPFYTD_Volume_in_KG_Variance_formatted { get{return format_Volume(FYTDvsPFYTD_Volume_in_KG_Variance,'KG');} }     
    public String FYTDvsPFYTD_Volume_in_UN_Variance_formatted { get{return format_Volume(FYTDvsPFYTD_Volume_in_UN_Variance,'UN');} }     
    public String FYTDvsPFYTD_Volume_in_GL_Variance_formatted { get{return format_Volume(FYTDvsPFYTD_Volume_in_GL_Variance,'GL');} }     
    public String FYTDvsPFYTD_Volume_in_PT_Variance_formatted { get{return format_Volume(FYTDvsPFYTD_Volume_in_PT_Variance,'PT');} }     
    public String FYTDvsPFYTD_Amount_Variance_formatted { get{return format_Amount(FYTDvsPFYTD_Amount_Variance,FYTDvsPFYTD_Currency);} }     
    public String FYTDvsPFYTD_GM_Variance_formatted { get{return format_GM(FYTDvsPFYTD_GM_Variance,FYTDvsPFYTD_Currency);} }     
    public String FYTDvsPFYTD_GMpct_Variance_formatted { get{return format_GMpct_Variance(FYTDvsPFYTD_GMpct_Variance);} }     

    public String CM_Volume_in_LB_style { get{return '';} }     
    public String CM_Volume_in_KG_style { get{return '';} }     
    public String CM_Volume_in_UN_style { get{return '';} }     
    public String CM_Volume_in_GL_style { get{return '';} }     
    public String CM_Volume_in_PT_style { get{return '';} }     
    public String CM_Amount_style { get{return '';} }     
    public String CM_GM_style { get{return '';} }     
    public String CM_GMpct_style { get{return '';} }     

    public String PYCM_Volume_in_LB_style { get{return '';} }     
    public String PYCM_Volume_in_KG_style { get{return '';} }     
    public String PYCM_Volume_in_UN_style { get{return '';} }     
    public String PYCM_Volume_in_GL_style { get{return '';} }     
    public String PYCM_Volume_in_PT_style { get{return '';} }     
    public String PYCM_Amount_style { get{return '';} }     
    public String PYCM_GM_style { get{return '';} }     
    public String PYCM_GMpct_style { get{return '';} }     

    public String CMvsPYCM_Volume_in_LB_Variance_style { get{return '';} }     
    public String CMvsPYCM_Volume_in_KG_Variance_style { get{return '';} }     
    public String CMvsPYCM_Volume_in_UN_Variance_style { get{return '';} }     
    public String CMvsPYCM_Volume_in_GL_Variance_style { get{return '';} }     
    public String CMvsPYCM_Volume_in_PT_Variance_style { get{return '';} }     
    public String CMvsPYCM_Amount_Variance_style { get{return '';} }     
    public String CMvsPYCM_GM_Variance_style { get{return '';} }     
    public String CMvsPYCM_GMpct_Variance_style { get{return '';} }     

    private String styleNumber(Double num)
        {
        String result = '';
        if(num == 0.0) {result='text-align:center;';}
        else if (num < 0.0) {result='color:red;';}          
        return result;          
        }

    private String styleNumber(Decimal num)
        {
        String result = '';
        if(num == 0.0) {result='text-align:center;';}
        else if (num < 0.0) {result='color:red;';}          
        return result;          
        }

    private String styleNumber(Integer num)
        {
        String result = '';
        if(num == 0) {result='text-align:center;';}
        else if (num < 0) {result='color:red;'; }       
        return result;          
        }

    public String FYTD_Volume_in_LB_style { get{return styleNumber(FYTD_Volume_in_LB);} }     
    public String FYTD_Volume_in_KG_style { get{return styleNumber(FYTD_Volume_in_KG);} }     
    public String FYTD_Volume_in_UN_style { get{return styleNumber(FYTD_Volume_in_UN);} }     
    public String FYTD_Volume_in_GL_style { get{return styleNumber(FYTD_Volume_in_GL);} }     
    public String FYTD_Volume_in_PT_style { get{return styleNumber(FYTD_Volume_in_PT);} }     
    public String FYTD_Amount_style { get{return styleNumber(FYTD_Amount);} }     
    public String FYTD_GM_style { get{return styleNumber(FYTD_GM);} }     
    public String FYTD_GMpct_style { get{return styleNumber(FYTD_GMpct);} }     

    public String PFYTD_Volume_in_LB_style { get{return styleNumber(PFYTD_Volume_in_LB);} }     
    public String PFYTD_Volume_in_KG_style { get{return styleNumber(PFYTD_Volume_in_KG);} }     
    public String PFYTD_Volume_in_UN_style { get{return styleNumber(PFYTD_Volume_in_UN);} }     
    public String PFYTD_Volume_in_GL_style { get{return styleNumber(PFYTD_Volume_in_GL);} }     
    public String PFYTD_Volume_in_PT_style { get{return styleNumber(PFYTD_Volume_in_PT);} }     
    public String PFYTD_Amount_style { get{return styleNumber(PFYTD_Amount);} }     
    public String PFYTD_GM_style { get{return styleNumber(PFYTD_GM);} }     
    public String PFYTD_GMpct_style { get{return styleNumber(PFYTD_GMpct);} }     

    public String FYTDvsPFYTD_Volume_in_LB_Variance_style { get{return styleNumber(FYTDvsPFYTD_Volume_in_LB_Variance);} }     
    public String FYTDvsPFYTD_Volume_in_KG_Variance_style { get{return styleNumber(FYTDvsPFYTD_Volume_in_KG_Variance);} }     
    public String FYTDvsPFYTD_Volume_in_UN_Variance_style { get{return styleNumber(FYTDvsPFYTD_Volume_in_UN_Variance);} }     
    public String FYTDvsPFYTD_Volume_in_GL_Variance_style { get{return styleNumber(FYTDvsPFYTD_Volume_in_GL_Variance);} }     
    public String FYTDvsPFYTD_Volume_in_PT_Variance_style { get{return styleNumber(FYTDvsPFYTD_Volume_in_PT_Variance);} }     
    public String FYTDvsPFYTD_Amount_Variance_style { get{return styleNumber(FYTDvsPFYTD_Amount_Variance);} }     
    public String FYTDvsPFYTD_GM_Variance_style { get{return styleNumber(FYTDvsPFYTD_GM_Variance);} }     
    public String FYTDvsPFYTD_GMpct_Variance_style { get{return styleNumber(FYTDvsPFYTD_GMpct_Variance);} }
    
    public Date getPFYStartDate() {return PFY_StartDate;}
    public Date getCFYEndDate() {return CFY_EndDate;}
    
    private void init() {
        Integer m = CY_StartDate.month();
        Integer y = CY_StartDate.year();
        if (m < 10) {y -= 1;}
        CFY_StartDate = Date.newInstance(y, 10, 1);
        PFY_StartDate = Date.newInstance(y-1, 10, 1);
        CFY_EndDate = Date.newInstance(y+1, 9, 30);
        PFY_EndDate = Date.newInstance(y, 9, 30);
    }     

    public void addData(String datatoUpdate,
                        Date startDate,
                        Date endDate,
                        Decimal volumeinLB,
                        Decimal volumeinKG,
                        Decimal volumeinUN,
                        Decimal volumeinGL,
                        Decimal volumeinPT,
                        Decimal amount,
                        Decimal gm,
                        Decimal GMpct,
                        String recCurrency) {
        Integer n = CFY_StartDate.year() - startDate.year();
        if (datatoUpdate=='Current Month') {
            CM_StartDate = startDate;
            CM_EndDate = endDate;
            CM_Volume_in_LB = volumeinLB;     
            CM_Volume_in_KG = volumeinKG;     
            CM_Volume_in_UN = volumeinUN;     
            CM_Volume_in_GL = volumeinGL;     
            CM_Volume_in_PT = volumeinPT;     
            CM_Amount = amount;     
            CM_GM = gm;     
            CM_GMpct = GMpct;     
            CM_Currency = recCurrency;     
        } else if (datatoUpdate=='PY Current Month') {
            PYCM_StartDate = startDate;
            PYCM_EndDate = endDate;
            PYCM_Volume_in_LB = volumeinLB;     
            PYCM_Volume_in_KG = volumeinKG;     
            PYCM_Volume_in_UN = volumeinUN;     
            PYCM_Volume_in_GL = volumeinGL;     
            PYCM_Volume_in_PT = volumeinPT;     
            PYCM_Amount = amount;     
            PYCM_GM = gm;     
            PYCM_GMpct = GMpct;     
            PYCM_Currency = recCurrency;     
        } else if (datatoUpdate=='FYTD') {
            if (n > 0) {
                PFYTD_StartDate = startDate;
                PFYTD_EndDate = endDate;
                PFYTD_Volume_in_LB = volumeinLB;     
                PFYTD_Volume_in_KG = volumeinKG;     
                PFYTD_Volume_in_UN = volumeinUN;     
                PFYTD_Volume_in_GL = volumeinGL;     
                PFYTD_Volume_in_PT = volumeinPT;     
                PFYTD_Amount = amount;     
                PFYTD_GM = gm;     
                PFYTD_GMpct = GMpct;     
                PFYTD_Currency = recCurrency;
            } else {
                FYTD_StartDate = startDate;
                FYTD_EndDate = endDate;
                FYTD_Volume_in_LB = volumeinLB;     
                FYTD_Volume_in_KG = volumeinKG;     
                FYTD_Volume_in_UN = volumeinUN;     
                FYTD_Volume_in_GL = volumeinGL;     
                FYTD_Volume_in_PT = volumeinPT;     
                FYTD_Amount = amount;     
                FYTD_GM = gm;     
                FYTD_GMpct = GMpct;     
                FYTD_Currency = recCurrency;
            }     
        } else if (datatoUpdate=='PFYTD') {
            if (n > 1) {
                PFYTD_StartDate = PFY_StartDate;
                PFYTD_EndDate = PFY_EndDate;
            } else {
                PFYTD_StartDate = startDate;
                PFYTD_EndDate = endDate;
                PFYTD_Volume_in_LB = volumeinLB;     
                PFYTD_Volume_in_KG = volumeinKG;     
                PFYTD_Volume_in_UN = volumeinUN;     
                PFYTD_Volume_in_GL = volumeinGL;     
                PFYTD_Volume_in_PT = volumeinPT;     
                PFYTD_Amount = amount;     
                PFYTD_GM = gm;     
                PFYTD_GMpct = GMpct;     
                PFYTD_Currency = recCurrency;
            }     
        }
    }

    private String format_Amount(Decimal valueIn, String curr) {
        String result = '';
        if (valueIn != null)
            {
            result = Math_Functions.formatNumber(valueIn.doubleValue(),0,true,true);
            if (result != '0') {result += ' ' + curr;} else {result = '-';}
            }
        return result;
    }

    private String format_GM(Decimal valueIn, String curr) {
        String result = '';
        if (valueIn != null)
            {
            result = Math_Functions.formatNumber(valueIn.doubleValue(),0,true,true);
            if (result != '0') {result += ' ' + curr;} else {result = '-';}
            }
        return result;

    }

    private String format_GMpct(Decimal valueIn) {
        String result = '';
        if (valueIn != null)
            {
            result = Math_Functions.formatNumber(valueIn.doubleValue(),2,true,true);
            if (result != '0.00') {result += ' %';} else {result = '-';}
            }
        return result;
        
    }

    private String format_GMpct_Variance(Decimal valueIn) {
        String result = '';
        if (valueIn != null)
            {
            result = Math_Functions.formatNumber(valueIn.doubleValue(),2,true,true);
            if (result != '0.00') {result += ' %';} else {result = '-';}
            }
        return result;
        
    }

    private String format_Volume(Double valueIn, String uom) {
        String result = '';
        if (valueIn != null)
            {
            result = Math_Functions.formatNumber(valueIn,0,true,true);
            if (result != '0') {result += ' ' + uom;} else {result = '-';}
            }
        return result;
        
    }
        
}