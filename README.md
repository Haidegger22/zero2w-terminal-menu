# Raspberry Pi Zero 2W — Terminal Menu

Динамическое терминальное меню-лаунчер для Pi Zero 2W с дисплеем SpotPear 3.5" (480×320). Показывает время, дату и температуру CPU в реальном времени.

## Возможности

- ⏰ **Время и дата** в правом верхнем углу (белым)
- 🌡️ **Температура CPU** с цветовым выделением (жёлтым)
- 📋 **Динамическое меню** — программы читаются из конфиг-файла
- 🔄 **Авто-сброс терминала** (`stty sane`) после каждого приложения
- 🎨 **Цвета ANSI** — время белым, температура жёлтым
- 📝 **Простое добавление** — одна строка в `menu.conf`

## Требования

- Raspberry Pi Zero 2W (или любой Pi с framebuffer-консолью)
- Дисплей **480×320** (SpotPear 3.5" LCD G или аналогичный)
- Шрифт: **8×14** (60 колонок × 22 строки)

## Установка

### 1. Скопировать файлы

```bash
sudo mkdir -p /usr/local/etc
sudo cp menu.sh /usr/local/bin/menu
sudo cp menu.conf /usr/local/etc/menu.conf
sudo chmod +x /usr/local/bin/menu
```

### 2. Настроить шрифт (на Zero 2W с дисплеем 480×320)

```bash
sudo setfont -C /dev/tty1 /usr/share/consolefonts/CyrAsia-TerminusBold14.psf.gz
echo 'setfont -C /dev/tty1 /usr/share/consolefonts/CyrAsia-TerminusBold14.psf.gz' | sudo tee -a /etc/rc.local
```

### 3. Автозапуск меню при входе

```bash
sudo openvt -c 1 -f -- /bin/bash /usr/local/bin/menu
```

## Структура меню

```
                                          05.06.26
                                 23:15  CPU - 44°C

                    ===== Pi Zero 2W =====

============================================================

   1) Terminal              6) Vim
   2) HTOP                  7) System Info
   3) Python                8) Reboot
   4) Midnight Commander    9) Poweroff
   5) Nano

============================================================

> _
```

## Конфигурация меню

Файл `/usr/local/etc/menu.conf` — каждая строка в формате:

```
Название|команда
```

Пример:
```
Terminal|bash
HTOP|htop
Python|python3
My App|/home/pi/myapp.sh
```

Меню читает файл заново на каждом цикле — изменения вступают в силу сразу, без перезапуска. Вмещает до 18 программ (9 строк × 2 колонки).

## Исправление терминала

Если программа оставляет терминал в «сыром» режиме (например после Midnight Commander или vim), меню автоматически делает `stty sane` — клавиатура и дисплей возвращаются в норму.

### Midnight Commander (mc)

Для выхода из mc без F10: нажать `Esc`, затем `0`. Или `Esc`, затем `9` для меню.

## Цветовая схема

| Элемент | ANSI | Цвет |
|---------|------|------|
| Дата/время | `\033[1;37m` | Белый жирный |
| CPU temp | `\033[1;33m` | Жёлтый жирный |
| Меню | default | Зелёный (fbcon) |

## Файлы

- `menu.sh` — основной скрипт
- `menu.conf` — конфигурация программ (пример)

## Связанные репозитории

- [zero2w-spotpear-3.5inch-lcd-g-st7796s](https://github.com/Haidegger22/zero2w-spotpear-3.5inch-lcd-g-st7796s) — настройка дисплея
- [orangepi-zero3w-hdmi-resolution](https://github.com/Haidegger22/orangepi-zero3w-hdmi-resolution) — HDMI на Orange Pi
