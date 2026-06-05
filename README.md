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
- Шрифт: **TerminusBold14** (8×14 → 60×22) или **TerminusBold18x10** (10×18 → 48×17)

## Установка

### 1. Скопировать файлы

```bash
sudo mkdir -p /usr/local/etc
sudo cp menu.sh /usr/local/bin/menu
sudo cp menu.conf /usr/local/etc/menu.conf
sudo chmod +x /usr/local/bin/menu
```

### 2. Настроить шрифт

Два варианта размера:

| Шрифт | Размер глифа | Экран | Когда использовать |
|-------|-------------|-------|--------------------|
| TerminusBold14 | 8×14 | 60×22 | Мелкий шрифт, больше места |
| TerminusBold18x10 | 10×18 | 48×17 | Крупный шрифт, лучше читается |

**Крупный шрифт (18x10 — рекомендуется):**
```bash
sudo setfont -C /dev/tty1 /usr/share/consolefonts/CyrAsia-TerminusBold18x10.psf.gz
```

**Мелкий шрифт (14):**
```bash
sudo setfont -C /dev/tty1 /usr/share/consolefonts/CyrAsia-TerminusBold14.psf.gz
```

### 3. Сохранить шрифт насовсем

Systemd-сервис `/etc/systemd/system/console-font.service`:

```ini
[Unit]
Description=Set console font for 480x320 display
After=systemd-user-sessions.service getty@tty1.service

[Service]
Type=oneshot
ExecStart=/usr/bin/setfont -C /dev/tty1 /usr/share/consolefonts/CyrAsia-TerminusBold18x10.psf.gz
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable console-font.service
sudo systemctl start console-font.service
```

### 4. Автозапуск меню

```bash
sudo openvt -c 1 -f -- /bin/bash /usr/local/bin/menu
```

## Структура меню (шрифт 18×10, 48×17)

```
                                    05.06.26
                             23:15  CPU - 44°C

                   ==== Pi Zero 2W ====
================================================

 1) Terminal              6) Vim
 2) HTOP                  7) System Info
 3) Python                8) Reboot
 4) MC: Midnight Cmd      9) Poweroff
 5) Nano

================================================

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

Меню читает файл заново на каждом цикле — изменения вступают в силу сразу. Вмещает до 18 программ.

## Исправление терминала

После выхода из программы меню делает `stty sane` — клавиатура и дисплей возвращаются в норму.

### Midnight Commander (mc)

Для выхода из mc без F10: `Esc` → `0`. Скин: [mc-featured-skin](https://github.com/Haidegger22/mc-featured-skin).

## Цветовая схема

| Элемент | ANSI | Цвет |
|---------|------|------|
| Дата/время | `\033[1;37m` | Белый жирный |
| CPU temp | `\033[1;33m` | Жёлтый жирный |
| Меню | default | Зелёный (fbcon) |

## Адаптация под размер шрифта

В скрипте `menu.sh` измени `W=48` на `W=60` для мелкого шрифта, и наоборот. ANSI-позиции времени/температуры тоже подстроить:

```bash
# W=48: дата на 38-й колонке, время на 30-й
printf '\033[1;38H...'
printf '\033[2;30H...'

# W=60: дата на 48-й колонке, время на 43-й
printf '\033[1;48H...'
printf '\033[2;43H...'
```

## Файлы

- `menu.sh` — основной скрипт
- `menu.conf` — конфигурация программ (пример)

## Связанные репозитории

- [zero2w-spotpear-3.5inch-lcd-g-st7796s](https://github.com/Haidegger22/zero2w-spotpear-3.5inch-lcd-g-st7796s) — настройка дисплея
- [mc-featured-skin](https://github.com/Haidegger22/mc-featured-skin) — скин Midnight Commander
- [orangepi-zero3w-hdmi-resolution](https://github.com/Haidegger22/orangepi-zero3w-hdmi-resolution) — HDMI на Orange Pi
