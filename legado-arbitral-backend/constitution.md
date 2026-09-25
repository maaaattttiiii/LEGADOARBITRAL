# constitution.md - Legado Arbitral

## 1. Arquitectura y Ecosistema
- Stack Principal: Python (Backend) con framework FastAPI, y PostgreSQL como motor de base de datos.
- Control de Versiones: El código se administra en GitHub. Toda nueva funcionalidad (feature) debe desarrollarse en una rama (branch) independiente. Queda estrictamente prohibido hacer commits directos a la rama `main`.

## 2. Convenciones de Código
- Idioma: Todo el código fuente (nombres de variables, funciones, tablas de bases de datos, clases) debe escribirse estrictamente en inglés. Los comentarios y documentación pueden ir en español.
- Estilo: El código Python debe adherirse al estándar PEP8 y utilizar tipado estático estricto (Type Hints).
- Paradigma: Priorizar el uso de funciones puras siempre que sea posible.

## 3. Límites y Comportamiento del Agente
- Operaciones Destructivas: El agente tiene prohibido ejecutar comandos que alteren irreversiblemente la base de datos (ej. `DROP TABLE`, `DELETE` masivos) sin confirmación humana explícita[cite: 24].
- Dependencias: El agente no puede instalar ni agregar nuevas librerías externas al entorno virtual sin aprobación explícita del usuario[cite: 24].
- Verificación: Toda nueva funcionalidad debe entregarse obligatoriamente acompañada de sus respectivos tests automatizados que validen los criterios de aceptación[cite: 24].

## 4. Seguridad y Privacidad de Datos
- Protección de Datos: Queda prohibido almacenar contraseñas o tokens en texto plano. Todo dato sensible debe ser encriptado o hasheado antes de persistir en PostgreSQL.
- Fugas de Información: El agente debe asegurar que ninguna información sensible (DNI, contraseñas, correos) quede expuesta en los logs del sistema, mensajes de error del servidor, o consolas de depuración.
- Privacidad: Los datos de los usuarios persisten localmente en la base de datos y nunca se envían a servicios de terceros[cite: 24].