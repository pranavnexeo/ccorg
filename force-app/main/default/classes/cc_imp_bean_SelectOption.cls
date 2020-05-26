public with sharing class cc_imp_bean_SelectOption 
{
		public String value 	{get; set;}
		public String label 	{get; set;}

		public cc_imp_bean_SelectOption(SelectOption selectOption) 
		{
			if (selectOption != null)
			 {
				this.value = selectOption.getValue();
				this.label = selectOption.getLabel();
			}
		}
}