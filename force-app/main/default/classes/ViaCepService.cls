public with sharing class ViaCepService {

    public class ViaCepException extends Exception {}

    public static ViaCepDTO consultarCep(String cepInformado) {
        String cep = DocumentValidator.sanitize(cepInformado);

        if (cep.length() != 8) {
            throw userError('CEP deve ter 8 dígitos.');
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ViaCEP/ws/' + cep + '/json/');
        req.setMethod('GET');
        req.setTimeout(10000);

        HttpResponse res;
        try {
            res = new Http().send(req);
        } catch (Exception e) {
            throw userError('Serviço de CEP indisponível no momento. Tente novamente.');
        }

        if (res.getStatusCode() != 200) {
            throw userError('Serviço de CEP indisponível no momento. Tente novamente.');
        }

        ViaCepDTO dto = (ViaCepDTO) JSON.deserialize(res.getBody(), ViaCepDTO.class);
        if (dto.erro == true) {
            throw userError('CEP não encontrado.');
        }
        return dto;
    }

    private static AuraHandledException userError(String message) {
        AuraHandledException ex = new AuraHandledException(message);
        ex.setMessage(message);
        return ex;
    }
}