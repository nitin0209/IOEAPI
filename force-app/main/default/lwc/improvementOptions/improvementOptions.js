import { LightningElement } from 'lwc';

export default class ImprovementOptions extends LightningElement {
    improvementOptions = [
        { id: 1, name: 'Cavity wall insulation' },
        { id: 2, name: 'Centralized mechanical extract ventilation' },
        { id: 3, name: 'Decentralized mechanical extract ventilation' },
        { id: 4, name: 'Flat roof insulation' },
        { id: 5, name: 'Loft Insulation (between and over ceiling joists)' },
        { id: 6, name: 'Loft Insulation (between and under/over rafters)' },
        { id: 7, name: 'Mechanical Ventilation with Heat Recovery (MVHR)' },
        { id: 8, name: 'Party cavity wall insulation' },
        { id: 9, name: 'Passive stack ventilation' },
        { id: 10, name: 'Pitched Roof Insulation' },
        { id: 11, name: 'Positive input ventilation' },
        { id: 12, name: 'Room-in-roof insulation' }
    ];

    handlePackageAction(event) {
        const selectedImprovement = event.target.closest('.improvement-item').querySelector('.improvement-title').textContent;
        console.log('Add to package clicked for:', selectedImprovement);
        // Implement your logic for adding to package
    }

    handleHideClick() {
        const hideImprovementOptionsEvent = new CustomEvent('hideimprovementoptions');
        this.dispatchEvent(hideImprovementOptionsEvent);
    }
}