public with sharing class TrainingLeadService {

   public class LeadData {
        public String firstName;
        public String lastName;
        public String email;
        public String phone;
        public String tipoDocumento;
        public String documento;
        public String cep;
        public String street;
        public String numero;
        public String bairro;
        public String city;
        public String state;
        public String complemento;
        public String company;
        public Boolean enderecoValidado;
    }

    public static Id createLead(LeadData data) {
        validateRequired(data);

        String doc = DocumentValidator.sanitize(data.documento);
        Boolean docValid = data.tipoDocumento == 'CPF - Pessoa Física'
            ? DocumentValidator.isValidCpf(doc)
            : DocumentValidator.isValidCnpj(doc);

        if (!docValid) {
            throw userError('Documento inválido.');
        }

        if (isDuplicateDocument(doc)) {
            throw userError('Já existe um cadastro com este documento.');
        }

        Lead newLead = new Lead(
            FirstName = data.firstName,
            LastName = data.lastName,
            Company = String.isBlank(data.company) ? 'Não informado' : data.company,
            Email = data.email,
            Phone = data.phone,
            PostalCode = DocumentValidator.sanitize(data.cep),
            Street = data.street,
            City = data.city,
            State = data.state,
            TipoDocumento__c = data.tipoDocumento,
            Documento__c = doc,
            NumeroEndereco__c = data.numero,
            Bairro__c = data.bairro,
            Complemento__c = data.complemento,
            LeadSource = 'Treinamento LWC',
            Status = 'Novo', EnderecoValidado__c = data.enderecoValidado == true
        );

        insert newLead;
        return newLead.Id;
    }

    private static void validateRequired(LeadData data) {
        if (String.isBlank(data.firstName) || String.isBlank(data.lastName) ||
            String.isBlank(data.email) || String.isBlank(data.phone) ||
            String.isBlank(data.documento) || String.isBlank(data.cep) ||
            String.isBlank(data.street) || String.isBlank(data.numero) ||
            String.isBlank(data.bairro) || String.isBlank(data.city) ||
            String.isBlank(data.state)) {
            throw userError('Preencha todos os campos obrigatórios.');
        }
    }

    private static Boolean isDuplicateDocument(String doc) {
        Integer leadCount = [
            SELECT COUNT() FROM Lead
            WHERE Documento__c = :doc AND IsConverted = false
        ];
        Integer accountCount = [
            SELECT COUNT() FROM Account
            WHERE Documento__c = :doc
        ];
        return leadCount > 0 || accountCount > 0;
    }

    private static AuraHandledException userError(String message) {
        AuraHandledException ex = new AuraHandledException(message);
        ex.setMessage(message);
        return ex;
    }
}