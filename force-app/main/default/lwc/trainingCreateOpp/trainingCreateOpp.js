import { LightningElement, api, track } from 'lwc';
import criarOportunidade from '@salesforce/apex/TrainingOpportunityController.criarOportunidade';

export default class TrainingCreateOpp extends LightningElement {
    @api recordId;
    @track form = {
        nome: '',
        produto: '',
        valorEstimado: null,
        quantidade: null,
        dataFechamento: '',
        observacao: ''
    };
    @track mensagem = '';
    @track erro = false;

    get produtoOptions() {
        return [
            { label: 'Produto A', value: 'Produto A' },
            { label: 'Produto B', value: 'Produto B' }
        ];
    }

    get classeMensagem() {
        return this.erro ? 'slds-text-color_error' : 'slds-text-color_success';
    }

    handleChange(event) {
        const campo = event.target.name;
        this.form = { ...this.form, [campo]: event.target.value };
    }

    handleSalvar() {
        this.mensagem = '';
        this.erro = false;
        const dados = {
            nome: this.form.nome,
            produto: this.form.produto,
            valorEstimado: Number(this.form.valorEstimado),
            quantidade: parseInt(this.form.quantidade, 10),
            dataFechamento: this.form.dataFechamento,
            observacao: this.form.observacao
        };
        criarOportunidade({ accountId: this.recordId, dataJson: JSON.stringify(dados) })
            .then(() => {
                this.mensagem = 'Oportunidade criada com sucesso!';
            })
            .catch((error) => {
                this.erro = true;
                this.mensagem = (error && error.body && error.body.message)
                    ? error.body.message
                    : 'Não foi possível criar a oportunidade.';
            });
    }
}