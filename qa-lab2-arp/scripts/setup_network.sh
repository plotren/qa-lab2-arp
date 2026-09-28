#!/bin/bash
# Лабораторна робота №2. Протокол ARP.
# Створення тестового мережного оточення: два ізольовані "комп'ютери"
# (network namespaces pc1 і pc2), з'єднані віртуальним Ethernet-кабелем (veth pair).
# Запуск: sudo ./setup_network.sh        Видалення: sudo ./setup_network.sh clean
set -e

if [ "$1" = "clean" ]; then
  ip netns del pc1 2>/dev/null || true
  ip netns del pc2 2>/dev/null || true
  echo "Оточення видалено"; exit 0
fi

# 1. Два мережні простори імен = два незалежні мережні стеки (свої інтерфейси, ARP-кеш, маршрути)
ip netns add pc1
ip netns add pc2

# 2. Пара віртуальних Ethernet-інтерфейсів: кадр, відправлений в один кінець, виходить з іншого
ip link add veth-pc1 type veth peer name veth-pc2
ip link set veth-pc1 netns pc1
ip link set veth-pc2 netns pc2

# 3. IP-адреси в одній підмережі 192.168.10.0/24
ip -n pc1 addr add 192.168.10.1/24 dev veth-pc1
ip -n pc2 addr add 192.168.10.2/24 dev veth-pc2

# 4. Піднімаємо інтерфейси
ip -n pc1 link set lo up;  ip -n pc1 link set veth-pc1 up
ip -n pc2 link set lo up;  ip -n pc2 link set veth-pc2 up

# 5. Порожні ARP-кеші на старті
ip -n pc1 neigh flush all
ip -n pc2 neigh flush all

echo "Готово. PC1: 192.168.10.1 (veth-pc1), PC2: 192.168.10.2 (veth-pc2)"
echo "Термінал PC1:  sudo ip netns exec pc1 bash"
echo "Термінал PC2:  sudo ip netns exec pc2 bash"
echo "Wireshark на PC1: sudo ip netns exec pc1 wireshark -i veth-pc1 -k"
