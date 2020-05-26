global with sharing class Account_Hierarchy_Functions {

    public static final String DELIM = CISRelationships_Functions.DELIM;
    public static final String ACC_TYPE_SHIPTO = CISRelationships_Functions.SHIPTO;
    public static final String ACC_TYPE_SOLDTO = CISRelationships_Functions.SOLDTO;
    public static final String ACC_TYPE_CHERKY = CISRelationships_Functions.CHERKY;
    public static final String XML_ROOT_ELEMNT = 'AccountHierarchy';
    public static final String XML_ROOT_BEGIN = '<'+XML_ROOT_ELEMNT+'>';
    public static final String XML_ROOT_END = '</'+XML_ROOT_ELEMNT+'>';
    public static final Integer MAX_SIZE = 200;

    global class ReturnClass {
    
        webservice CHerkyAccount accountHierarchy;
        webservice String accountHierarchyXml;
        webservice String returnMessage = '';
    }

    public static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Account_Hierarchy_Functions : ' + s);
    }
    
    public static Boolean notNull(String s) {
        return (s != null && s.trim().length() > 0);
    }
    
    global class AccountClass {
        webservice String sourceAccId;
        webservice Boolean isSourceAcc;
        webservice Boolean isViewngAcc;
        webservice String accountId;
        webservice String accountName;
        webservice String accountNumber;
        webservice String accountType;
        public AccountClass(String srcAccId, String accId){
            sourceAccId = srcAccId; accountId = accId; 
            isSourceAcc = (accId != null && accId.equals(srcAccId));
            isViewngAcc = isSourceAcc;
        }
    }
    
    global class CHerkyAccount {
        webservice AccountClass acc;
        webservice List<SoldToAccount> soldToAccounts;
        public String xmlString;
        public CHerkyAccount() {this(null, null);}
        public CHerkyAccount(String srcAccId, String accountId) {init(srcAccId, accountId);}
        public void init(String srcAccId, String accountId) {
            acc = new AccountClass(srcAccId, accountId);
            soldToAccounts = new List<SoldToAccount>();
            //debug('CHerkyAccount : '+acc);
        }
    }
    
    global class SoldToAccount {
        webservice AccountClass acc;
        webservice List<ShipToAccount> shipToAccounts;
        public SoldToAccount() {this(null, null);}
        public SoldToAccount(String srcAccId, String accountId) {init(srcAccId, accountId);}
        private void init(String srcAccId, String accountId) {
            acc = new AccountClass(srcAccId, accountId);
            shipToAccounts = new List<ShipToAccount>();
            //debug('SoldToAccount : '+acc);
        }
    }
    
    global class ShipToAccount {
        webservice AccountClass acc;
        public ShipToAccount() {this(null, null);}
        public ShipToAccount(String srcAccId, String accountId) {init(srcAccId, accountId);}
        public void init(String srcAccId, String accountId) {
            acc = new AccountClass(srcAccId, accountId);
            //debug('ShipToAccount : '+acc);
        }
    }

    public static String getAccountHierarchyXml(String accountId) {
        Id tempId = accountId; accountId = tempId;
        String xml = XML_ROOT_BEGIN + XML_ROOT_END;
        List<String> alist = new List<String>();
        Account a = [select Id, ParentId from Account where Id = :accountId];
        if (a == null) {return xml;}
        Set<Id> accountIds = new Set<Id>();
        if (a.ParentId != null) {accountIds.add(a.ParentId);} else {accountIds.add(accountId);}
        Map<Id, Map<String, List<Id>>> pmap;
        pmap = CISRelationships_Functions.getPartnerIds(accountIds);
        if (pmap == null || pmap.isEmpty()) {return xml;}
        Map<Id, Account> amap = CISRelationships_Functions.getAccountsMap(pmap);
        Set<String> aset = new Set<String>();
        for (Map<String, List<Id>> tmap : pmap.values()) {
            aset.addAll(getAccountSet(tmap, amap));
            if (aset.size() > MAX_SIZE) {break;}
        }
        alist = getAccountList(accountId, aset);
        List<CHerkyAccount> chs = getCHerkyAccounts(accountId, alist);
        if (chs != null && !chs.isEmpty()) {
            xml = XML_ROOT_BEGIN;
            for (CHerkyAccount cha : chs) {
                setAccountsInfo(cha, amap);
                xml += cha.xmlString;
            }
            xml += XML_ROOT_END;
        }
        return xml;
    }
    
 @TestVisible   private static List<String> getAccountList(String accountId, Set<String> aset) {
        List<String> alist = new List<String>(); 
        List<String> sa;
        for (String s : aset) {
            sa = s.split(DELIM); 
            if (sa.isEmpty()) {
                continue;
            }
            String ch, so, sh, k1 = '2', k2 = '2', k3 = '2';
            if (sa.size() > 5 && notNull(sa[5])) {
                sh = sa[5]; so = sa[3]; ch = sa[1];
                if (sh != null && sh == accountId) {k3 = '1'; k2 = '1'; k1 = '1';} 
                if (so != null && so == accountId) {k2 = '1'; k1 = '1';}
                if (ch != null && ch == accountId) {k1 = '1';}
                alist.add(k1 + DELIM + sa[0] + DELIM + sa[1] + DELIM +
                          k2 + DELIM + sa[2] + DELIM + sa[3] + DELIM +
                          k3 + DELIM + sa[4] + DELIM + sa[5]);
            } else
            if (sa.size() > 3 && notNull(sa[3])) {
                so = sa[3]; ch = sa[1];
                if (so != null && so == accountId) {k2 = '1'; k1 = '1';}
                if (ch != null && ch == accountId) {k1 = '1';}
                alist.add(k1 + DELIM + sa[0] + DELIM + sa[1] + DELIM +
                          k2 + DELIM + sa[2] + DELIM + sa[3]);
            } else 
            if (sa.size() > 1 && notNull(sa[1])) {
                ch = sa[1];
                if (ch != null && ch == accountId) {k1 = '1';}
                alist.add(k1 + DELIM + sa[0] + DELIM + sa[1]);
            } 
        }
        alist.sort();
        for (String s : alist) {debug('getAccountList : ' + s);}
        return alist;
    }
    
 @TestVisible private static Set<String> getAccountSet(Map<String, List<Id>> tmap, Map<Id, Account> amap) {
        Set<String> aset = new Set<String>();
        String s, t, ch; 
        List<Id> sos, shs; 
        Account soa;    
        if (tmap.containsKey(ACC_TYPE_SOLDTO)) {
            sos = tmap.get(ACC_TYPE_SOLDTO);
        }
        if (tmap.containsKey(ACC_TYPE_SHIPTO)) {
            shs = tmap.get(ACC_TYPE_SHIPTO);
        }
        if (sos != null && !sos.isEmpty()) {
            for (String so : sos) {
                ch = DELIM;
                if (amap.containsKey(so)) {
                    soa = amap.get(so);
                    if (soa.ParentId != null) {
                        ch = getAccountKeyId(soa.ParentId, amap);
                    } 
                }
                s = ch + DELIM + getAccountKeyId(so, amap);
                if (shs == null || shs.isEmpty()) {aset.add(s); return aset;}
                for (String sh : shs) {
                    t = s + DELIM + getAccountKeyId(sh, amap);
                    debug('getAccountSet : ' + t);
                    aset.add(t); if (aset.size() > MAX_SIZE) {break;}
                }
            }
        } else {
            s = DELIM + DELIM + DELIM;
            if (shs == null || shs.isEmpty()) {aset.add(s); return aset;}
            for (String sh : shs) {
                t = s + DELIM + getAccountKeyId(sh, amap);
                debug('getAccountSet : ' + t);
                aset.add(t); if (aset.size() > MAX_SIZE) {break;}
            }
        }
        return aset;
    }
    
   @TestVisible private static String getAccountKeyId(Id accountId, Map<Id, Account> amap) {
        String s = DELIM;
        if (amap.containsKey(accountId)) {
            Account a = amap.get(accountId); 
            s = a.AccountNumber + DELIM + accountId;
        }
        //debug('getAccountKeyId : ' + s);
        return s;
    }
    
   @TestVisible private static List<CHerkyAccount> getCHerkyAccounts(String accountId, List<String> plist) {
        Id tempId = accountId; accountId = tempId;
        List<String> sa; 
        String och = '', oso = '', osh = '';
        CHerkyAccount cha; 
        SoldToAccount soa; 
        ShipToAccount sha;
        List<CHerkyAccount> chs = new List<CHerkyAccount>();
        for (String s : plist) {
            sa = s.split(DELIM); if (sa.isEmpty()) {continue;}
            String ch, so, sh;
          
            if (sa.size() > 2 && notNull(sa[2]))
            {
                ch = sa[2];
            } 
            if (sa.size() > 5 && notNull(sa[5])) {
                so = sa[5];
            } 
            if (sa.size() > 8 && notNull(sa[8])) {
                sh = sa[8];
            }
            if (ch != null && !ch.equals(och)) {
                och = ch; oso = '';
                cha = new CHerkyAccount(accountId, ch);
                chs.add(cha);
            } 
            if (so != null && !so.equals(oso)) {
                oso = so; osh = '';
                soa = new SoldToAccount(accountId, so);
                if (cha == null) {cha = new CHerkyAccount(); chs.add(cha);}
                if(soa.acc.isSourceAcc) {cha.acc.isSourceAcc = false;}
                cha.soldToAccounts.add(soa);
            } 
            if (sh != null && !sh.equals(osh)) {
                osh = sh;
                sha = new ShipToAccount(accountId, sh);
                if (soa == null) {
                    soa = new SoldToAccount();
                    if (cha == null) {cha = new CHerkyAccount(); chs.add(cha);}
                    cha.soldToAccounts.add(soa);
                }
                if(sha.acc.isSourceAcc) {soa.acc.isSourceAcc = false;}
                soa.shipToAccounts.add(sha);
            } 
        }
        return chs;
    }

   @TestVisible private static void setAccountsInfo(CHerkyAccount cha, 
                                        Map<Id, Account> amap) {
        if (amap == null || amap.isEmpty()) {return;}
        XmlStreamWriter xsw = new XmlStreamWriter();
        if (cha.acc.accountId != null) {
            
            writeStartElement(xsw, 'CorpAcct');
            setAccountInfo(ACC_TYPE_CHERKY, cha.acc, amap, xsw);
        }
        for (SoldToAccount soa : cha.soldToAccounts) {
            if (soa.acc.accountId != null) {
                writeStartElement(xsw, 'SoldTo');
                setAccountInfo(ACC_TYPE_SOLDTO, soa.acc, amap, xsw);
            }
            for (ShipToAccount sha : soa.shipToAccounts) {
                if (sha.acc.accountId != null) {
                    writeStartElement(xsw, 'ShipTo');
                    setAccountInfo(ACC_TYPE_SHIPTO, sha.acc, amap, xsw);
                    xsw.writeEndElement();
                }
            }
            if (soa.acc.accountId != null) {xsw.writeEndElement();}
        }
        if (cha.acc.accountId != null) {xsw.writeEndElement();}
        cha.xmlString = xsw.getXmlString();
        xsw.close();
    }
    
  @TestVisible private static void setAccountInfo(String accountType, 
                                       AccountClass ac, 
                                       Map<Id, Account> amap,
                                       XmlStreamWriter xsw) {
        Boolean isInactive = false; 
        String accountNumber = '', billingStreet = '';
        debug('setAccountInfo : ' + ac);
        if (ac != null && amap.containsKey(ac.accountId)) {
            Account a = amap.get(ac.accountId);
            ac.accountName = a.Name;
            ac.accountNumber = a.AccountNumber;
            ac.accountType = accountType;
            isInactive = 'No'.equals(a.Active_Account__c) ||
                         a.Inactive_Account__c;
            //debug(''+ac);
            accountNumber = String_Functions.removeLeadingZeros(a.AccountNumber);
            if (a.BillingStreet != null) {
                billingStreet = a.BillingStreet.replaceAll('\n', ', ');
            }
            writeAttribute(xsw, 'SourceAccountId', ac.SourceAccId);
            writeAttribute(xsw, 'isInactive', getString(isInactive));
            writeAttribute(xsw, 'isSourceAcc', getString(ac.isSourceAcc));
            writeAttribute(xsw, 'isViewngAcc', getString(ac.isViewngAcc));
            writeAttribute(xsw, 'AccountId', a.Id);
            writeAttribute(xsw, 'AccountName', a.Name);
            writeAttribute(xsw, 'AccountName2', getString(a.SAP_Account_Name_2__c));
            writeAttribute(xsw, 'AccountNumber', accountNumber);
            writeAttribute(xsw, 'AccountType', accountType);
            writeAttribute(xsw, 'BillingCity', getString(a.BillingCity));
            writeAttribute(xsw, 'BillingCountry', getString(a.BillingCountry));
            writeAttribute(xsw, 'BillingPostalCode', getString(a.BillingPostalCode));
            writeAttribute(xsw, 'BillingState', getString(a.BillingState));
            writeAttribute(xsw, 'BillingStreet', billingStreet);
            writeAttribute(xsw, 'CustGroup1', getString(a.SAP_Customer_Group_1_Desc__c));
            writeAttribute(xsw, 'CustGroup', getString(a.SAP_Customer_Group_Desc__c));
            writeAttribute(xsw, 'DistChanCode', getString(a.SAP_DistChannel__c));
            writeAttribute(xsw, 'DistChanDesc', getString(a.SAP_Dist_Channel_Desc__c));
            writeAttribute(xsw, 'DivisionCode', getString(a.SAP_DivisionCode__c));
            writeAttribute(xsw, 'DivisionDesc', getString(a.SAP_Division_Desc__c));
            writeAttribute(xsw, 'OwnerName', getString(a.Owner.Name));
            writeAttribute(xsw, 'SalesDstDesc', getString(a.SAP_Sales_District_Desc__c));
            writeAttribute(xsw, 'SalesGrpDesc', getString(a.SAP_Sales_Group_Desc__c));
            writeAttribute(xsw, 'SalesOfcDesc', getString(a.SAP_Sales_Office_Desc__c));
            writeAttribute(xsw, 'SalesorgCode', getString(a.SAP_Sales_Org__c));
            writeAttribute(xsw, 'SalesorgDesc', getString(a.SAP_Sales_Org_Desc__c));
        }
    }
    
   @TestVisible private static String getString(Object o) {
        String s = ''; if (o != null) {s = '' + o;} return s;
    }
    
   @TestVisible private static Boolean isNotNull(String s) {
        return (s != null && s.trim().length() > 0);
    }
    
   @TestVisible private static void writeAttribute(XmlStreamWriter xsw, String n, String v) {
        xsw.writeAttribute(null, null, n, v);
    }
    
   @TestVisible private static void writeElement(XmlStreamWriter xsw, String e, String c) {
        writeStartElement(xsw, e);
        if (isNotNull(c)) {xsw.writeCharacters(c.trim());}
        xsw.writeEndElement();
    }
    
   @TestVisible private static void writeStartElement(XmlStreamWriter xsw, String s) {
        xsw.writeStartElement(null, s, null);
    }
    
   @TestVisible private static void writeEmptyElement(XmlStreamWriter xsw, String s) {
        xsw.writeEmptyElement(null, s, null);
    }
    
    webservice static ReturnClass getAccountHierarchy(String accountId) {
        ReturnClass rc = new ReturnClass();
        rc.accountHierarchyXml = getAccountHierarchyXml(accountId);
        return rc;
    }

}