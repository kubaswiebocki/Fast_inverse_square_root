from turtle import distance
import pygame
from pygame.locals import *
import numpy as np

def initialize_vertices(scale_factor):
    return np.array([
        [-1, -1, -1],
        [1, -1, -1],
        [1, 1, -1],
        [-1, 1, -1],
        [-1, -1, 1],
        [1, -1, 1],
        [1, 1, 1],
        [-1, 1, 1]
    ]) * scale_factor
def transform_vertices(vertices):
    distances = np.linalg.norm(vertices - reference_point, axis=1)
    inv_sqrt_distances = 1 / np.sqrt(distances)
    transformed_vertices = vertices * inv_sqrt_distances[:, np.newaxis]
    return transformed_vertices


pygame.init()
WIDTH = 800
HEIGHT = 600
BG_COLOR = (255, 255, 255)
reference_point = np.array([0, 0, 0])
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Zastosowanie algorytmu Fast Inverse Square Root w obrocie figury")

vertices = None
edges = [
    (0, 1), (1, 2), (2, 3), (3, 0),
    (4, 5), (5, 6), (6, 7), (7, 4),
    (0, 4), (1, 5), (2, 6), (3, 7)]

clock = pygame.time.Clock()

def main_loop(scale_factor):
    global vertices
    angle_x = 0
    angle_y = 0
    rotation_speed = 0.01
    scale_multiple_factor = 1
    while True:
        for event in pygame.event.get():
            if event.type == QUIT:
                pygame.quit()
                return
            if event.type == KEYDOWN:
                if event.key == K_1 or event.key == K_KP1:
                    scale_multiple_factor = 1
                if event.key == K_2 or event.key == K_KP2:
                    scale_multiple_factor = 10
                if event.key == K_3 or event.key == K_KP3:
                    scale_multiple_factor = 100
                if event.key == K_4 or event.key == K_KP4:
                    scale_multiple_factor = 1000
                if event.key == K_5 or event.key == K_KP5:
                    scale_multiple_factor = 10000
                if event.key == K_PLUS or event.key == K_KP_PLUS:
                    scale_factor += scale_multiple_factor
                if event.key == K_MINUS or event.key == K_KP_MINUS: 
                    scale_factor -= scale_multiple_factor
                if scale_factor >= 100000:
                    scale_factor = 100000
                    vertices = initialize_vertices(scale_factor)
                elif scale_factor <= 1:
                    scale_factor = 1
                    vertices = initialize_vertices(scale_factor)
                else:
                    vertices = initialize_vertices(scale_factor)

        keys = pygame.key.get_pressed()
        if keys[K_LEFT]:
            angle_y += rotation_speed
        if keys[K_RIGHT]:
            angle_y -= rotation_speed
        if keys[K_UP]:
            angle_x -= rotation_speed
        if keys[K_DOWN]:
            angle_x += rotation_speed

        screen.fill(BG_COLOR)

        rotation_matrix_x = np.array([
            [1, 0, 0],
            [0, np.cos(angle_x), -np.sin(angle_x)],
            [0, np.sin(angle_x), np.cos(angle_x)]
        ])

        rotation_matrix_y = np.array([
            [np.cos(angle_y), 0, np.sin(angle_y)],
            [0, 1, 0],
            [-np.sin(angle_y), 0, np.cos(angle_y)]
        ])

        rotated_vertices = np.dot(vertices, rotation_matrix_x)
        rotated_vertices = np.dot(rotated_vertices, rotation_matrix_y)

        transformed_vertices = transform_vertices(rotated_vertices)
        for edge in edges:
            start_point = transformed_vertices[edge[0]]
            end_point = transformed_vertices[edge[1]]
            pygame.draw.line(screen, (0, 0, 0), (start_point[0] + WIDTH / 2, start_point[1] + HEIGHT / 2),
                             (end_point[0] + WIDTH / 2, end_point[1] + HEIGHT / 2), 2)


        font = pygame.font.SysFont(None, 24)
        text = font.render("Scale Factor: {:.1f}".format(scale_factor), True, (0, 0, 0))
        screen.blit(text, (10, 10))

        pygame.display.flip()
        clock.tick(60)


scale_factor = 2000
vertices = initialize_vertices(scale_factor)
main_loop(scale_factor)