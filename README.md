
Note: English translation by Google Translate

## ABOUT THE LIBRARY ##
- **Description:** Provides writing / reading of variables by associative keys. Serves for faster search of values by keys and subkeys
- **Current version:** 1.1.0
- **AutoIt Version:** 3.3.14.5
- **Author:** Webarion
- **Links:** [Site](http://webarion.ru "Site"), [Mirror](http://f91974ik.bget.ru "Mirror")

### Version history: ###
v1.0.0 - First published version
v1.1.0 - Fixed a bug with parameter recording

### Data Storage Format ###
	$agDataBase_DBSA[0] = Variables map
	$agDataBase_DBSA[n] = Variables

### User methods ###
- `_SET_Param_DBSA` - writing to the database
- `_GET_Param_DBSA` - reading from the database
- `_GET_Keys_DBSA` - getting all keys
- `_GET_SubKeys_DBSA` - getting all the keys
- `_FIND_ParamByKeys_DBSA` - strict or non-strict search for keys or parameters
- `_DEL_Key_DBSA` - deletes the key with all subkeys and their variables
- `_DEL_SubKey_DBSA` - deletes a subkey and its variable
- `_CLEAR_DBSA` - clears the entire database

----------

## О БИБЛИОТЕКЕ ##
 - **Описание:** Обеспечивает запись/чтение переменных по ассоциативным ключам. Служит для более быстрого поиска значений по ключам и подключам.
 - **Текущая версия:** 1.1.0
 - **AutoIt Версия:** 3.3.14.5
 - **Автор:** Webarion
 - **Ссылки:** [Основной сайт](http://webarion.ru "Основной сайт"), [Зеркало](http://f91974ik.bget.ru "Зеркало")
 
### История версий: ###
v1.0.0 - Первая опубликованная версия
v1.1.0 - Исправлен баг записи параметра
		
### Формат хранения данных ###
	$agDataBase_DBSA[0] = Карта переменных
	$agDataBase_DBSA[n] = Переменные

### Пользовательские методы ###
- `_SET_Param_DBSA` - запись в базу
- `_GET_Param_DBSA` - чтение из базы
- `_GET_Keys_DBSA` - получение всех ключей
- `_GET_SubKeys_DBSA` - получение всех подключей
- `_FIND_ParamByKeys_DBSA` - строгий, либо нестрогий поиск ключей или параметров
- `_DEL_Key_DBSA` - удаляет ключ со всеми подключами и содержимым
- `_DEL_SubKey_DBSA` - удаляет подключ и его содержимое
- `_CLEAR_DBSA` - очищает всю базу
