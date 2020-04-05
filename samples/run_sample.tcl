#!/usr/bin/wish

#./run_sample.tcl <file sample>
#Утилита используется при запуске в ОС с кодировкой отличной от UTF-8
#В основном используется на MS Windows.
#Можно не использовать, но тогда надо конвертировать сами примеры в нужную кодировку:
#iconv -f UTF-8 -t CP1251 tkfe_sample1.tcl > tkfe_sample1.tcl_CP1251.tcl
#и уже конвертированные примеры запускать
#Загрузка примера
encoding system utf-8
set mydir [file dirname [info script]]
source [file join $mydir [lindex $argv 0]]
tkfe_sample1.tcl
