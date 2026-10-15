public with sharing class TrainingLeadHelper {

    public static final Integer PONTOS_DOCUMENTO = 40;
    public static final Integer PONTOS_ENDERECO = 30;
    public static final Integer PONTOS_EMAIL = 15;
    public static final Integer PONTOS_TELEFONE = 15;
    public static final Integer SCORE_MINIMO = 100;

    // Calcula o score do Lead a partir dos dados já preenchidos
    public static Integer calcularScore(Lead lead) {
        Integer score = 0;

        if (lead.Documento__c != null && lead.Documento__c.length() > 0
            && (DocumentValidator.isValidCpf(lead.Documento__c)
                || DocumentValidator.isValidCnpj(lead.Documento__c))) {
            score += PONTOS_DOCUMENTO;
        }
        if (lead.EnderecoValidado__c == true) {
            score += PONTOS_ENDERECO;
        }
        if (String.isNotBlank(lead.Email)) {
            score += PONTOS_EMAIL;
        }
        if (String.isNotBlank(lead.Phone)) {
            score += PONTOS_TELEFONE;
        }
        return score;
    }

    // Preenche Score__c, AptoConversao__c e Status conforme a regra
    public static void aplicarQualificacao(List<Lead> leads) {
        for (Lead lead : leads) {
            Integer score = calcularScore(lead);
            lead.Score__c = score;
            lead.AptoConversao__c = score == SCORE_MINIMO;
            if (lead.AptoConversao__c) {
                lead.Status = 'Qualificado';
            }
        }
    }
}