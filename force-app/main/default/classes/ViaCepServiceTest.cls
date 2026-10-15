@IsTest
private class ViaCepServiceTest {

    @IsTest
    static void retornaEnderecoQuandoCepExiste() {
        String body = '{"cep":"29100-000","logradouro":"Rua Exemplo","bairro":"Centro","localidade":"Vila Velha","uf":"ES"}';
        Test.setMock(HttpCalloutMock.class, new ViaCepHttpMock(200, body));

        Test.startTest();
        ViaCepDTO dto = ViaCepService.consultarCep('29100000');
        Test.stopTest();

        System.assertEquals('Rua Exemplo', dto.logradouro);
        System.assertEquals('Centro', dto.bairro);
        System.assertEquals('Vila Velha', dto.localidade);
        System.assertEquals('ES', dto.uf);
    }

    @IsTest
    static void informaCepNaoEncontrado() {
        Test.setMock(HttpCalloutMock.class, new ViaCepHttpMock(200, '{"erro": true}'));

        try {
            Test.startTest();
            ViaCepService.consultarCep('00000000');
            Test.stopTest();
            System.assert(false, 'Deveria lançar exceção');
        } catch (AuraHandledException e) {
            System.assertEquals('CEP não encontrado.', e.getMessage());
        }
    }

    @IsTest
    static void informaServicoIndisponivel() {
        Test.setMock(HttpCalloutMock.class, new ViaCepHttpMock(500, ''));

        try {
            Test.startTest();
            ViaCepService.consultarCep('29100000');
            Test.stopTest();
            System.assert(false, 'Deveria lançar exceção');
        } catch (AuraHandledException e) {
            System.assertEquals('Serviço de CEP indisponível no momento. Tente novamente.', e.getMessage());
        }
    }

    @IsTest
    static void rejeitaCepComTamanhoErrado() {
        try {
            ViaCepService.consultarCep('1234');
            System.assert(false, 'Deveria lançar exceção');
        } catch (AuraHandledException e) {
            System.assertEquals('CEP deve ter 8 dígitos.', e.getMessage());
        }
    }
}