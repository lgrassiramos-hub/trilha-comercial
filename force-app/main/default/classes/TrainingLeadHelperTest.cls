@IsTest
private class TrainingLeadHelperTest {

    @IsTest
    static void scoreCompletoChegaA100EQualifica() {
        Lead l = new Lead(
            LastName = 'Teste', Company = 'Empresa',
            Email = 'a@exemplo.com', Phone = '27999999999',
            Documento__c = '52998224725', EnderecoValidado__c = true
        );
        Test.startTest();
        insert l;
        Test.stopTest();

        Lead gravado = [SELECT Score__c, AptoConversao__c, Status FROM Lead WHERE Id = :l.Id];
        System.assertEquals(100, gravado.Score__c);
        System.assertEquals(true, gravado.AptoConversao__c);
        System.assertEquals('Qualificado', gravado.Status);
    }

    @IsTest
    static void scoreParcialNaoQualifica() {
        Lead l = new Lead(
            LastName = 'Parcial', Company = 'Empresa',
            Email = 'b@exemplo.com', Documento__c = '52998224725'
        );
        Test.startTest();
        insert l;
        Test.stopTest();

        Lead gravado = [SELECT Score__c, AptoConversao__c, Status FROM Lead WHERE Id = :l.Id];
        System.assertEquals(55, gravado.Score__c);
        System.assertEquals(false, gravado.AptoConversao__c);
    }

    @IsTest
    static void documentoInvalidoNaoPontua() {
        Lead l = new Lead(
            LastName = 'Invalido', Company = 'Empresa',
            Email = 'c@exemplo.com', Phone = '27999999999',
            Documento__c = '52998224726', EnderecoValidado__c = true
        );
        Test.startTest();
        insert l;
        Test.stopTest();

        Lead gravado = [SELECT Score__c, AptoConversao__c FROM Lead WHERE Id = :l.Id];
        System.assertEquals(60, gravado.Score__c);
        System.assertEquals(false, gravado.AptoConversao__c);
    }
}