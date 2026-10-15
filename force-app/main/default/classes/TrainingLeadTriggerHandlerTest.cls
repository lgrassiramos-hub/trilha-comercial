@IsTest
private class TrainingLeadTriggerHandlerTest {

    @IsTest
    static void atualizarTelefoneRecalculaScore() {
        Lead l = new Lead(
            LastName = 'Update', Company = 'Empresa',
            Email = 'u@exemplo.com', Documento__c = '52998224725'
        );
        insert l;

        Test.startTest();
        l.Phone = '27999999999';
        l.EnderecoValidado__c = true;
        update l;
        Test.stopTest();

        Lead gravado = [SELECT Score__c, AptoConversao__c, Status FROM Lead WHERE Id = :l.Id];
        System.assertEquals(100, gravado.Score__c);
        System.assertEquals(true, gravado.AptoConversao__c);
        System.assertEquals('Qualificado', gravado.Status);
    }

    @IsTest
    static void updateSemMudancaNoScoreNaoRecalcula() {
        Lead l = new Lead(
            LastName = 'SemMudanca', Company = 'Empresa',
            Email = 's@exemplo.com', Documento__c = '52998224725'
        );
        insert l;

        Test.startTest();
        l.Description = 'Apenas observação';
        update l;
        Test.stopTest();

        Lead gravado = [SELECT Score__c FROM Lead WHERE Id = :l.Id];
        System.assertEquals(55, gravado.Score__c);
    }
}