#!/bin/bash
clear
script_dir=$(dirname "$(realpath "$0")")
file=""
log_file="${script_dir}/.log"	# Log file
pdfid=-1		# PID del documento PDF abierto
unidad=""
unidad_prev=""
random_flag=0

# Crear archivo log
cat /dev/null > "${log_file}"

imprimir_log() {
	clear
	column -s , -t --table-columns UNIDAD,PÁG,ARCHIVO "${log_file}"
	
	if [[ $random_flag == 1 ]]; then
		echo
		echo "[*] Modo aleatorio ACTIVADO"
	fi

	echo
}

add_log() {
	echo $1 >> "${log_file}"
}

random() {
	echo $((1 + $RANDOM % $1))
}

abrir_pagina_azar() {
	cantidad_de_paginas=$(qpdf --show-npages "$file")
	pagina=0

	if (($cantidad_de_paginas)) && (($cantidad_de_paginas > 0 )); then
		paginas_revisadas=$(awk -F , '{print $1}' "${log_file}" | grep ${unidad} | wc -l)

		if [[ ${paginas_revisadas} -lt ${cantidad_de_paginas} ]]; then
			# Este bucle verifica que la carta no haya sido abierta antes
			while [[ ${pagina} == 0 ]]
			do
				pagina=$((1 + $RANDOM % $cantidad_de_paginas))
					
				if [ $(grep -F "${unidad}" "${log_file}" | awk -F , '{print $2}' | grep -w "${pagina}" | wc -w) != 0 ]; then
					pagina=0
				fi
			done

			# Añadir al archivo log
			add_log "${unidad},${pagina},$(basename "${file}")"

			# Cerrar documento
			if [[ $pdfid != "-1" ]]; then
				kill $pdfid 2> /dev/null
			fi

			xpdf -title "Unidad ${unidad}" "$file" $pagina 2> /dev/null &
			# Guardar PID del documento abierto
			pdfid=$(echo $!)
		else
			clear
			echo "Ya leíste las ${cantidad_de_paginas} cartas de la unidad ${unidad}."
			read -p $'\nPresione ENTER para continuar.'
		fi
	fi
}

imprimir_menu() {
	echo "ÁLGEBRA LINEAL - FING LCC UNCUYO 2024 - Lautaro de Vega"
	echo
	echo "[1] Fundamentos:"
	echo $'\t[1.1] Rudimentos de Lógica Matemática'
	echo $'\t[1.2] Combinatoria y el Principio de Inducción'
	echo $'\t[1.3] Números complejos'
	echo "[2] Sistemas de ecuaciones lineales:"
	echo $'\t[2.1] Sistemas de Ecuaciones Lineales'
	echo $'\t[2.2] Espacios Vectoriales'
	echo "[3] Matrices y determinantes"
	echo "[4] Transformaciones lineales"
	echo "[5] Autovalores, autovectores:"
	echo $'\t[5.1] Autovalores y autovectores'
	echo $'\t[5.2] Diagonalización'
	echo "[*] Para abrir una unidad al azar."
	echo
}

imprimir_error() {
	clear
	echo "ERROR:" $1
	read -p $'\nPresione ENTER para continuar.'
}

while :
do
	if [ $(cat "${log_file}" | wc -w) = 0 ]; then
		clear
		imprimir_menu
	else
		imprimir_log
	fi

	if [ $random_flag = 1 ]; then
		unidad_prev="*"
	else
		unidad_prev=$unidad
	fi

	# Ingresar unidad
	read -p "Indique la unidad con la que desea trabajar: " unidad

	# Utilizar la unidad previamente ingresada.
	if [[ $unidad = "" ]]; then
		if [[ $random_flag == 1 ]]; then
			#random_flag=1
			unidad=$(random 5)
		else
			unidad=$unidad_prev
		fi
	else
		if [[ $random_flag == 1 ]]; then
			random_flag=0
		fi
	fi

	# Seleccionar unidad al azar
	if [[ "${unidad}" == "*" ]]; then
		random_flag=1
		unidad=$(random 5)
		# TODO: Detectar cuando ya han sido leídas todas las cartas
	fi

	# Elegir una de las subunidades
	if [[ $unidad = 5 || $unidad = 2 ]]; then
		unidad="$unidad.$((1 + $RANDOM % 2))"
	fi
	if [ $unidad = 1 ]; then
		unidad="$unidad.$((1 + $RANDOM % 3))"
	fi

	# Seleccionar archivo correspondiente de la unidad
	case "$unidad" in
		"1.1")
			file="${script_dir}/PDF/U1-Rudimentos.pdf"
		;;
		"1.2")
			file="${script_dir}/PDF/U1-Combinatoria.pdf"
		;;
		"1.3")
			file="${script_dir}/PDF/U1-Números-complejos.pdf"
		;;
		"2.1")
			file="${script_dir}/PDF/U2-SEL.pdf"
		;;
		"2.2")
			file="${script_dir}/PDF/U2-Espacios-vectoriales.pdf"
		;;
		"3")
			file="${script_dir}/PDF/U3-Matrices-determinantes.pdf"
		;;
		"4")
			file="${script_dir}/PDF/U4-Transformacion-lineal.pdf"
		;;
		"5.1")
			file="${script_dir}/PDF/U5-Autovalores-y-autovectores.pdf"
		;;
		"5.2")
			file="${script_dir}/PDF/U5-Diagonalización.pdf"
		;;
		# Salir
		"-1")
			exit
		;;
		# Error
		*)
			file="-1"
		;;
	esac

	if [[ -n "$file" && -f "$file" ]]; then
		abrir_pagina_azar
	else
		if [[ "$file" == "-1" ]]; then
			imprimir_error "La unidad \"${unidad}\" no existe."
		elif [ -z "$file" ]; then
			imprimir_error "Debe ingresar una unidad."
		else
			imprimir_error "No se ha podido localizar las cartas de la unidad \"${unidad}\". ${file}"
		fi
	fi

done
