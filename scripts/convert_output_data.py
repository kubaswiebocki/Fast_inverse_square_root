import struct

def regular_io(filename):
    with open(filename, mode="r", encoding="utf8") as file_obj:
        text = file_obj.read()
        return text
#####################################################################
# Odczyt danych i konwersja
#####################################################################
x = regular_io("/content/OutputData.mem")

aux = 0
for i in range(int(len(x)/33)):
  aux +=1
  ieee_754_bits = (x[((i)*32+aux) : ((i+1)*32+aux)])
  ieee_754_bytes = int(ieee_754_bits, 2).to_bytes(4, byteorder='big')
  # Konwersja do typu float
  float_number = struct.unpack('!f', ieee_754_bytes)[0]
  print(float_number)  # 1.1
print(int(len(x)/33))
#####################################################################