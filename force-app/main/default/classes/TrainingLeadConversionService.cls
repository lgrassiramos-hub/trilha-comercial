public with sharing class TrainingLeadConversionService {

    public static Id converter(Id leadId) {
        Lead lead = [
            SELECT Id, IsConverted, Status, Score__c, AptoConversao__c, EnderecoValidado__c,
                   Documento__c, TipoDocumento__c, Bairro__c, NumeroEndereco__c, Complemento__c
            FROM Lead WHERE Id = :leadId
        ];

        validarElegibilidade(lead);

        Database.LeadConvertResult resultado = Database.convertLead(montarConversao(lead));
        if (!resultado.isSuccess()) {
            throw userError('Não foi possível converter o Lead. Tente novamente.');
        }

        Id accountId = resultado.getAccountId();
        Account conta = [
            SELECT Id, Documento__c, TipoDocumento__c, Bairro__c, NumeroEndereco__c, Complemento__c
            FROM Account WHERE Id = :accountId
        ];
        conta.Documento__c = lead.Documento__c;
        conta.TipoDocumento__c = lead.TipoDocumento__c;
        conta.Bairro__c = lead.Bairro__c;
        conta.NumeroEndereco__c = lead.NumeroEndereco__c;
        conta.Complemento__c = lead.Complemento__c;
        update conta;

        return accountId;
    }

    private static void validarElegibilidade(Lead lead) {
        if (lead.IsConverted
            || lead.Score__c != 100
            || lead.AptoConversao__c != true
            || lead.EnderecoValidado__c != true
            || lead.Status != 'Qualificado') {
            throw userError('Este Lead ainda não está apto para conversão.');
        }
    }

    private static Database.LeadConvert montarConversao(Lead lead) {
        Database.LeadConvert conversao = new Database.LeadConvert();
        conversao.setLeadId(lead.Id);
        conversao.setConvertedStatus(
            [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1].MasterLabel
        );
        conversao.setDoNotCreateOpportunity(true);
        return conversao;
    }

    private static AuraHandledException userError(String message) {
        AuraHandledException ex = new AuraHandledException(message);
        ex.setMessage(message);
        return ex;
    }
}