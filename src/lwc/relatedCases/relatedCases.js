import {LightningElement, api, track, wire} from 'lwc';
import getInitialData from '@salesforce/apex/RelatedCasesController.getInitialData';
import {reduceErrors, showToast} from 'c/lwcUtil';

const COLUMNS = [
    {
        label: 'Case Number',
        fieldName: 'CaseNumberLink',
        type: 'url',
        typeAttributes: {
            label: {
                fieldName: 'CaseNumber'
            }
        }
    },
    { label: 'Subject', fieldName: 'Subject', type: 'text' },
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date-local' }
];

export default class RelatedCases extends LightningElement {
    @track relatedCases;
    @api recordId;
    columns = COLUMNS;
    reportLink;

    @wire(getInitialData, {caseId: '$recordId'})
    wiredInitialData({error, data}) {
        if (data) {
            this.relatedCases = this.processRecords(data.relatedOpenCases);
            this.reportLink = '/lightning/r/Report/' + data.reportId + '/view?fv0=' + data.contactId;
        } else if (error) {
            this.handleError(error);
        }
    }

    processRecords(srcList) {
        let newList = this.proxyToObject(srcList);
        newList.forEach(el => {
            el.CaseNumberLink = '/' + el.Id;
        });
        newList = newList.filter(el => el.Id !== this.recordId);
        return newList;
    }

    proxyToObject(srcProxy) {
        return JSON.parse(JSON.stringify(srcProxy));
    }

    handleError(error) {
        console.error(error);
        showToast(this, 'error', reduceErrors(error));
    }
}