import pygame
import math

pygame.init()

# Figures, window settings
WIDTH = 800
HEIGHT = 600
BG_COLOR = (255, 255, 255)

OBJECT_SIZE = 200
OBJECT_COLOR_START = (255, 0, 0)
OBJECT_COLOR_END = (50, 50, 50)
FOCAL_LENGTH = 500

object_position = [0, 0, -FOCAL_LENGTH]
object_velocity = [0, 0, 0]

screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Perspektywa 3D")
clock = pygame.time.Clock()

# Functions
def interpolate_color(start_color, end_color, t):
    r = int(start_color[0] * (1 - t) + end_color[0] * t)
    g = int(start_color[1] * (1 - t) + end_color[1] * t)
    b = int(start_color[2] * (1 - t) + end_color[2] * t)
    return (r, g, b)

def draw_object(position):
    distance = math.sqrt(position[0]**2 + position[1]**2 + position[2]**2)
    object_size = OBJECT_SIZE / (distance / FOCAL_LENGTH)  
    
    t = min(distance / (FOCAL_LENGTH * 3), 1) 
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
            object_velocity[2] = -5  
        elif keys[pygame.K_DOWN]:
            object_velocity[2] = 5  
        else:
            object_velocity[2] = 0
            
        if keys[pygame.K_LEFT]:
            object_velocity[0] = 1  
        elif keys[pygame.K_RIGHT]:
            object_velocity[0] = -1  
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

        object_position[0] += object_velocity[0]
        object_position[1] += object_velocity[1]
        object_position[2] += object_velocity[2]

        screen.fill(BG_COLOR)
        draw_object(object_position)
        pygame.display.flip()
        clock.tick(60)

main()
pygame.quit()