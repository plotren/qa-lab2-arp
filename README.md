# Лабораторна робота №2. Дослідження засобів канального рівня моделі OSI. Протокол ARP

**Дисципліна:** Тестування та контроль якості (QA) вбудованих систем
**Виконав:** Волянський Максим, група ІК-33
**Варіант QA-завдання:** 2: статичний запис в ARP-таблиці + ping + аналіз трафіку у Wireshark

## Мета
- вивчити отримання MAC-адреси за відомою IP-адресою (протокол ARP);
- навчитися переглядати, видаляти та очищувати ARP-кеш засобами ОС;
- навчитися аналізувати мережний трафік у Wireshark;
- розробити Test Cases для перевірки роботи протоколу ARP.

## Тестове оточення
Два ізольовані мережні простори імен Linux (`pc1`, `pc2`), з'єднані віртуальним Ethernet-кабелем (veth pair):

| Вузол | Інтерфейс | IP | MAC |
|---|---|---|---|
| PC1 (Host) | veth-pc1 | 192.168.10.1/24 | 7e:83:38:fc:b8:cf |
| PC2 (Client) | veth-pc2 | 192.168.10.2/24 | 2e:c0:75:30:29:a5 |

Ubuntu 24.04, Wireshark/tshark 4.2.2, iproute2 6.1.0, net-tools 2.10, arping 2.24.

```bash
sudo ./scripts/setup_network.sh          # створити оточення
sudo ip netns exec pc1 bash              # термінал PC1
sudo ip netns exec pc1 wireshark -i veth-pc1 -k
sudo ./scripts/setup_network.sh clean    # видалити оточення
```

## Структура репозиторію
| Шлях | Вміст |
|---|---|
| `report/` | Звіт (.docx та .pdf) |
| `TEST_CASES.md` | Тест-план і 6 тест-кейсів (TC-ARP-00…05) |
| `scripts/setup_network.sh` | Скрипт налаштування мережного оточення |
| `pcap/` | Захоплений трафік (відкривається у Wireshark) |
| `screenshots/` | Скриншоти терміналу та Wireshark |

### Файли захоплення трафіку
| Файл | Експеримент |
|---|---|
| `01_ping_arp.pcapng` | Отримання MAC за IP: ARP Request/Reply + ping (TC-ARP-00) |
| `02_static.pcapng` | Статичний запис + ping, ARP-запитів від PC1 немає (TC-ARP-02, варіант 2) |
| `03_arp_update.pcapng` | Оновлення кешу через ARP Reply з новою MAC (TC-ARP-01) |
| `04_no_host.pcapng` | ARP-запити до неіснуючого вузла (TC-ARP-03) |
| `05_wrong_static.pcapng` | Статичний запис з помилковою MAC (TC-ARP-04) |

## Результати
Усі 6 тест-кейсів пройдено (PASSED). Деталі у [TEST_CASES.md](TEST_CASES.md) та у звіті.
