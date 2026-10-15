public with sharing class TrainingLeadTriggerHandler {

    public static void handle(List<Lead> novos, Map<Id, Lead> antigos, Boolean isInsert) {
        List<Lead> elegiveis = new List<Lead>();

        for (Lead lead : novos) {
            // Leads já convertidos não são recalculados
            if (lead.IsConverted) {
                continue;
            }
            // Em update, só recalcula se algum campo que compõe o score mudou
            if (!isInsert && !mudouCampoDeScore(lead, antigos.get(lead.Id))) {
                continue;
            }
            elegiveis.add(lead);
        }

        TrainingLeadHelper.aplicarQualificacao(elegiveis);
    }

    private static Boolean mudouCampoDeScore(Lead novo, Lead antigo) {
        return novo.Documento__c != antigo.Documento__c
            || novo.EnderecoValidado__c != antigo.EnderecoValidado__c
            || novo.Email != antigo.Email
            || novo.Phone != antigo.Phone;
    }
}