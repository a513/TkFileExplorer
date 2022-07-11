#!/usr/bin/wish
package require Tk
package require msgcat
#Комплексный пример импользования файлового проводника tkfe

#Загрузка пакета tkfe
encoding system utf-8
set mydir [file dirname [info script]]
#source [file join $mydir ../package/tkfe.tcl]
source [file join $mydir ../package/tkfe.tcl]
#Устанавливаем язык интерфейса для проводника ru/en. По умолчанию en
msgcat::mclocale ru

. configure -background white
set typefe open
#Где размещать проводник: в отдельном окне window или во фрейме frame
set typew window

proc selectpath {w wplace} {
    global env
    variable typefe
    variable typew
#Каталог пользователя
    set tekdir $env(HOME)
#    set tekdir $env(TMPDIR)
    if {[tk windowingsystem] == "win32"} {
#Перекодируем путь из кодировки ОС
#Для MS Win это скорей всего cp1251
	set tekdir [encoding convertfrom cp1251 $tekdir ]
#Заменяем обратную косую в пути на нормальную косую
	set tekdir [string map {"\\" "/"} $tekdir]
    }
#Фильт для файлов
    set typelist {
	    {""  {*.can *.svg *txt *.png}}
	    {"Canvas"     {*.can *.svg *.png}}
	    {"XML/SVG"    {*.svg}}
	    {"Text"       {*.txt}}
	    {{All Files} *}
    }

    set msk $typelist
#параметры
if {0} {
    set specs {
	{-typew "" "" "window"}
	{-widget "" "" "."}
	{-defaultextension "" "" ""}
	{-filetypes "" "" ""}
	{-initialdir "" "" ""}
	{-initialfile "" "" ""}
	{-parent "" "" "."}
	{-title "" "" ""}
	{-sepfolders "" "" 1}
	{-foldersfirst "" "" 1}
#	{-sort "" "" "#0"}
#	{-reverse "" "" 0}
	{-details "" "" 0}
	{-hidden "" "" 0}
	{-width "" "" 0}
	{-height "" "" 0}
    }
}

    switch -- $typefe {
	open {
#Выбор файла для чтения
	    set vrr [FE::fe_getopenfile  -typew $typew -widget $w -initialdir $tekdir -filetypes $msk -title "ФАЙЛ ОТКРЫТЬ" -details 1]
	}
	save {
#Выбор файла для записи в него
#  -widget $w
	    set vrr [FE::fe_getsavefile  -typew $typew -initialdir $tekdir -filetypes $msk -width 600 -height 450]
	}
	dir {
#Выбор катаалога
	    set vrr [FE::fe_choosedir  -typew $typew -widget $w -initialdir $tekdir ]

	}
    }
#Записываем результат в переменную r
    set r $vrr
    if {$r == ""} {
	set r "Отмена"
    }
    .labchoose configure -text "Ваш выбор:\n$r"
}
  #Процедура смены языка и синхронный перевод
proc changelang {w } {
    #Смена языка и синхронный перевод
    #Смена иконки на кнопке
    if  {[msgcat::mclocale] == "ru"} {
      msgcat::mclocale en
      $w.lang configure -image fe_usa_24x16
    } else {
      msgcat::mclocale ru
      $w.lang configure -image fe_ru_24x16
    }
}

set pretext "Выберите тип диалога: выбрать файл для последующего чтения или \
файл, в который вы что-то собираетесь записать, или\
каталог/папку. После этого нажмите на кнопку \"Выбрать\""
label .lab -text $pretext -wraplength 100mm -bg skyblue -anchor nw
labelframe .typefe -text "Выберите тип диалога"
ttk::radiobutton .typefe.chb1 -value open -variable typefe -text "Выбор файла для чтения"
ttk::radiobutton .typefe.chb2 -value save -variable typefe -text "Выбор файла для записи"
ttk::radiobutton .typefe.chb3 -value dir -variable typefe -text "Выбор каталога/папки"
grid .typefe.chb1 -row 0 -column 0 -sticky nwse -padx 1mm -pady {0 1mm}
grid .typefe.chb2 -row 1 -column 0 -sticky nwse -padx 1mm -pady {0 1mm}
grid .typefe.chb3 -row 2 -column 0 -sticky nwse -padx 1mm -pady {0 1mm}
grid columnconfigure .typefe 0 -weight 1

labelframe .typew -text "Тип размещения" -labelanchor n 
ttk::radiobutton .typew.chb1 -value frame -variable typew -text "Фрейм"
ttk::radiobutton .typew.chb2 -value window -variable typew -text "Окно"
ttk::button .typew.lang -style Toolbutton -command {changelang .typew}

if {[msgcat::mclocale] == "ru" } {
    .typew.lang configure -image  fe_ru_24x16
} else {
    .typew.lang configure -image fe_usa_24x16
}

grid .typew.chb1 -row 0 -column 0 -sticky w -padx {8 8} -pady {0 1mm}
grid .typew.chb2 -row 0 -column 1 -sticky ns -pady {0 1mm}
grid .typew.lang -row 0 -column 2 -sticky ns -pady {0 1mm}
grid columnconfigure .typew 0 -weight 1
grid columnconfigure .typew 1 -weight 1

label .labchoose -text "Вы еще не сделали свой выбор" -wraplength 100mm -bg skyblue -anchor nw

button .butchoose -text "Выбрать" -command {selectpath .fe .lab }

button .but -text Выход -command {exit}
pack .lab -fill x -expand 1 -anchor nw -side top -pady 5mm
pack .typefe -fill x -expand 1
pack .typew -fill x -expand 1 -pady {5mm 80mm}
pack .butchoose -anchor ne -side top -pady 1mm
pack .labchoose -fill x -expand 0 -anchor nw -side top -pady 0
pack .but -anchor ne
