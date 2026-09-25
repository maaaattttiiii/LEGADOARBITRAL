# feature-spec.md
**Feature:** Registro de Usuarios y Asignación de Roles en Legado Arbitral

**Criterios Funcionales:**
- CA-1 (funcional): El sistema permite registrar una nueva persona recibiendo obligatoriamente: nombre, apellido, DNI y email.
- CA-2 (funcional): Al momento del registro, el sistema debe permitir asignarle a la persona **uno o más roles simultáneos** (ej. Árbitro, Designador, Tesorero, Observador, Presidente, Vicepresidente).
- CA-3 (funcional): Si la persona tiene el rol de "Árbitro", el sistema debe exigir obligatoriamente que se le asigne una "categorización". Para los demás roles, este dato es nulo o irrelevante.
- CA-4 (funcional): Si se intenta registrar un DNI o email que ya existe, el sistema aborta y devuelve un mensaje de error.

**Criterios No Funcionales:**
- CA-5 (no funcional): La base de datos debe persistir la información de forma permanente; los datos no se pierden al reiniciar.
- CA-6 (no funcional): La API debe responder en menos de 300 milisegundos.