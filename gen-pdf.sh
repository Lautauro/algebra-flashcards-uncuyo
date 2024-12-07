#!/bin/bash
script_dir=$(dirname "$(realpath "$0")")
cd "${script_dir}"
libreoffice --convert-to pdf --outdir ./PDF/ ./ODT/*.odt
