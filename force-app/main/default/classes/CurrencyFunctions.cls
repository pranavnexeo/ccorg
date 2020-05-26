public with sharing class CurrencyFunctions {

    public static final String COMMA = ',';
    public static final String DOT = '.';
    public static final String QUOTE = '\'';
    public static final String SPACE = ' ';
    
    // Locale => ThousandSeparator, DecimalSeparator
    public static final Map<String, String[]> localeMap = new Map<String, String[]>{
		'ar'          => new String[]{COMMA,   DOT},
		'ar_AE'       => new String[]{COMMA,   DOT},
		'ar_BH'       => new String[]{COMMA,   DOT},
		'ar_JO'       => new String[]{COMMA,   DOT},
		'ar_KW'       => new String[]{COMMA,   DOT},
		'ar_LB'       => new String[]{COMMA,   DOT},
		'ar_SA'       => new String[]{COMMA,   DOT},
		'bg'          => new String[]{SPACE, COMMA},
		'bg_BG'       => new String[]{SPACE, COMMA},
		'ca'          => new String[]{DOT,   COMMA},
		'ca_ES'       => new String[]{DOT,   COMMA},
		'ca_ES_EURO'  => new String[]{DOT,   COMMA},
		'cs'          => new String[]{SPACE, COMMA},
		'cs_CZ'       => new String[]{SPACE, COMMA},
		'da'          => new String[]{DOT,   COMMA},
		'da_DK'       => new String[]{DOT,   COMMA},
		'de'          => new String[]{DOT,   COMMA},
		'de_AT'       => new String[]{DOT,   COMMA},
		'de_AT_EURO'  => new String[]{DOT,   COMMA},
		'de_CH'       => new String[]{QUOTE,   DOT},
		'de_DE'       => new String[]{DOT,   COMMA},
		'de_DE_EURO'  => new String[]{DOT,   COMMA},
		'de_LU'       => new String[]{DOT,   COMMA},
		'de_LU_EURO'  => new String[]{DOT,   COMMA},
		'el'          => new String[]{DOT,   COMMA},
		'el_GR'       => new String[]{DOT,   COMMA},
		'en_AU'       => new String[]{COMMA,   DOT},
		'en_BB'       => new String[]{COMMA,   DOT},
		'en_BM'       => new String[]{COMMA,   DOT},
		'en_CA'       => new String[]{COMMA,   DOT},
		'en_GB'       => new String[]{COMMA,   DOT},
		'en_GH'       => new String[]{COMMA,   DOT},
		'en_ID'       => new String[]{COMMA,   DOT},
		'en_IE'       => new String[]{COMMA,   DOT},
		'en_IE_EURO'  => new String[]{COMMA,   DOT},
		'en_NZ'       => new String[]{COMMA,   DOT},
		'en_SG'       => new String[]{COMMA,   DOT},
		'en_US'       => new String[]{COMMA,   DOT},
		'en_ZA'       => new String[]{COMMA,   DOT},
		'es'          => new String[]{DOT,   COMMA},
		'es_AR'       => new String[]{DOT,   COMMA},
		'es_BO'       => new String[]{DOT,   COMMA},
		'es_CL'       => new String[]{DOT,   COMMA},
		'es_CO'       => new String[]{DOT,   COMMA},
		'es_CR'       => new String[]{COMMA,   DOT},
		'es_EC'       => new String[]{DOT,   COMMA},
		'es_ES'       => new String[]{DOT,   COMMA},
		'es_ES_EURO'  => new String[]{DOT,   COMMA},
		'es_GT'       => new String[]{COMMA,   DOT},
		'es_HN'       => new String[]{COMMA,   DOT},
		'es_MX'       => new String[]{COMMA,   DOT},
		'es_PE'       => new String[]{DOT,   COMMA},
		'es_PR'       => new String[]{COMMA,   DOT},
		'es_PY'       => new String[]{DOT,   COMMA},
		'es_SV'       => new String[]{COMMA,   DOT},
		'es_UY'       => new String[]{DOT,   COMMA},
		'es_VE'       => new String[]{DOT,   COMMA},
		'et_EE'       => new String[]{SPACE, COMMA},
		'fi'          => new String[]{SPACE, COMMA},
		'fi_FI'       => new String[]{SPACE, COMMA},
		'fi_FI_EURO'  => new String[]{SPACE, COMMA},
		'fr'          => new String[]{SPACE, COMMA},
		'fr_BE'       => new String[]{DOT,   COMMA},
		'fr_CA'       => new String[]{SPACE, COMMA},
		'fr_CH'       => new String[]{QUOTE,   DOT},
		'fr_FR'       => new String[]{SPACE, COMMA},
		'fr_FR_EURO'  => new String[]{SPACE, COMMA},
		'fr_LU'       => new String[]{SPACE, COMMA},
		'fr_MC'       => new String[]{SPACE, COMMA},
		'hr_HR'       => new String[]{DOT,   COMMA},
		'hu'          => new String[]{SPACE, COMMA},
		'hy_AM'       => new String[]{COMMA,   DOT},
		'in'          => new String[]{DOT,   COMMA},
		'is_IS'       => new String[]{DOT,   COMMA},
		'it'          => new String[]{DOT,   COMMA},
		'it_CH'       => new String[]{QUOTE,   DOT},
		'it_IT'       => new String[]{DOT,   COMMA},
		'iw'          => new String[]{COMMA,   DOT},
		'iw_IL'       => new String[]{COMMA,   DOT},
		'ja'          => new String[]{COMMA,   DOT},
		'ja_JP'       => new String[]{COMMA,   DOT},
		'kk_KZ'       => new String[]{COMMA,   DOT},
		'km_KH'       => new String[]{COMMA,   DOT},
		'ko'          => new String[]{COMMA,   DOT},
		'ko_KR'       => new String[]{COMMA,   DOT},
		'lt_LT'       => new String[]{SPACE, COMMA},
		'lv_LV'       => new String[]{SPACE, COMMA},
		'ms_MY'       => new String[]{COMMA,   DOT},
		'nl'          => new String[]{DOT,   COMMA},
		'nl_BE'       => new String[]{DOT,   COMMA},
		'nl_NL'       => new String[]{DOT,   COMMA},
		'nl_SR'       => new String[]{DOT,   COMMA},
		'no'          => new String[]{SPACE, COMMA},
		'no_NO'       => new String[]{SPACE, COMMA},
		'pl'          => new String[]{SPACE, COMMA},
		'pt'          => new String[]{DOT,   COMMA},
		'pt_AO'       => new String[]{DOT,   COMMA},
		'pt_BR'       => new String[]{DOT,   COMMA},
		'pt_PT'       => new String[]{DOT,   COMMA},
		'ro'          => new String[]{DOT,   COMMA},
		'ro_RO'       => new String[]{DOT,   COMMA},
		'ru'          => new String[]{SPACE, COMMA},
		'ru_RU'       => new String[]{SPACE, COMMA},
		'sk_SK'       => new String[]{SPACE, COMMA},
		'sl_SI'       => new String[]{DOT,   COMMA},
		'sv'          => new String[]{SPACE, COMMA},
		'sv_SE'       => new String[]{SPACE, COMMA},
		'th'          => new String[]{COMMA,   DOT},
		'th_TH'       => new String[]{COMMA,   DOT},
		'tr'          => new String[]{DOT,   COMMA},
		'uk'          => new String[]{DOT,   COMMA},
		'uk_UA'       => new String[]{DOT,   COMMA},
		'ur_PK'       => new String[]{COMMA,   DOT},
		'vi'          => new String[]{DOT,   COMMA},
		'vi_VN'       => new String[]{DOT,   COMMA},
		'zh'          => new String[]{COMMA,   DOT},
		'zh_CN'       => new String[]{COMMA,   DOT},
		'zh_HK'       => new String[]{COMMA,   DOT},
		'zh_TW'       => new String[]{COMMA,   DOT}
    };
    
    public static String getFormattedDecimal(Decimal d) {
    	String locale = 'en_US';
	    return getFormattedDecimal(locale, d);
    }
       
    public static String getFormattedDecimal(String locale, Decimal d) {
		String s = d.toPlainString();
		String s1, s2;
		Integer i = s.indexOf(DOT);
		if (i < 0) {
		    s1 = s;
		} else {
		    s1 = s.substring(0,i);
		    s2 = s.substring(i+1);
		}
        String ts = COMMA; // Thousands Separator
        String ds = DOT;   // Decimals Separator
        if (localeMap.containsKey(locale)) {
            String[] sa = localeMap.get(locale);
            ts = sa[0];
            ds = sa[1];
        }
		Integer n = s1.length();
		String[] sa = new String[n];
		Integer p = 0;
		String t = '';
		for (Integer m = n; m > 0; m--) {
		    if (p == 3) {
		        t = ts + t;
		        p = 0;
		    }
		    sa[n-m] = s1.substring(m-1,m);
		    t = sa[n-m] + t;
		    p++;
		}
		if (s2 != null) {
		    t = t + ds + s2;
		}
		return t;
    }
    
    static testMethod void test01() {
    	Decimal d = 1234567890.1234;
    	String locale = 'nl_BE';
    	String t = getFormattedDecimal(d);
    	System.debug(t);
    	t = getFormattedDecimal(locale, d);
        System.debug(t);
    }
}