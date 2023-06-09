import serial
import time
import struct


def float_to_ieee754(num):
    # Konwersja liczby zmiennoprzecinkowej na standard IEEE 754
    binary = struct.pack('>f', num)  # '>f' - big-endian, 'f' - float
    bits = ''.join(format(byte, '08b') for byte in binary)
    return ' '.join([bits[i:i+8] for i in range(0, len(bits), 8)])

# Ustawienia portu szeregowego
port = "COM4"
baudrate = 115200
DataTest = [5,2,3,3.14,4,1,2,2,2,2]

try:
    # Utwórz obiekt Serial do komunikacji
    ser = serial.Serial(port, baudrate, timeout=1)
    print("Nawiązano połączenie przez port szeregowy", port)
    while True:  
        for i in DataTest:
            mystr = float_to_ieee754(i).split()
            for i in mystr:
                #print(i)
                ser.write(i.encode())
            time.sleep(0.01)

        # Odczytaj dane z portu szeregowego
        if ser.in_waiting > 0:
            odebrane_dane = ser.readline().decode().strip()
            print(odebrane_dane)

except serial.SerialException as e:
    print("Błąd portu szeregowego:", str(e))
except KeyboardInterrupt:
    pass
finally:
    # Zamknij połączenie z portem szeregowym
    if ser and ser.is_open:
        ser.close()
        print("Zamknięto połączenie.")