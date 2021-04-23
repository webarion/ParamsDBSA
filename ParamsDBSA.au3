#include-once

#include <dev.au3>

;     _____                                               _____    ____     _____
;    |  __ \   Version 1.1.0                             |  __ \  |  _ \   / ____|     /\  ©Webarion
;    | |__) |   __ _   _ __    __ _   _ __ ___    ___    | |  | | | |_) | | (___      /  \
;    |  ___/   / _` | | '__|  / _` | | '_ ` _ \  / __|   | |  | | |  _ <   \___ \    / /\ \
;    | |      | (_| | | |    | (_| | | | | | | | \__ \   | |__| | | |_) |  ____) |  / ____ \
;    |_|       \__,_| |_|     \__,_| |_| |_| |_| |___/   |_____/  |____/  |_____/  /_/    \_\

; Note: English translation by Google Translate

; # ABOUT THE LIBRARY # =========================================================================================================
; Name .............: ParamsDBSA
; Current version ..: 1.1.0
; AutoIt Version ...: 3.3.14.5
; Description ......: Provides writing / reading of variables by associative keys
;                   : Serves for faster search of values by keys and subkeys
; Author ...........: Webarion
; Links: ...........: http://webarion.ru, http://f91974ik.bget.ru
; Link library .....: https://github.com/Webarion/ParamsDBSA
; ===============================================================================================================================

#CS Version history:
	v1.0.0
		First published version
	v1.1.0
		Fixed a bug with parameter recording
#CE History

; # О БИБЛИОТЕКЕ # ==============================================================================================================
; Название .........: ParamsDBSA
; Текущая версия ...: 1.1.0
; AutoIt Версия ....: 3.3.14.5
; Описание .........: Обеспечивает запись/чтение переменных по ассоциативным ключам
;                   : Служит для более быстрого поиска значений по ключам и подключам
; Автор ............: Webarion
; Ссылки: ..........: http://webarion.ru, http://f91974ik.bget.ru
; Ссылка библиотеки : https://github.com/Webarion/ParamsDBSA
; ===============================================================================================================================

#CS История версий:
	v1.0.0
		Первая опубликованная версия
	v1.1.0
		Исправлен баг записи параметра
#CE History

#CS Data Storage Format. Формат хранения данных ===================================================================================
	$agDataBase_DBSA[0] = Variables map. Карта переменных
	$agDataBase_DBSA[n] = Variables. Переменные
#CE ===============================================================================================================================

#Region User methods. Пользовательские методы

#CS User methods
	_SET_Param_DBSA 				- writing to the database
	_GET_Param_DBSA 				- reading from the database
	_GET_Keys_DBSA 					- getting all keys
	_GET_SubKeys_DBSA 			- getting all the keys
	_FIND_ParamByKeys_DBSA 	- strict or non-strict search for keys or parameters
	_DEL_Key_DBSA						- deletes the key with all subkeys and their variables
	_DEL_SubKey_DBSA 				- deletes a subkey and its variable
	_CLEAR_DBSA							- clears the entire database
#CE

#CS Пользовательские методы
	_SET_Param_DBSA        - запись в базу
	_GET_Param_DBSA        - чтение из базы
	_GET_Keys_DBSA         - получение всех ключей
	_GET_SubKeys_DBSA      - получение всех подключей
	_FIND_ParamByKeys_DBSA - строгий, либо нестрогий поиск ключей или параметров
	_DEL_Key_DBSA          - удаляет ключ со всеми подключами и содержимым
	_DEL_SubKey_DBSA       - удаляет подключ и его содержимое
	_CLEAR_DBSA            - очищает всю базу
#CE


Global $agDataBase_DBSA[1]



;~ ; Example. Примеры
;~ If @ScriptFullPath = @ScriptDir & '\ParamsDBSA.au3' Then

;~ 	; Setting of parameters. Запись параметров
;~ 	_SET_Param_DBSA('Key1', 'SubKey1', 'a')
;~ 	_SET_Param_DBSA('Key1', 'SubKey2', 'b')
;~ 	_SET_Param_DBSA('Key2', 'SubKey11', 'c')
;~ 	_SET_Param_DBSA('Key2', 'SubKey12', 'd')
;~ 	_SET_Param_DBSA('Key2', 'SubKey21', 'e')

;~ 	; Ways to read parameters. Способы чтения параметров
;~ 	ConsoleWrite('_GET_Param_DBSA(''Key1'', ''SubKey2'') = ' & _GET_Param_DBSA('Key1', 'SubKey2') & @CRLF)

;~ 	Local $aFind = _FIND_ParamByKeys_DBSA('Key2', 'SubKey1', 1)
;~ 	If UBound($aFind) Then
;~ 		ConsoleWrite('_FIND_ParamByKeys_DBSA(''Key2'', ''SubKey1'', 1):' & @CRLF)
;~ 		For $i = 0 To UBound($aFind) - 1
;~ 			ConsoleWrite('[' & $i + 1 & '] = ' & $aFind[$i] & @CRLF)
;~ 		Next
;~ 	EndIf

;~ EndIf
;~ ;


; #USER FUNCTION# ===============================================================================================================
; Description ..: Writes a parameter to the database
; Parameters ...: $sKey           - Key
;                 $sSubKey        - SubKey
;                 $vData          - Data to write
;                 $iCaseSensitive - Whether or not to Take into account the case of keys and subkeys when writing. By default, 0
;                                     If 1, then "Key" and "key" are added as different keys
;                                     If 0, then "Key" and "key" are added as one key, the newer one overwrites the old one
; ===============================================================================================================================
; #ПОЛЬЗОВАТЕЛЬСКАЯ ФУНКЦИЯ# ====================================================================================================
; Описание ....: Записывает параметр в базу данных
; Параметры ...: $sKey           - Ключ
;                $sSubKey        - Подключ
;                $vData          - Записываемые данные
;                $iCaseSensitive - Учитывать или не учитывать регистр ключей и подключей при записи. По умолчанию 0
;                                    Если 1, то "Key" и "key", добавляются, как разные ключи
;                                    Если 0, то "Key" и "key", добавляются, как один ключ, более новый перезаписывает старый
; ===============================================================================================================================
Func _SET_Param_DBSA($sKey, $sSubKey = '', $vData = '', $iCaseSensitive = 0)
	Local $sMapLine, $iIndex, $aIndex
	$sKey = String($sKey)
	$sSubKey = String($sSubKey)
	Local $sMapLine = __GET_MapLine_DBSA($sKey, $iCaseSensitive)
	If Not $sMapLine Then
		$agDataBase_DBSA[0] &= $agDataBase_DBSA[0] ? @CRLF & $sKey : $sKey
		$sMapLine = $sKey
	EndIf
	$aIndex = StringRegExp($sMapLine, ';' & $sSubKey & '=(\d+)', 1)
	$iIndex = UBound($aIndex) ? Number($aIndex[0]) : 0
	If Not $iIndex Then
		ReDim $agDataBase_DBSA[UBound($agDataBase_DBSA) + 1]
		$iIndex = UBound($agDataBase_DBSA) - 1
		$agDataBase_DBSA[0] = StringRegExpReplace($agDataBase_DBSA[0], '(?mi)^(' & $sKey & '.*)$', '$1;' & $sSubKey & '=' & UBound($agDataBase_DBSA) - 1)
	EndIf
	$agDataBase_DBSA[$iIndex] = $vData
	Return 1
EndFunc   ;==>_SET_Param_DBSA

; #USER FUNCTION# ===============================================================================================================
; Description ..: Reads a parameter from the database
; Parameters ...: $sKey          - Key
;                 $sSubKey       - SubKey
;                $iCaseSensitive - 1/0 (case sensitive/not case sensitive) when reading data. Default is 0
; Return ......: Previously recorded data corresponding to the key and subkey
; ===============================================================================================================================
; #ПОЛЬЗОВАТЕЛЬСКАЯ ФУНКЦИЯ# ====================================================================================================
; Описание ....: Читает параметр из базы данных
; Параметры ...: $sKey           - Ключ
;                $sSubKey        - Подключ
;                $iCaseSensitive - 1/0 (Учитывать/не учитывать) регистр ключей и подключей при чтении. По умолчанию 0
; Возвращает ..: Ранее записанные данные, соответствующие ключу и подключу
; ===============================================================================================================================
Func _GET_Param_DBSA($sKey, $sSubKey = '', $iCaseSensitive = 0)
	If Not $agDataBase_DBSA[0] Then Return SetError(1, 0, '')
	Local $aIndex = StringRegExp($agDataBase_DBSA[0], '(?m' & ($iCaseSensitive ? '' : 'i') & ')^' & String($sKey) & '.*?;' & String($sSubKey) & '=(\d+)', 1)
	If Not UBound($aIndex) Then Return SetError(2, 0, '')
	Return $agDataBase_DBSA[$aIndex[0]]
EndFunc   ;==>_GET_Param_DBSA

; #USER FUNCTION# ===============================================================================================================
; Return ......: an array of all the keys
; ===============================================================================================================================
; #ПОЛЬЗОВАТЕЛЬСКАЯ ФУНКЦИЯ# ====================================================================================================
; Возвращает ..: массив всех ключей
; ===============================================================================================================================
Func _GET_Keys_DBSA()
	If Not $agDataBase_DBSA[0] Then Return SetError(1, 0, 0)
	Local $aFirstKeys = StringRegExp($agDataBase_DBSA[0], '(?mi)^(.+?)(?:;|$)', 3)
	If Not UBound($aFirstKeys) Then Return SetError(2, 0, 0)
	Return $aFirstKeys
EndFunc   ;==>_GET_Keys_DBSA

; #USER FUNCTION# ===============================================================================================================
; Return ......: Returns an array of subkeys
; ===============================================================================================================================
; #ПОЛЬЗОВАТЕЛЬСКАЯ ФУНКЦИЯ# ====================================================================================================
; Возвращает ..: Возвращает массив подключей
; ===============================================================================================================================
Func _GET_SubKeys_DBSA($sKey, $iCaseSensitive = 0)
	If Not $agDataBase_DBSA[0] Then Return SetError(1, 0, 0)
	Local $sMapLine = __GET_MapLine_DBSA($sKey, $iCaseSensitive)
	If Not $sMapLine Then Return SetError(2, 0, 0)
	Local $aSubKeys = StringRegExp($sMapLine, ';(.+?)=', 3)
	If Not UBound($aSubKeys) Then Return SetError(3, 0, 0)
	Return $aSubKeys
EndFunc   ;==>_GET_SubKeys_DBSA

; #USER FUNCTION# ===============================================================================================================
; Description .: Search by key and specified parameters
; Parameters ..: $sKey           - Key
;                $sSubKey        - Search string in the subkey
;                $iLocateFind    - Search method. By default, 0
;                                    0 - exact match
;                                    1 - match at the beginning of the connection
;                                    2 - match at the end of the connection
;                                    3 - match anywhere in the connection
;                $iTypeRet       - Return type. By default, 0
;                                    0 - return parameters
;                                    1 - return found plug-ins
;                $iCaseSensitive - 1/0 (case sensitive/not case sensitive) key and subkey
; ===============================================================================================================================
; #ПОЛЬЗОВАТЕЛЬСКАЯ ФУНКЦИЯ# ====================================================================================================
; Описание ....: Поиск по ключу и указанным параметрам
; Параметры ...: $sKey           - Ключ
;                $sSubKey        - Искомая строка в подключе
;                $iLocateFind    - способ поиска. По умолчанию 0
;                                    0 - точное совпадение
;                                    1 - совпадение по началу подключа
;                                    2 - совпадение по концу подключа
;                                    3 - совпадение в любом месте подключа
;                $iTypeRet       - Тип возвращаемого. По умолчанию 0
;                                    0 - вернуть параметры
;                                    1 - вернуть найденные подключи
;                $iCaseSensitive - $iCaseSensitive - 1/0 (Учитывать/не учитывать) регистр символов ключа и подключа при поиске
; ===============================================================================================================================
Func _FIND_ParamByKeys_DBSA($sKey, $sSubKey = '', $iLocateFind = 0, $iTypeRet = 0, $iCaseSensitive = 0)
	If Not $agDataBase_DBSA[0] Then Return SetError(1, 0, '')
	Local $sMapLine = __GET_MapLine_DBSA($sKey, $iCaseSensitive)
	If Not $sMapLine Then Return SetError(2, 0, '')
	Local $sPat = '.*?', $sPatL = '', $sPatR = ''
	Switch $iLocateFind
		Case 1
			$sPatR = $sPat
		Case 2
			$sPatL = $sPat
		Case 3
			$sPatL = $sPat
			$sPatR = $sPat
	EndSwitch
	Local $aSubKeys = StringRegExp($sMapLine, ';(' & $sPatL & $sSubKey & $sPatR & ')=\d+', 3)
	If Not UBound($aSubKeys) Then Return SetError(3, 0, '')
	If $iTypeRet Then
		Return $aSubKeys
	Else
		Local $aParams[0], $iUB
		For $i = 0 To UBound($aSubKeys) - 1
			$iUB = UBound($aParams)
			ReDim $aParams[$iUB + 1]
			$aParams[$iUB] = _GET_Param_DBSA($sKey, $aSubKeys[$i], $iCaseSensitive)
		Next
		Return $aParams
	EndIf
EndFunc   ;==>_FIND_ParamByKeys_DBSA

; #USER FUNCTION# ===============================================================================================================
; Description .: Deletes the key with all subkeys and their parameters
; Parameters ..: $sKey
;                $iCaseSensitive - 1/0 (case sensitive/not case sensitive) key and subkey
; ===============================================================================================================================
; #ПОЛЬЗОВАТЕЛЬСКАЯ ФУНКЦИЯ# ====================================================================================================
; Описание ....: Удаляет ключ со всеми подключами и их параметрами
; Параметры ...: $sKey           - Ключ
;                $iCaseSensitive - 1/0 (Учитывать/не учитывать) регистр символов ключа и подключа
; ===============================================================================================================================
Func _DEL_Key_DBSA($sKey, $iCaseSensitive = 0)
	Local $aSubKeys = _GET_SubKeys_DBSA($sKey, $iCaseSensitive)
	If Not UBound($aSubKeys) Then Return SetError(1, 0, 0)
	For $i = 0 To UBound($aSubKeys) - 1
		_DEL_SubKey_DBSA($sKey, $aSubKeys[$i], $iCaseSensitive)
	Next
	$agDataBase_DBSA[0] = StringRegExpReplace($agDataBase_DBSA[0], '(?ms' & ($iCaseSensitive ? '' : 'i') & ')^' & String($sKey) & '.+?(?:\v+|\z)', '')
	$agDataBase_DBSA[0] = StringRegExpReplace($agDataBase_DBSA[0], '\v+\z', '')
	Return 1
EndFunc   ;==>_DEL_Key_DBSA

; удаляет подключ и его параметр
; #USER FUNCTION# ===============================================================================================================
; Description .: Removes the subkey and its parameter
; Parameters ..: $sKey           - Key
;                $sSubKey        - Subkey
;                $iCaseSensitive - 1/0 (case sensitive/not case sensitive) key and subkey
; ===============================================================================================================================
; #ПОЛЬЗОВАТЕЛЬСКАЯ ФУНКЦИЯ# ====================================================================================================
; Описание ....: Удаляет подключ и его параметр
; Параметры ...: $sKey           - Ключ
;                $sSubKey        - Подключ
;                $iCaseSensitive - 1/0 (Учитывать/не учитывать) регистр символов ключа и подключа
; ===============================================================================================================================
Func _DEL_SubKey_DBSA($sKey, $sSubKey = '', $iCaseSensitive = 0)
	If Not $agDataBase_DBSA[0] Then Return SetError(1, 0, '')
	$sKey = String($sKey)
	$sSubKey = String($sSubKey)
	Local $aIndex = StringRegExp($agDataBase_DBSA[0], '(?m' & ($iCaseSensitive ? '' : 'i') & ')^' & $sKey & '.*?;' & $sSubKey & '=(\d+)', 1)
	If Not UBound($aIndex) Then Return SetError(2, 0, '')
	$agDataBase_DBSA[0] = StringRegExpReplace($agDataBase_DBSA[0], '(?msi)\A(.*?^' & $sKey & '.*?);' & $sSubKey & '=\d+(.*)\z', '\1\2')
	If @extended Then
		Local $iUB = UBound($agDataBase_DBSA)
		For $i = $aIndex[0] To $iUB - 1
			If $i < $iUB - 1 Then $agDataBase_DBSA[$i] = $agDataBase_DBSA[$i + 1]
			If $i > $aIndex[0] Then $agDataBase_DBSA[0] = StringRegExpReplace($agDataBase_DBSA[0], '(?si)\A(.*?;.*?)(=' & $i & ')(.*)\z', '\1=' & $i - 1 & '\3')
		Next
		$agDataBase_DBSA[0] = StringRegExpReplace($agDataBase_DBSA[0], '(?si)\A(.*?;.*?)(=' & $i & ')(.*)\z', '\1=' & $i - 1 & '\3')
		ReDim $agDataBase_DBSA[$iUB - 1]
	EndIf
	Return 1
EndFunc   ;==>_DEL_SubKey_DBSA

; Очищает всю базу
; #USER FUNCTION# ===============================================================================================================
; Description .: Cleans the entire base
; ===============================================================================================================================
; #ПОЛЬЗОВАТЕЛЬСКАЯ ФУНКЦИЯ# ====================================================================================================
; Описание ....: Очищает всю базу
; ===============================================================================================================================
Func _CLEAR_DBSA()
	Dim $agDataBase_DBSA[1]
EndFunc   ;==>_CLEAR_DBSA
#EndRegion User methods. Пользовательские методы

#Region Системные методы. System methods
; Returns a keymap string with subkeys. Возвращает строку карты ключа с подключами
Func __GET_MapLine_DBSA($sKey, $iCaseSensitive = 0)
	Local $aMapLine = StringRegExp($agDataBase_DBSA[0], '(?m' & ($iCaseSensitive ? '' : 'i') & ')^' & String($sKey) & '.*$', 1)
	If Not UBound($aMapLine) Then Return SetError(1, 0, '')
	Return $aMapLine[0]
EndFunc   ;==>__GET_MapLine_DBSA

;~ Func __Keys_Splitter($sKeys)
;~ 	If $sKeys Then
;~ 		Local $aKeys = StringRegExp(String($sKeys), '^(.+?)(?:/(.*))?$', 3)
;~ 		If UBound($aKeys) = 1 Then ReDim $aKeys[2]
;~ 		$aKeys[0] = StringReplace($aKeys[0], '=', '&equal')
;~ 	Else
;~ 		Dim $aKeys[2] = ['', '']
;~ 	EndIf
;~ 	Return $aKeys
;~ EndFunc   ;==>__Keys_Splitter

#EndRegion Системные методы. System methods
