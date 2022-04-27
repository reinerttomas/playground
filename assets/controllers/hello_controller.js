import { Controller } from '@hotwired/stimulus';

/**
 * @property {HTMLElement} titleTarget
 */
export default class extends Controller {
    static targets = ['title'];

    greet() {
        this.titleTarget.textContent = 'Hello Stimulus!';
    }
}
