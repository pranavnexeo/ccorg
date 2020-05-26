trigger reassignSellers_SAP_Territory on Opportunity (before insert) {
     Opportunity_Territory_Functions.reAssign_Sellers(trigger.new);
}