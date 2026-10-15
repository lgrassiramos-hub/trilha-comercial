public with sharing class DocumentValidator {

    public static String sanitize(String document) {
        if (String.isBlank(document)) {
            return '';
        }
        return document.replaceAll('[^0-9]', '');
    }

    public static Boolean isValidCpf(String cpf) {
        if (cpf == null || cpf.length() != 11 || isRepeatedSequence(cpf)) {
            return false;
        }
        Integer d1 = calculateDigit(cpf.substring(0, 9), 10);
        Integer d2 = calculateDigit(cpf.substring(0, 9) + String.valueOf(d1), 11);
        return cpf.substring(9, 11) == String.valueOf(d1) + String.valueOf(d2);
    }

    public static Boolean isValidCnpj(String cnpj) {
        if (cnpj == null || cnpj.length() != 14 || isRepeatedSequence(cnpj)) {
            return false;
        }
        Integer d1 = calculateCnpjDigit(cnpj.substring(0, 12), new List<Integer>{5,4,3,2,9,8,7,6,5,4,3,2});
        Integer d2 = calculateCnpjDigit(cnpj.substring(0, 12) + String.valueOf(d1), new List<Integer>{6,5,4,3,2,9,8,7,6,5,4,3,2});
        return cnpj.substring(12, 14) == String.valueOf(d1) + String.valueOf(d2);
    }

    // Recebe o trecho base e o peso inicial (10 para o 1º dígito, 11 para o 2º)
    private static Integer calculateDigit(String base, Integer weight) {
        Integer sum = 0;
        for (Integer i = 0; i < base.length(); i++) {
            sum += Integer.valueOf(base.substring(i, i + 1)) * (weight - i);
        }
        Integer rest = Math.mod(sum * 10, 11);
        return rest == 10 ? 0 : rest;
    }

    private static Integer calculateCnpjDigit(String base, List<Integer> weights) {
        Integer sum = 0;
        for (Integer i = 0; i < base.length(); i++) {
            sum += Integer.valueOf(base.substring(i, i + 1)) * weights[i];
        }
        Integer rest = Math.mod(sum, 11);
        return rest < 2 ? 0 : 11 - rest;
    }

    private static Boolean isRepeatedSequence(String value) {
        return Pattern.matches('^(\\d)\\1+$', value);
    }
}