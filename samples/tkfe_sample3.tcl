#!/usr/bin/wish
package require Tk
#Размещение файлового проводника в отдельном окне
#Выбор каталога

#Загрузка пакета tkfe
encoding system utf-8
set mydir [file dirname [info script]]
source [file join $mydir ../package/tkfe.tcl]
#Устанавливаем язык интерфейса ru/en. По умолчанию en
msgcat::mclocale ru

set tekdir $env(HOME)
if {[tk windowingsystem] == "win32"} {
#Перекодируем путь из кодировки ОС
#Для MS Win это скорей всего cp1251
	set tekdir [encoding convertfrom cp1251 $tekdir ]
#Заменяем обратную косую в пути на нормальную косую
	set tekdir [string map {"\\" "/"} $tekdir]
}

set w ".topfm"

label .lab -text "Выбор каталога" -bg skyblue -anchor nw
pack .lab -fill x -expand 1 -anchor nw -side top
button .but -text Выход -command {exit}
pack .but

#размещение в отдельном окне
set typew window
#Выбор катаалога
set vrr [FE::fe_choosedir $typew $w $tekdir ]
if {$typew == "frame"} {
    pack $w -fill both -expand 1
}
#Ждем результата
vwait $vrr
set r ""
#Записываем результат в переменную r
set r [subst $$vrr]
if {$r == ""} {
    set r "Отмена"
}
.lab configure -text "Вы выбрали папку\n$r"
