@IsTest
private class TrainingLeadServiceTest {

    private static TrainingLeadService.LeadData buildValidData(String documento, String tipo) {
        TrainingLeadService.LeadData data = new TrainingLeadService.LeadData();
        data.firstName = 'Maria';
        data.lastName = 'Teste';
        data.email = 'maria.teste@exemplo.com';
        data.phone = '27999999999';
        data.tipoDocumento = tipo;
        data.documento = documento;
        data.cep = '29100000';
        data.street = 'Rua Exemplo';
        data.numero = '100';
        data.bairro = 'Centro';
        data.city = 'Vila Velha';
        data.state = 'ES';
        data.complemento = '';
        return data;
    }

    @IsTest
    static void createsLeadWithValidCpf() {
        Test.startTest();
        Id leadId = TrainingLeadService.createLead(
            buildValidData('529.982.247-25', 'CPF - Pessoa Física')
        );
        Test.stopTest();

        Lead created = [SELECT Documento__c, LeadSource, Status FROM Lead WHERE Id = :leadId];
        System.assertEquals('52998224725', created.Documento__c);
        System.assertEquals('Treinamento LWC', created.LeadSource);
        System.assertEquals('Novo', created.Status);
    }

    @IsTest
    static void rejectsInvalidDocument() {
        try {
            TrainingLeadService.createLead(
                buildValidData('52998224726', 'CPF - Pessoa Física')
            );
            System.assert(false, 'Deveria ter lançado exceção');
        } catch (AuraHandledException e) {
            System.assertEquals('Documento inválido.', e.getMessage());
        }
    }

    @IsTest
    static void rejectsMissingRequiredField() {
        TrainingLeadService.LeadData data = buildValidData('52998224725', 'CPF - Pessoa Física');
        data.firstName = '';
        try {
            TrainingLeadService.createLead(data);
            System.assert(false, 'Deveria ter lançado exceção');
        } catch (AuraHandledException e) {
            System.assertEquals('Preencha todos os campos obrigatórios.', e.getMessage());
        }
    }

    @IsTest
    static void rejectsDuplicateLeadDocument() {
        TrainingLeadService.createLead(
            buildValidData('52998224725', 'CPF - Pessoa Física')
        );
        try {
            TrainingLeadService.createLead(
                buildValidData('529.982.247-25', 'CPF - Pessoa Física')
            );
            System.assert(false, 'Deveria ter bloqueado a duplicidade');
        } catch (AuraHandledException e) {
            System.assertEquals('Já existe um cadastro com este documento.', e.getMessage());
        }
    }
}