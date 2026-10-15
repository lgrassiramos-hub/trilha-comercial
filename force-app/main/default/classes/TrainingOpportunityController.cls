public with sharing class TrainingOpportunityController {

    @AuraEnabled
    public static Id criarOportunidade(Id accountId, String dataJson) {
        TrainingOpportunityService.OpportunityData d =
            (TrainingOpportunityService.OpportunityData) JSON.deserialize(
                dataJson, TrainingOpportunityService.OpportunityData.class);
        return TrainingOpportunityService.criar(accountId, d);
    }
}