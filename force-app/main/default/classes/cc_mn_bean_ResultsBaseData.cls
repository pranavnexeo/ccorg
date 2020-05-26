global class cc_mn_bean_ResultsBaseData {
        public String sfid { get; set; }
        public String sku { get; set; }
        public String name { get; set; }
        public Decimal price { get; set; }
        public String startDate { get; set; }
        public Integer ranking { get; set; }
        public Integer sequence { get; set; }
    	public String currencyCode { get; set; }
    	public String priceCurrency { get; set; }

        public cc_mn_bean_ResultsBaseData (String sfid, String sku, String name, String createdDate, Integer sequence, Decimal price, String currencyCode, String priceCurrency) {
            this.sfid = sfid;
            this.sku = sku;
            this.name = name;
            this.startDate = createdDate;
            this.sequence = sequence;
            this.price = price;
            this.currencyCode=currencyCode;
            this.priceCurrency=priceCurrency;
        }
}