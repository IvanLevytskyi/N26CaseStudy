import {LightningElement, wire, track} from 'lwc';
import getInitialData from '@salesforce/apex/CreateNewProductController.getInitialData';
import createProducts from '@salesforce/apex/CreateNewProductController.createProducts';
import {reduceErrors, showToast} from 'c/lwcUtil';

const BASE_COLUMNS = [
    {label: 'Country', fieldName: 'country', type: 'text'},
    {label: 'Active', fieldName: 'isActive', type: 'boolean', editable: true},
    {label: 'Currency', fieldName: 'currencyCode', type: 'text'}
];

export default class CreateNewProduct extends LightningElement {
    showSpinner = false;
    isInitFinished = false;
    productName;
    countries = [];
    columns = [];
    products = [];
    poDescriptors = [];
    @track descriptors;
    draftValues = [];

    @wire(getInitialData)
    wiredInitialData({error, data}) {
        if (data) {
            this.initData(data);
        } else if (error) {
            this.handleError(error);
        }
    }

    onProductNameChange(event) {
        this.productName = event.target.value;
    }

    onResetClick() {
        this.isInitFinished = false;

        getInitialData()
            .then(data => {
                this.initData(data);
            })
            .catch(error => {
                this.handleError(error);
            });
    }

    onSaveClick() {
        if (!this.validateInput()) {
            return;
        }

        this.showSpinner = true;

        this.products = this.draftValues;

        createProducts({ productName : this.productName, products : this.getSelectedRows()})
            .then(result => {
                showToast(this, 'success', 'Products have been successfully created!');
            })
            .catch(error => {
                this.handleError(error);
            })
            .finally(() => {
                this.showSpinner = false;
            });

        this.onResetClick();
    }

    initData(data) {
        this.countries = this.initCountries(data);
        this.poDescriptors = data.prodOptionDescriptors;
        this.columns = this.initColumns(data);
        this.products = this.initRecords(data);
        this.draftValues = [...this.products];

        this.isInitFinished = true;
    }

    initCountries(initialData) {
        return initialData.countries.map(el => el.label);
    }

    initColumns(initialData) {
        let result = [...BASE_COLUMNS];
        for (const poDescriptor of initialData.prodOptionDescriptors) {
            let newColumn = {};
            newColumn.label = poDescriptor.productOptionLabel;
            newColumn.fieldName = poDescriptor.productOptionName;
            newColumn.type = this.getColumnTypeByProductOptionType(poDescriptor.optionType);
            newColumn.editable = true;
            result.push(newColumn);
        }
        return result;
    }

    getColumnTypeByProductOptionType(optionType) {
        switch (optionType) {
            case 'Currency' : {
                return 'number';
            }
            case 'Percent' : {
                return 'percent';
            }
            case 'Text' : {
                return 'text';
            }
            default : {
                return 'text';
            }
        }
    }

    initRecords(initialData) {
        let initialRecords = [];
        for (const country of this.countries) {
            let el = {};

            el.country = country;
            el.isActive = true;
            el.currencyCode = initialData.currencyByCountry.hasOwnProperty(country)
                ? initialData.currencyByCountry[country]
                : initialData.defaultCurrency;

            for (const poDescr of this.poDescriptors) {
                el[poDescr.productOptionName] = null;
            }

            initialRecords.push(el);
        }
        return initialRecords;
    }

    validateInput() {
        let listOfErrors = [];

        let selectedRows = this.getSelectedRows();

        if (!selectedRows.length) {
            listOfErrors.push('You need to select at least one product!');
        }

        if (!this.productName) {
            listOfErrors.push('Please enter the Product Name!');
        }

        for (const product of selectedRows) {
            for (const poDescr of this.poDescriptors) {
                let blankRequiredCells = [];
                if (poDescr.isRequired && !product[poDescr.productOptionName]) {
                    blankRequiredCells.push(poDescr.productOptionLabel);
                }
                if (blankRequiredCells.length) {
                    listOfErrors.push(
                        product.country + ' missed information: ' + blankRequiredCells.join(', ')
                    );
                }
            }
        }

        if (listOfErrors.length) {
            showToast(this, 'error', listOfErrors.join(', '));
        }

        return !listOfErrors.length;
    }

    getSelectedRows() {
        return this.template.querySelector('lightning-datatable').getSelectedRows();
    }

    handleError(error) {
        console.error(error);
        showToast(this, 'error', reduceErrors(error));
    }

    // this is workaround for lightning-datatable with suppress-bottom-bar
    onCellChange(event) {
        // update draft values
        for (const changedCell of event.detail.draftValues) {
            for (let i = 0; i < this.draftValues.length; i++) {
                if (this.draftValues[i].country === changedCell.country) {
                    for (const property in changedCell) {
                        if (property === 'country') {
                            continue;
                        }
                        this.draftValues[i][property] = changedCell[property];
                    }
                    break;
                }
            }
        }
    }
}