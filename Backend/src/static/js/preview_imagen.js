// Script para mostrar la imagen previsualizada
document.addEventListener('DOMContentLoaded', function () {
    const imageBoxes = document.querySelectorAll('.image-box');

    imageBoxes.forEach(box => {
        const input = box.querySelector('input[type="file"]');
        const previewImg = box.querySelector('.preview-img');
        const placeholder = box.querySelector('.placeholder-text');

        input.addEventListener('change', () => {
            const file = input.files[0];
            if (file && file.type.startsWith('image/')) {
                const reader = new FileReader();
                reader.onload = e => {
                    previewImg.src = e.target.result;
                    previewImg.style.display = 'block';
                    placeholder.style.display = 'none';
                };
                reader.readAsDataURL(file);
            }
        });
    });
});
