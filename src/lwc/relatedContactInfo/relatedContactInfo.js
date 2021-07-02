import {LightningElement, api, wire} from 'lwc';
import {reduceErrors, showToast} from 'c/lwcUtil';
import getInitialData from '@salesforce/apex/RelatedContactInfoController.getInitialData';

const CURRENCY_MAP = new Map([
    ['EUR', '€'],
    ['GBP', '£'],
    ['USD', '$']
]);

export default class RelatedContactInfo extends LightningElement {
    @api recordId;
    product;
    productInfoFields = [];
    currencyMap = CURRENCY_MAP;
    descriptors = [];
    contact = {};

    @wire(getInitialData, { caseId : '$recordId'})
    wiredInitialProductData({error, data}) {
        if (data) {
            this.descriptors = data.descriptors;
            this.contact = data.contact;
            this.product = data.productInfo;

            console.log(JSON.stringify(this.product));

            this.generateInfoFields();
        } else if (error) {
            this.handleError(error);
        }
    }

    generateInfoFields() {
        // TODO generate it dynamically
        // TODO do before validation a) there is no contact b) there is no product
        // index, ? name, label, type, value, formattedValue
        // Rows
        // - Country
        // - Product
        // - ? Product Code
        // - Currency
        // - Cost per month
        // - ATM fee
        // - Card Replacement Cost
        let result = [];
        result.push({
            index: 0,
            name: 'country',
            label: 'Country',
            type: 'text',
            value: this.contact.Home_Country__c,
            formattedValue: this.contact.Home_Country__c
        });
        result.push({
            index: 1,
            name: 'product',
            label: 'Product',
            type: 'text',
            value: this.contact.Product__c,
            formattedValue: this.contact.Product__c
        });
        result.push({
            index: 2,
            name: 'productCode',
            label: 'Product Code',
            type: 'text',
            value: this.product.ProductCode,
            formattedValue: this.product.ProductCode
        });
        result.push({
            index: 3,
            name: 'currencyIsoCode',
            label: 'Currency',
            type: 'text',
            value: this.product.CurrencyIsoCode,
            formattedValue: this.getCurrencySign(this.product.CurrencyIsoCode)
        });
        result.push({
            index: 4,
            name: 'costPerMonth',
            label: 'Cost per Calendar Month',
            type: 'text',
            value: this.getProductValue('Cost per Calendar Month'), // TODO use DeveloperName
            formattedValue: this.getProductFormattedValue('Cost per Calendar Month'), // TODO use DeveloperName
        });
        result.push({
            index: 5,
            name: 'atmFee',
            label: 'ATM Fee in other currencies',
            type: 'text',
            value: this.getProductValue('ATM Fee in other currencies'), // TODO use DeveloperName
            formattedValue: this.getProductFormattedValue('ATM Fee in other currencies'), // TODO use DeveloperName
        });
        result.push({
            index: 6,
            name: 'replacementCost',
            label: 'Card Replacement Cost',
            type: 'text',
            value: this.getProductValue('Card Replacement Cost'), // TODO use DeveloperName
            formattedValue: this.getProductFormattedValue('Card Replacement Cost'), // TODO use DeveloperName
        });
        this.productInfoFields = result;
    }

    getCurrencySign(currencyIsoCode) {
        return this.currencyMap.has(currencyIsoCode) ? this.currencyMap.get(currencyIsoCode) : '';
    }

    getProductInfoByName(productInfoLabel) {
        // TODO add new field to Product Option (Product Name === Product Descriptor Developer Name)
        // TODO search by that new field instead of el.Name
        return this.product.Product_Options__r.find(el => el.Name === productInfoLabel);
    }

    getProductFormattedValue(productOptionLabel) {
        // TODO refactor using new field on Product Option (Product Name === Product Descriptor Developer Name)
        // TODO format currency values
        // TODO format percent values
        return this.getProductValue(productOptionLabel);
    }

    getProductValue(productOptionLabel) {
        // TODO refactor using new field on Product Option (Product Name === Product Descriptor Developer Name)
        const descriptor = this.getDescriptorByLabel(productOptionLabel);
        const prodInfo = this.getProductInfoByName(productOptionLabel);

        let returnValue;

        switch (descriptor.optionType) {
            case 'Currency': {
                returnValue = prodInfo.Currency_Value__c;
                break;
            }
            case 'Percent': {
                returnValue = prodInfo.Percent_Value__c;
                break;
            }
            default: {
                // TODO ?TextValue
                returnValue = '';
                break;
            }
        }

        if (!returnValue) {
            // TODO differentiate labelInsteadOfNull & labelInsteadOfZero
            returnValue = descriptor.labelInsteadOfNull;
        }

        return returnValue;
    }

    getDescriptorByLabel(descLabel) {
        // TODO refactor => getDescriptorByDeveloperName(descName)
        return this.descriptors.find(el => el.productOptionLabel === descLabel);
    }

    handleError(error) {
        console.error(error);
        showToast(this, 'error', reduceErrors(error));
    }
}