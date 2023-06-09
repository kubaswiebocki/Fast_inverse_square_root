import serial
import time
import struct

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
    binary = struct.pack('>f', num)  #
    bits = int.from_bytes(binary, 'big')
    return bits
def int32_to_float(int_value):
    byte_string = struct.pack('!i', int_value)
    float_value = struct.unpack('!f', byte_string)[0]
    return float_value
# Ustawienia portu szeregowego
def InverSquareRoot(DataTest):
    port = "COM4"
    baudrate = 115200
    times = len(DataTest)
    x = []
    try:
        # Utwórz obiekt Serial do komunikacji
        ser = serial.Serial(port, baudrate, timeout=1)
        #print("Nawiązano połączenie przez port szeregowy", port)
        
        for i in DataTest:
            ser.write(float_to_ieee754(i).to_bytes(4,"big"))

        for i in range(times):
            odebrane_dane = ser.read(4)
            try:
                x.append(int32_to_float(bytes_to_u32(odebrane_dane)[0]))
                #return x
                #print(i, ": ", x)
            except:
                pass

    except serial.SerialException as e:
        print("Błąd portu szeregowego:", str(e))
        return x
    except KeyboardInterrupt:
        pass
        return x
    finally:
        # Zamknij połączenie z portem szeregowym
        if ser and ser.is_open:
            ser.close()
            #print("Zamknięto połączenie.")
        return x

ezz = 0
while(1):
    #DataTest = [1, 1, 1, 2, 2, 2, 3, 3, 3, 5]
    DataTest = []
    ezz = ezz + 1
    for i in range(500):
        DataTest.append(ezz)
    x = InverSquareRoot(DataTest)
    
    if len(x) == len(DataTest):
        print(x[1:])
    else:
        print(DataTest)