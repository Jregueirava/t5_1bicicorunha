<div align="center">
<h1 align="center">BiciCoruña - Acceso Rápido 🚴‍♂️</h1>
<p>Por <a href="https://www.linkedin.com/in/jesusregueirava/">Jesús Regueira Vázquez</a></p>
</div>

<img src="https://github.com/Jregueirava/t5_1bicicorunha/blob/main/Captura%20de%20pantalla%202025-12-25%20204752.png?raw=true">

---

##  Sobre el proyecto

**BiciCoruña - Acceso Rápido** es una aplicación Flutter desarrollada como alternativa a la app oficial del servicio BiciCoruña. El objetivo principal es resolver la frustración de usuarios que necesitan **consultar rápidamente** el estado de una o varias estaciones sin tener que navegar por mapas lentos.

### Problema que resuelve
La app oficial de BiciCoruña resulta poco fluida para consultas rápidas: obliga a navegar por el mapa, no siempre localiza bien y hace lenta la consulta estación por estación. Esta app ofrece:

- ✅ **Acceso inmediato** a tu estación favorita (ej: "la de debajo de casa")
- ✅ **Visualización clara** con gráficos prácticos
- ✅ **Indicador "¿Me compensa bajar?"** basado en disponibilidad de e-bikes
- ✅ **Exportación completa a PDF** del estado de cualquier estación

---

##  Enfoque del desarrollo

### Arquitectura: MVVM (Model-View-ViewModel)
El proyecto sigue el patrón **MVVM** para mantener separadas las responsabilidades:

- **Model** (`/models`): Entidades de datos (`StationInfo`, `StationStatus`, `StationCombined`)
- **Data** (`/data`): Capa de acceso a APIs GBFS (`BiciApi`, `BiciRepository`)
- **ViewModel** (`/viewmodels`): Lógica de presentación sin código de UI (`StationsVm`)
- **View** (`/views`): Interfaz de usuario con widgets reutilizables

### Fuente de datos
Consume en tiempo real las APIs oficiales de BiciCoruña basadas en GBFS:
- `station_information`: Datos estáticos (nombre, ubicación, capacidad)
- `station_status`: Estado actual (bicis disponibles, e-bikes, anclajes libres)

---

## Justificación de los gráficos

### Gráfico A: Top 5 estaciones con más e-bikes (Barras)
**Tipo:** `BarChart` de `fl_chart`  
**Justificación:** Permite ver de un vistazo **dónde hay más bicis eléctricas disponibles** en toda la ciudad, sin tener que buscar estación por estación. Ideal para decidir rápidamente a qué estación ir si la tuya está vacía.

<img src="https://github.com/Jregueirava/t5_1bicicorunha/blob/main/Captura%20de%20pantalla%202025-12-25%20204743.png?raw=true" width="600">

### Gráfico B: Distribución de una estación (Pie/Donut)
**Tipo:** `PieChart` de `fl_chart`  
**Justificación:** Ofrece una **visión clara del estado actual** de UNA estación específica (la favorita o la que se está consultando), mostrando la proporción entre e-bikes, mecánicas y anclajes libres de forma visual e inmediata.

<img src="https://github.com/Jregueirava/t5_1bicicorunha/blob/main/Captura%20de%20pantalla%202025-12-25%20204723.png?raw=true" width="600">

---

##  Funcionalidades implementadas

### Pantalla principal (Home)
- Tarjeta de **estación favorita** con datos en tiempo real
- Indicador visual **"¿Me compensa bajar ahora?"** (Sí/Quizá/No)
- Gráfico de barras: **Top 5 estaciones con más e-bikes**
- Botón para ver todas las estaciones y marcar favorita

### Pantalla de detalle
- Información completa de la estación seleccionada
- Fecha/hora de última actualización de datos
- Gráfico de anillo (Pie) con distribución actual
- Estadísticas numéricas (e-bikes, mecánicas, anclajes, ocupación)
- **Exportación a PDF** con todos los datos del momento

### Lógica "¿Me compensa bajar?"
