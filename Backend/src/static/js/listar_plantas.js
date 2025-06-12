function confirmarEliminacion(plantaId) {
  if (confirm("¿Estás seguro de que deseas eliminar esta planta? Esta acción no se puede deshacer.")) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = `/admin/eliminar_planta/${plantaId}`;
    document.body.appendChild(form);
    form.submit();
  }
}

function actualizarNumeracion() {
  const filas = document.querySelectorAll('#tablaPlantas tbody tr');
  let contador = 1;
  filas.forEach(fila => {
    if (fila.style.display !== 'none') {
      fila.querySelector('.numero').textContent = contador++;
    } else {
      fila.querySelector('.numero').textContent = '';
    }
  });
}

document.getElementById('buscadorNombre').addEventListener('input', function () {
  const filtro = this.value.toLowerCase();
  const filas = document.querySelectorAll('#tablaPlantas tbody tr');

  filas.forEach(fila => {
    const nombreComun = fila.cells[1].innerText.toLowerCase(); // columna nombre común
    fila.style.display = nombreComun.includes(filtro) ? '' : 'none';
  });

  actualizarNumeracion(); // renumerar después del filtro
});

// Inicializar numeración al cargar
window.addEventListener('DOMContentLoaded', actualizarNumeracion);