public with sharing class TrainingLeadController {

    @AuraEnabled
    public static ViaCepDTO buscarEndereco(String cep) {
        return ViaCepService.consultarCep(cep);
    }

    @AuraEnabled
    public static Id criarLead(String dataJson) {
        TrainingLeadService.LeadData data =
            (TrainingLeadService.LeadData) JSON.deserialize(dataJson, TrainingLeadService.LeadData.class);
        return TrainingLeadService.createLead(data);
    }
}