# Raspberry Pi Zero 2W — Terminal Menu

Терминальное меню-лаунчер для Pi Zero 2W с дисплеем SpotPear 3.5" (480×320), показывающее время, дату и температуру CPU в реальном времени.

## Возможности

- ⏰ **Время и дата** в правом верхнем углу (белым цветом)
- 🌡️ **Температура CPU** с цветовым выделением (жёлтым)
- 📋 **Меню в 2 колонки** — до 18 пунктов помещается
- 🎨 **Цвета ANSI** — время белым, температура жёлтым
- 🔄 **Автообновление** — время и температура обновляются на каждом цикле

## Требования

- Raspberry Pi Zero 2W (или любой Pi с framebuffer-консолью)
- Дисплей с разрешением **480×320** (SpotPear 3.5" LCD G или аналогичный)
- Шрифт консоли: **8×14** (TerminusBold14 — даёт 60 колонок × 22 строки)
- Утилиты: `htop`, `mc`, `nano`, `vim`, `python3`

## Установка

### 1. Скопировать скрипт

```bash
sudo cp menu.sh /usr/local/bin/menu
sudo chmod +x /usr/local/bin/menu
```

### 2. Настроить шрифт консоли (для 480×320)

```bash
# Установить шрифт 8×14 (60 cols × 22 rows)
sudo setfont -C /dev/tty1 /usr/share/consolefonts/CyrAsia-TerminusBold14.psf.gz

# Сохранить в автозагрузку
echo 'setfont -C /dev/tty1 /usr/share/consolefonts/CyrAsia-TerminusBold14.psf.gz' | sudo tee -a /etc/rc.local
```

### 3. Автозапуск меню при входе

Добавить в `~/.bashrc`:

```bash
# Автозапуск меню на tty1
if [ "$(tty)" = "/dev/tty1" ]; then
    /usr/local/bin/menu
    exit
fi
```

Либо использовать `openvt` для принудительного запуска:

```bash
sudo openvt -c 1 -f -- /bin/bash /usr/local/bin/menu
```

## Структура меню

```
                                          05.06.26
                                 23:15  CPU - 44°C

                    ===== Pi Zero 2W =====

============================================================

  1) Terminal              2) HTOP
  3) Python                4) MC
  5) Nano                  6) Vim
  7) System info           8) Reboot
  9) Poweroff

============================================================

> _
```

## Добавление новых программ

Меню в 2 колонки, вмещает до 18 пунктов (9 строк × 2). Чтобы добавить:

```bash
# В секции вывода добавить строку:
printf '  %-28s %s\n' 'N) MyApp' 'M) OtherApp'

# В case добавить обработчик:
N) myapp;;
```

## Цветовая схема

| Элемент | ANSI-код | Цвет |
|---------|----------|------|
| Дата/время | `\033[1;37m` | Белый жирный |
| Температура | `\033[1;33m` | Жёлтый жирный |
| Меню | по умолчанию | Зелёный (fbcon) |
| Сброс | `\033[0m` | — |

## Файлы

- `menu.sh` — основной скрипт меню

## Связанные репозитории

- [zero2w-spotpear-3.5inch-lcd-g-st7796s](https://github.com/Haidegger22/zero2w-spotpear-3.5inch-lcd-g-st7796s) — настройка дисплея SpotPear 3.5" на Zero 2W
- [orangepi-zero3w-hdmi-resolution](https://github.com/Haidegger22/orangepi-zero3w-hdmi-resolution) — HDMI 1360×768 на Orange Pi Zero 3W
