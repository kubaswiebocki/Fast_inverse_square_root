import serial
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
def InverSquareRoot(DataTest):
    port = "COM4"
    baudrate = 115200
    DataTest.append(1)
    times = len(DataTest)
    x = []
    try:
        ser = serial.Serial(port, baudrate, timeout=1)
        ser.write(times.to_bytes(4,"big"))
        
        for i in DataTest:
            ser.write(float_to_ieee754(i).to_bytes(4,"big"))

        for i in range(times):
            odebrane_dane = ser.read(4)
            try:
                x.append(int32_to_float(bytes_to_u32(odebrane_dane)[0]))
            except:
                pass

    except serial.SerialException as e:
        print("Błąd portu szeregowego:", str(e))
        return x[1:]
    except KeyboardInterrupt:
        pass
        return x[1:]
    finally:
        if ser and ser.is_open:
            ser.close()
        return x[1:]

ezz = 0.0
azz = 10
while(1):
#Prepare data
################################################
    #DataTest = [1, 1, 1, 2, 2, 2, 3, 3, 3, 5]
    DataTest = []
    ezz = ezz + 0.01
    if(azz == 590):
        azz = 590
    else:
        azz = azz + 10
    print(azz)
    for i in range(azz):
        DataTest.append(ezz)
        
################################################

# Algorithm
################################################
    x = InverSquareRoot(DataTest)
    print(x)