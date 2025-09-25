// app/javascript/packs/activities.js
document.addEventListener('DOMContentLoaded', function() {
    const toggleButtons = document.querySelectorAll('.changes-toggle');

    toggleButtons.forEach(button => {
        button.addEventListener('click', function() {
            const detailsElement = this.nextElementSibling;
            detailsElement.classList.toggle('visible');

            if (detailsElement.classList.contains('visible')) {
                this.textContent = 'Änderungen verbergen';
            } else {
                this.textContent = 'Änderungen anzeigen';
            }
        });
    });
});
