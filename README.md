# DropboxViewer

## Задание:
#### Приложение для работы с dropbox. (Полет фантазии в дизайн приветствуется)
1. Авторизация в DropBox
2. Отображение структуры файлов с возможность навигации по ней. Выводим все в виде таблицы. Ячейка таблицы содержит название файла, дату последней модификации, иконку (можно выбрать любые, лишь бы визуально можно было определить тип файла (папка, текстовый документ, изображение, аудио, другие)).
- По нажатию на текстовый документ, изображение, аудио открывает модальное окно, которое содержит:
	- кнопку для возможности скрыть окно; 
	- кнопка "Send by email" с соответствующей функциональностью
	- название  файла;
	- выводим  сам  файл,  изображение;
	- в случае с аудио полосу прогресса и кнопку play/pause;
- По нажатию на папку переходим дальше по дереву.

## Выполнено:
- Открывает папки, различные форматы фотографий, документов (не только текстовых), аудио и видео.
- Скачанные файлы кэширует и открывает из кэша плюс есть предусмотрена кнопка для обновления.
- Отправляет по электронной почте (проверка размера файла не предусмотрена).
- Автоматически обновляет данные если интернет появился после того как пропадал.

Чтобы запустить нужно выполнить в терминале следующие команды:
```
git clone https://github.com/Nikaaner/DropboxViewer.git
cd DropboxViewer
git submodule update —init —recursive
open DropboxViewer.xcworkspace
```
#### Примечания:
- На дизайн Время не тратил, я еще работал на основной работе, поэтому много времени не было.
- При загрузке данных в статус баре крутится маленький активити индикатор, но лучше было бы еще сделать большой активити индикатор и показывает его по центру вью.
- По каким-то причинам API в ответе на запрос возвращает все данные сразу без пагинации (проверял с 1600+ файлов), хотя выглядит так что нумерация предусмотрена.
- После авторизации браузер запоминает пользователя и чтобы вилогинитися на 100% нужно еще вилогинитися в браузере.
