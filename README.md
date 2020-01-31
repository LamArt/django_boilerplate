# Boilerplate for django

1. Подгтовка репозитория к разработке на django.
2. Настройка удаленной машины.

Используйте `git bash` на Windows.

## Инструкция
### Создать пустой репозиторий
Обязательно пустой.

## Склонировать этот репозиторий
```
git clone git@github.com:Vladius25/django_boilerplate.git your_project_name
cd your_project_name
```

## Отредактировать config.ini
[PROJECT] - настройки, связанные с именованием проекта

[SSH] - настройки, для подключения к удаленному хосту

[GIT] - ссылка на `созданный` репозиторий

**Важно**. Ссылка обязательно должна начинаться с `git`, а не с `https`.

## Запуск init.sh
С настройкой удаленного хоста:
```
./init.sh
```
Или без настройки удаленного хоста:
```
./init.sh --no-remote
```
**Важно**. Во время установки будет продложено добавить указанный ключ в deploy keys(настройки репо -> deploy keys). Это нужно для того, чтобы клонировать и получать измения без пароля.

## Настройка репозитоия и CI.
Так же этот ключ нужно доавбить в secrets под именем SSH_KEY(настройки репо -> secrets), а в secrets под именем HOST - адрес хоста. И, конечно, в netangels. Это нужно для работы CI.  
