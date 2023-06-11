import pygame
import math
import struct
import serial

# Functions
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

# Window, app settings
pygame.init()
screen = pygame.display.set_mode((800, 600))
font = pygame.font.Font(None, 25)
running = True

grid_spacing = 100
start_point = (400, 300)
vector_length = 0
vector_lengthFisr = 0
vector_angle = 0
vector_angleFisr = 0
mouse_pos = [0,0]

# Main code
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.MOUSEBUTTONDOWN:
            if event.button == 1:
                mouse_pos = pygame.mouse.get_pos()
                dx = mouse_pos[0] - start_point[0]
                dy = mouse_pos[1] - start_point[1]
                
                vector_length = math.sqrt(dx**2 + dy**2)
                vector_lengthFisr = 1/InverSquareRoot([dx**2 + dy**2])[0]
                vector_angle = math.atan2(dy, dx)
                vector_angleFisr = math.atan2(dy, dx)
    screen.fill((0, 0, 0))
    
    end_point = (
        start_point[0] + (vector_length * math.cos(vector_angle)),
        start_point[1] + vector_length * math.sin(vector_angle)
    )
    end_pointFisr = (
        start_point[0] + (vector_lengthFisr * math.cos(vector_angleFisr)),
        start_point[1] + vector_lengthFisr * math.sin(vector_angleFisr)
    )

    for x in range(0, screen.get_width(), grid_spacing):
        pygame.draw.line(screen, (255, 255, 255), (x, 0), (x, screen.get_height()))

    for y in range(0, screen.get_height(), grid_spacing):
        pygame.draw.line(screen, (255, 255, 255), (0, y), (screen.get_width(), y))
    
    pygame.draw.line(screen, (0, 255, 0), start_point, end_point, 2)
    pygame.draw.line(screen, (255, 0, 0), start_point, end_pointFisr, 2)
    
    input_coords = font.render(f"Input coords -> X: {mouse_pos[0]:.2f} Y: {mouse_pos[1]:.2f}", True, (255, 255, 255))
    sqrt_calc = font.render(f"SQRT -> Vector Length: {vector_length:.2f} calc coords: X: {end_point[0]:.2f} Y: {end_point[1]:.2f}", True, (0, 255, 0))
    fisr_calc = font.render(f"FISR -> Vector Length: {vector_lengthFisr:.2f} calc coords: X: {end_pointFisr[0]:.2f} Y: {end_pointFisr[1]:.2f}", True, (255, 0, 0))
    diff_vectors = font.render(f"Vector Length calculation error -> {abs(vector_length-vector_lengthFisr):.6f}", True, (255, 255, 255))
    screen.blit(input_coords, (10, 10))
    screen.blit(sqrt_calc, (10, 40))
    screen.blit(fisr_calc, (10, 70))
    screen.blit(diff_vectors, (320, 10))

        
    pygame.display.flip()

pygame.quit()