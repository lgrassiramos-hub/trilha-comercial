@IsTest
private class DocumentValidatorTest {

    @IsTest
    static void sanitizeRemovesMaskAndKeepsOnlyDigits() {
        System.assertEquals('52998224725', DocumentValidator.sanitize('529.982.247-25'));
        System.assertEquals('', DocumentValidator.sanitize(null));
    }

    @IsTest
    static void validCpfIsAccepted() {
        System.assertEquals(true, DocumentValidator.isValidCpf('52998224725'));
    }

    @IsTest
    static void invalidCpfCheckDigitIsRejected() {
        System.assertEquals(false, DocumentValidator.isValidCpf('52998224726'));
    }

    @IsTest
    static void repeatedCpfSequenceIsRejected() {
        System.assertEquals(false, DocumentValidator.isValidCpf('00000000000'));
        System.assertEquals(false, DocumentValidator.isValidCpf('11111111111'));
    }

    @IsTest
    static void cpfWithWrongLengthIsRejected() {
        System.assertEquals(false, DocumentValidator.isValidCpf('1234567890'));
    }

    @IsTest
    static void validCnpjIsAccepted() {
        System.assertEquals(true, DocumentValidator.isValidCnpj('11222333000181'));
    }

    @IsTest
    static void invalidCnpjCheckDigitIsRejected() {
        System.assertEquals(false, DocumentValidator.isValidCnpj('11222333000182'));
    }

    @IsTest
    static void repeatedCnpjSequenceIsRejected() {
        System.assertEquals(false, DocumentValidator.isValidCnpj('11111111111111'));
    }
}