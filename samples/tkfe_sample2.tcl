#!/usr/bin/wish
package require Tk
#функции блокирования кнопок

proc all_disable {parent} {
    set widgets [info commands $parent*]
    foreach w $widgets {
        catch {$w configure -state disabled}
    }
}
proc all_enable {parent} {
    set widgets [info commands $parent*]
    foreach w $widgets {
        catch {$w configure -state normal}
    }
}


#Размещение файлового проводника во фрейме

#Загрузка пакета tkfe
encoding system utf-8
set mydir [file dirname [info script]]
source [file join $mydir ../package/tkfe.tcl]
#Устанавливаем язык интерфейса ru/en. По умолчанию en
msgcat::mclocale ru

#namespace import fileexplorer::*
set tekdir $env(HOME)
if {[tk windowingsystem] == "win32"} {
#Перекодируем путь из кодировки ОС
#Для MS Win это скорей всего cp1251
	set tekdir [encoding convertfrom cp1251 $tekdir ]
#Заменяем обратную косую в пути на нормальную косую
	set tekdir [string map {"\\" "/"} $tekdir]
}

#размещение во frame
set w ".topfm"
set msk "*.txt *.doc .* *"
set typew frame

wm title . "Окно с FE"

label .lab -text "Ниже размещен файловый проводник FE::" -bg skyblue -anchor nw
pack .lab -fill x -expand 1 -anchor nw -side top
button .but -text ВЫХОД -command {exit}
pack .but -fill none -expand 0 -anchor se -side bottom
#Блокируем все виджеты на окне. в котором разместим  проводник
all_disable .
set vrr [FE::fe_getopenfile  $typew ".fr" $tekdir $msk]
#Метод place
#place .test.fr -in .test.lab -relx 0.0 -rely 1.0 -relwidth 1.0
#Метод pack
pack .fr -in . -fill both -expand 1
#Ждем результата
vwait $vrr
#Разблокируем виджеты
all_enable .
#Записываем результат в переменную r
set r [subst $$vrr]
if {$r == ""} {
    set r "ОТМЕНА"
}
.lab configure -text "Вы выбрали файл\n$r"
