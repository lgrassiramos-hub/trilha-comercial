@IsTest
private class TrainingLeadConversionServiceTest {

    @IsTest
    static void converteLeadQualificadoCriandoAccountSemOpportunity() {
        Lead l = new Lead(
            FirstName = 'Conv', LastName = 'Teste', Company = 'Empresa Conv',
            Email = 'conv@exemplo.com', Phone = '27999999999',
            Documento__c = '52998224725', EnderecoValidado__c = true,
            Bairro__c = 'Centro', NumeroEndereco__c = '10', Complemento__c = 'Sala 2'
        );
        insert l;

        Test.startTest();
        Id accountId = TrainingLeadConversionService.converter(l.Id);
        Test.stopTest();

        Account conta = [SELECT Documento__c, Bairro__c, NumeroEndereco__c, Complemento__c FROM Account WHERE Id = :accountId];
        System.assertEquals('52998224725', conta.Documento__c);
        System.assertEquals('Centro', conta.Bairro__c);
        System.assertEquals('10', conta.NumeroEndereco__c);
        System.assertEquals('Sala 2', conta.Complemento__c);
        System.assertEquals(0, [SELECT COUNT() FROM Opportunity WHERE AccountId = :accountId]);
    }

    @IsTest
    static void naoConverteLeadNaoQualificado() {
        Lead l = new Lead(
            LastName = 'Parcial', Company = 'Empresa',
            Email = 'p@exemplo.com', Documento__c = '52998224725'
        );
        insert l;

        try {
            TrainingLeadConversionService.converter(l.Id);
            System.assert(false, 'Deveria ter bloqueado a conversão');
        } catch (AuraHandledException e) {
            System.assertEquals('Este Lead ainda não está apto para conversão.', e.getMessage());
        }
    }
}