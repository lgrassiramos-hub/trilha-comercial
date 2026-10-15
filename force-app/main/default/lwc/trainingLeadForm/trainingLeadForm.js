import { LightningElement, track } from 'lwc';
import buscarEndereco from '@salesforce/apex/TrainingLeadController.buscarEndereco';
import criarLead from '@salesforce/apex/TrainingLeadController.criarLead';

export default class TrainingLeadForm extends LightningElement {
    @track tipoDocumento = 'CPF - Pessoa Física';
    @track form = {
        firstName: '',
        lastName: '',
        company: '',
        email: '',
        phone: '',
        documento: '',
        cep: '',
        street: '',
        numero: '',
        bairro: '',
        city: '',
        state: '',
        complemento: ''
    };
    @track enderecoValidado = false;
    @track mensagem = '';
    @track erro = false;

    get tipoOptions() {
        return [
            { label: 'CPF - Pessoa Física', value: 'CPF - Pessoa Física' },
            { label: 'CNPJ - Pessoa Jurídica', value: 'CNPJ - Pessoa Jurídica' }
        ];
    }

    get labelDocumento() {
        return this.tipoDocumento.startsWith('CPF') ? 'CPF' : 'CNPJ';
    }

    get classeMensagem() {
        return this.erro ? 'slds-text-color_error' : 'slds-text-color_success';
    }

    handleChange(event) {
        const campo = event.target.name;
        this.form = { ...this.form, [campo]: event.target.value };
        if (campo === 'cep') {
            this.enderecoValidado = false;
        }
    }

    handleTipoChange(event) {
        this.tipoDocumento = event.detail.value;
    }

    handleBuscarCep() {
        this.mensagem = '';
        this.erro = false;
        buscarEndereco({ cep: this.form.cep })
            .then((endereco) => {
                this.form = {
                    ...this.form,
                    street: endereco.logradouro,
                    bairro: endereco.bairro,
                    city: endereco.localidade,
                    state: endereco.uf
                };
                this.enderecoValidado = true;
            })
            .catch((error) => this.mostrarErro(error));
    }

    handleSalvar() {
        this.mensagem = '';
        this.erro = false;
        const dados = {
            ...this.form,
            tipoDocumento: this.tipoDocumento,
            enderecoValidado: this.enderecoValidado
        };
        criarLead({ dataJson: JSON.stringify(dados) })
            .then(() => {
                this.mensagem = 'Lead cadastrado com sucesso!';
                this.erro = false;
            })
            .catch((error) => this.mostrarErro(error));
    }

    mostrarErro(error) {
        this.erro = true;
        this.mensagem = (error && error.body && error.body.message)
            ? error.body.message
            : 'Não foi possível concluir a operação. Tente novamente.';
    }
}