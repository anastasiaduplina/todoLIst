
# Todo List
Это приложение, которое позволяет пользователям просматривать список новостей и просматривать подробную информацию о каждой выбранной новости. Также можно добавлять интересующие новости в избранное.
Новости можно искать по поиску и фильтровать их по дате публикации и сортировать. Приложение состоит из двух экранов:

### Главный экран:
На этом экране отображается список дел. Пользователи могут помечать дела выполненными, удалять их, редактировать. 


### Экран добавления/редактирования дел:
Пользователь может описать свои дела, поставить важность, установить дедлайн и удалить текущее занятие.

## Скриншоты
<table>
  <tr>
    <td><img src="screenshots/ligh_main1.jpg" width="200"/></td>
    <td><img src="screenshots/light_main2.jpg" width="200"/></td>
    <td><img src="screenshots/light_add1.jpg" width="200"/></td>
  </tr>
  <tr>
    <td><img src="screenshots/dark_main1.jpg" width="200"/></td>
    <td><img src="screenshots/dark_main2.jpg" width="200"/></td>
    <td><img src="screenshots/dark_add1.jpg" width="200"/></td>
  </tr>
</table>

## APK
Apk файл лежит в папке apk


## Deployment

Начало работы
Чтобы запустить локальную копию, выполните следующие простые шаги:


Клонируйте репозиторий:
```bash
  git clone https://gitlab.com/anastasiaduplina/news_app.git
```

Перейдите в каталог проекта:
```bash
  cd your-repo-name
``` 
Установите зависимости:
```bash
   flutter pub get
```
Запустите кодогенерацию
```bash
   dart run build_runner build
```
Запустите приложение:
```bash
  flutter run
```


