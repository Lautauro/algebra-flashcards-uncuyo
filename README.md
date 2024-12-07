# Cartas de estudio para Álgebra
Este es un script en Bash que he creado para estudiar la materia **Álgebra** de la **Licenciatura en Ciencias de la Computación** de la **Universidad Nacional de Cuyo**.

Al ejecutar el script, se le solicitará al usuario que ingrese la unidad que desea repasar. El programa eligirá una "carta" al azar de esta unidad, la cual contendrá una consigna. Estas "cartas" son archivos PDF llenos de preguntas. Puede ver cómo modificar estas cartas en la sección **[Modificar cartas](#modificar-cartas)**.

## Requisitos

Ejecute los siguientes comandos para instalar las dependencias necesarias:

### Ubuntu/Linux Mint y derivadas:
```bash
sudo apt update
sudo apt install qpdf xpdf libreoffice-java-common
```

> [!NOTE]
> **xpdf** puede ser reemplazado por cualquier otro lector de PDF como Okular ó Evince.
> En caso de querer reemplazarlo debe modificar la línea del script donde se invoque a xpdf.
> Puede localizarla utilizando dentro de la carpeta del proyecto:
> > grep -n "xpdf" random.sh

## Cómo usarlo

Para iniciar el programa, ejecute el siguiente comando:

```bash
./random.sh
```

## Modificar cartas

En la carpeta ODT se encuentran todas las cartas en formato **ODT** (pueden abrirse con LibreOffice o MS Word). Si modifica alguna carta, debe volver a exportar el archivo a PDF dentro de la carpeta PDF. El script **gen-pdf.sh** se encarga de hacer esto con cada una de las cartas.

Para generar los PDFs, ejecute:

```bash
./gen-pdf.sh
```

