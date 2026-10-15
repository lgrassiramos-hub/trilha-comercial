@IsTest
private class TrainingOrderServiceTest {

    private static TrainingOpportunityService.OpportunityData dadosValidos() {
        TrainingOpportunityService.OpportunityData d = new TrainingOpportunityService.OpportunityData();
        d.nome = 'Opp com Pedido';
        d.produto = 'Produto A';
        d.valorEstimado = 500;
        d.quantidade = 1;
        d.dataFechamento = Date.today().addDays(15);
        d.observacao = '';
        return d;
    }

    @IsTest
    static void criaOpportunityEOrderRelacionados() {
        Account conta = new Account(Name = 'Conta Pedido');
        insert conta;

        Test.startTest();
        Id oppId = TrainingOrderService.criarOpportunityComPedido(conta.Id, dadosValidos());
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM Order WHERE OpportunityId = :oppId]);
        Order pedido = [SELECT AccountId, Status FROM Order WHERE OpportunityId = :oppId];
        System.assertEquals(conta.Id, pedido.AccountId);
        System.assertEquals('Draft', pedido.Status);
    }

    @IsTest
    static void falhaNoOrderRevertOpportunity() {
        Integer oppsAntes = [SELECT COUNT() FROM Opportunity];

        Test.startTest();
        try {
            // Account inexistente faz o insert do Order falhar
            TrainingOrderService.criarOpportunityComPedido(
                '001000000000000AAA', dadosValidos()
            );
            System.assert(false, 'Deveria ter falhado');
        } catch (AuraHandledException e) {
            System.assertEquals(
                'Não foi possível concluir a operação. Tente novamente.', e.getMessage()
            );
        }
        Test.stopTest();

        System.assertEquals(oppsAntes, [SELECT COUNT() FROM Opportunity]);
    }
}