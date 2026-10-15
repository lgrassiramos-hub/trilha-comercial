@IsTest
private class TrainingOpportunityServiceTest {

    private static Id criarAccount() {
        Account conta = new Account(Name = 'Conta Teste Opp');
        insert conta;
        return conta.Id;
    }

    private static TrainingOpportunityService.OpportunityData dadosValidos() {
        TrainingOpportunityService.OpportunityData d = new TrainingOpportunityService.OpportunityData();
        d.nome = 'Oportunidade Teste';
        d.produto = 'Produto A';
        d.valorEstimado = 1000;
        d.quantidade = 2;
        d.dataFechamento = Date.today().addDays(30);
        d.observacao = 'Observação';
        return d;
    }

    @IsTest
    static void criaOpportunityVinculadaAAccount() {
        Id accountId = criarAccount();

        Test.startTest();
        Id oppId = TrainingOpportunityService.criar(accountId, dadosValidos());
        Test.stopTest();

        Opportunity opp = [SELECT AccountId, Amount, Quantidade__c, Produto__c FROM Opportunity WHERE Id = :oppId];
        System.assertEquals(accountId, opp.AccountId);
        System.assertEquals(1000, opp.Amount);
        System.assertEquals(2, opp.Quantidade__c);
        System.assertEquals('Produto A', opp.Produto__c);
    }

    @IsTest
    static void bloqueiaValorZero() {
        Id accountId = criarAccount();
        TrainingOpportunityService.OpportunityData d = dadosValidos();
        d.valorEstimado = 0;
        try {
            TrainingOpportunityService.criar(accountId, d);
            System.assert(false, 'Deveria bloquear valor zero');
        } catch (AuraHandledException e) {
            System.assertEquals('O valor estimado deve ser maior que zero.', e.getMessage());
        }
    }

    @IsTest
    static void bloqueiaQuantidadeZero() {
        Id accountId = criarAccount();
        TrainingOpportunityService.OpportunityData d = dadosValidos();
        d.quantidade = 0;
        try {
            TrainingOpportunityService.criar(accountId, d);
            System.assert(false, 'Deveria bloquear quantidade zero');
        } catch (AuraHandledException e) {
            System.assertEquals('A quantidade deve ser maior que zero.', e.getMessage());
        }
    }

    @IsTest
    static void bloqueiaDataNoPassado() {
        Id accountId = criarAccount();
        TrainingOpportunityService.OpportunityData d = dadosValidos();
        d.dataFechamento = Date.today().addDays(-1);
        try {
            TrainingOpportunityService.criar(accountId, d);
            System.assert(false, 'Deveria bloquear data passada');
        } catch (AuraHandledException e) {
            System.assertEquals('A data de fechamento não pode ser anterior à data atual.', e.getMessage());
        }
    }
}