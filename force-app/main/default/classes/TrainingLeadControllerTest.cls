@IsTest
private class TrainingLeadControllerTest {

    @IsTest
    static void criarLeadViaJsonCriaRegistro() {
        Map<String, Object> dados = new Map<String, Object>{
            'firstName' => 'Ana',
            'lastName' => 'Controller',
            'email' => 'ana.controller@exemplo.com',
            'phone' => '27988887777',
            'tipoDocumento' => 'CPF - Pessoa Física',
            'documento' => '111.444.777-35',
            'cep' => '29103-830',
            'street' => 'Avenida Amazonas',
            'numero' => '200',
            'bairro' => 'Jockey de Itaparica',
            'city' => 'Vila Velha',
            'state' => 'ES',
            'complemento' => '',
            'company' => '',
            'enderecoValidado' => true
        };

        Test.startTest();
        Id leadId = TrainingLeadController.criarLead(JSON.serialize(dados));
        Test.stopTest();

        Lead created = [SELECT Documento__c, LeadSource, Status, Score__c FROM Lead WHERE Id = :leadId];
        System.assertEquals('11144477735', created.Documento__c);
        System.assertEquals('Treinamento LWC', created.LeadSource);
        System.assertEquals('Qualificado', created.Status);
        System.assertEquals(100, created.Score__c);
    }

    @IsTest
    static void buscarEnderecoRetornaDadosDoViaCep() {
        String body = '{"cep":"29103-830","logradouro":"Avenida Amazonas","bairro":"Jockey de Itaparica","localidade":"Vila Velha","uf":"ES"}';
        Test.setMock(HttpCalloutMock.class, new ViaCepHttpMock(200, body));

        Test.startTest();
        ViaCepDTO dto = TrainingLeadController.buscarEndereco('29103830');
        Test.stopTest();

        System.assertEquals('Avenida Amazonas', dto.logradouro);
        System.assertEquals('Vila Velha', dto.localidade);
    }
}