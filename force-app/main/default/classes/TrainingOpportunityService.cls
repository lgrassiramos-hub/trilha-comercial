public with sharing class TrainingOpportunityService {

    public class OpportunityData {
        public String nome;
        public String produto;
        public Decimal valorEstimado;
        public Integer quantidade;
        public Date dataFechamento;
        public String observacao;
    }

    public static Id criar(Id accountId, OpportunityData d) {
        validar(d);

        Opportunity opp = new Opportunity(
            AccountId = accountId,
            Name = d.nome,
            Amount = d.valorEstimado,
            Quantidade__c = d.quantidade,
            Produto__c = d.produto,
            CloseDate = d.dataFechamento,
            StageName = 'Prospecting',
            Description = d.observacao
        );
        insert opp;
        return opp.Id;
    }

    private static void validar(OpportunityData d) {
        if (d == null || String.isBlank(d.nome) || String.isBlank(d.produto)
            || d.valorEstimado == null || d.quantidade == null || d.dataFechamento == null) {
            throw userError('Preencha todos os campos obrigatórios.');
        }
        if (d.valorEstimado <= 0) {
            throw userError('O valor estimado deve ser maior que zero.');
        }
        if (d.quantidade <= 0) {
            throw userError('A quantidade deve ser maior que zero.');
        }
        if (d.dataFechamento < Date.today()) {
            throw userError('A data de fechamento não pode ser anterior à data atual.');
        }
    }

    private static AuraHandledException userError(String message) {
        AuraHandledException ex = new AuraHandledException(message);
        ex.setMessage(message);
        return ex;
    }
}