import serial
import time
import struct
import binascii

def bytes_to_u32(byte_data):
    # Dopasuj rozmiar bajtów do 4 bajtów (32 bitów)
    while len(byte_data) % 4 != 0:
        byte_data = b'\x00' + byte_data

    # Konwertuj bajty na u32
    u32_list = []
    for i in range(0, len(byte_data), 4):
        u32_value = int.from_bytes(byte_data[i:i+4], byteorder='big', signed=False)
        u32_list.append(u32_value)
    
    return u32_list

def float_to_ieee754(num):
    # Konwersja liczby zmiennoprzecinkowej na standard IEEE 754
    binary = struct.pack('>f', num)  # '>f' - big-endian, 'f' - float
    bits = ''.join(format(byte, '08b') for byte in binary)
    return ' '.join([bits[i:i+8] for i in range(0, len(bits), 8)])

# Ustawienia portu szeregowego
port = "COM4"
baudrate = 115200
DataTest = []
for i in range(1500):
    DataTest.append(i+1)

try:
    # Utwórz obiekt Serial do komunikacji
    ser = serial.Serial(port, baudrate, timeout=1)
    print("Nawiązano połączenie przez port szeregowy", port) 
    for i in DataTest:
        ser.write(i.to_bytes(4,"big"))
        #ser.write(i)

    for i in range(1500):
        odebrane_dane = ser.read(4)
        #o = odebrane_dane.decode()
        print(i, ": ", bytes_to_u32(odebrane_dane))
        # b = int.from_bytes(o,"big")
        # s = bin(b)
        # print(i, ": ", s)
       #print(str(odebrane_dane)[2:6])

except serial.SerialException as e:
    print("Błąd portu szeregowego:", str(e))
except KeyboardInterrupt:
    pass
finally:
    # Zamknij połączenie z portem szeregowym
    if ser and ser.is_open:
        ser.close()
        print("Zamknięto połączenie.")