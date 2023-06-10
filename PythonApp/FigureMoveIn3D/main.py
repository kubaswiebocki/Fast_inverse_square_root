import pygame
import math
import serial
import struct

pygame.init()

# Figures, window settings
WIDTH = 800
HEIGHT = 600
BG_COLOR = (255, 255, 255)

OBJECT_SIZE = 350
OBJECT_COLOR_START = (0, 255, 0)
OBJECT_COLOR_END = (10, 10, 10)
FOCAL_LENGTH = 400

object_position = [0, 0, -FOCAL_LENGTH]
object_velocity = [0, 0, 0]

screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Sterowanie obiekt z wykorzystaniem Fast Inverse Square Root algorithm")
clock = pygame.time.Clock()

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

def interpolate_color(start_color, end_color, t):
    r = int(start_color[0] * (1 - t) + end_color[0] * t)
    g = int(start_color[1] * (1 - t) + end_color[1] * t)
    b = int(start_color[2] * (1 - t) + end_color[2] * t)
    return (r, g, b)
def draw_object(position):
    x = position[0]**2 + position[1]**2 + position[2]**2
    #distance = math.sqrt(x)
    distance = InverSquareRoot([x])[0]
    object_size = FOCAL_LENGTH* OBJECT_SIZE * distance
    
    t = min(1/distance / (FOCAL_LENGTH * 4), 1)
    object_color = interpolate_color(OBJECT_COLOR_START, OBJECT_COLOR_END, t)

    if position[2] + FOCAL_LENGTH != 0: 
        object_pos_x = position[0] * FOCAL_LENGTH / (position[2] + FOCAL_LENGTH) + WIDTH // 2
        object_pos_y = position[1] * FOCAL_LENGTH / (position[2] + FOCAL_LENGTH) + HEIGHT // 2
    else:
        object_pos_x = WIDTH // 2
        object_pos_y = HEIGHT // 2

    if 0 <= object_pos_x < WIDTH and 0 <= object_pos_y < HEIGHT: 
        pygame.draw.circle(screen, object_color, (int(object_pos_x), int(object_pos_y)), int(object_size))
def main():
    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        keys = pygame.key.get_pressed()
        
        if keys[pygame.K_UP]:
            object_velocity[2] = -6  
        elif keys[pygame.K_DOWN]:
            object_velocity[2] = 6  
        else:
            object_velocity[2] = 0
            
        if keys[pygame.K_LEFT]:
            object_velocity[0] = 2  
        elif keys[pygame.K_RIGHT]:
            object_velocity[0] = -2  
        else:
            object_velocity[0] = 0

        if keys[pygame.K_SPACE]:
            if object_position[1] == 0:  
                object_velocity[1] = 10  
        else:
            if object_position[1] > 0:  
                object_velocity[1] = -10  
            else:
                object_velocity[1] = 0

        if object_position[2] > -500:
            object_position[0] -= object_velocity[0]
            object_position[2] = -500
        else:
            object_position[0] += object_velocity[0]
            object_position[2] += object_velocity[2]
        object_position[1] += object_velocity[1]
        
        
        screen.fill(BG_COLOR)
        draw_object(object_position)
        font = pygame.font.SysFont(None, 24)
        text_x = font.render("Position X: {:d}".format(object_position[0]), True, (0, 0, 0))
        text_y = font.render("Position Y: {:d}".format(object_position[1]), True, (0, 0, 0))
        text_z = font.render("Position Z: {:d}".format(object_position[2]), True, (0, 0, 0))
        screen.blit(text_x, (10, 10))
        screen.blit(text_y, (10, 30))
        screen.blit(text_z, (10, 50))
        pygame.display.flip()
        clock.tick(60)

main()
pygame.quit()