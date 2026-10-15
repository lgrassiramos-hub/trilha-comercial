public with sharing class ViaCepDTO {
    @AuraEnabled public String cep;
    @AuraEnabled public String logradouro;
    @AuraEnabled public String bairro;
    @AuraEnabled public String localidade;
    @AuraEnabled public String uf;
    @AuraEnabled public Boolean erro;
}