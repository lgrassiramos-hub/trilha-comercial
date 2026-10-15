public with sharing class TrainingOrderService {

    // Cria a Opportunity e o Order na mesma operação lógica (US-05)
    public static Id criarOpportunityComPedido(Id accountId, TrainingOpportunityService.OpportunityData d) {
        Savepoint sp = Database.setSavepoint();
        try {
            Id oppId = TrainingOpportunityService.criar(accountId, d);
            criarOrder(accountId, oppId);
            return oppId;
        } catch (Exception e) {
            Database.rollback(sp);
            throw e;
        }
    }

    public static Id criarOrder(Id accountId, Id oppId) {
        Order pedido = new Order(
            AccountId = accountId,
            OpportunityId = oppId,
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        insert pedido;
        return pedido.Id;
    }
}