# Fast_inverse_square_root
## Descrpition
In this project we will implement fast inverse square root algorithm using verilog. 
It is pipepline version project with FIFO AXI implementation.
To communicate PC with Zedboard we are using UART.

## Functionality Test
To test funtionality we created simple apps in python.
To run python scripts you need install pygame lib:
```
pip install pygame
```
### ObjectMoving
The Fast Inverse Square Root algorithm is widely used in various applications, including games. In our project, we implemented a simple application that involves moving object in a 3D space. As the object moves deeper into the scene, a specific effect is applied - object is getting darker.

To perform movement, the arrow keys are used, and the spacebar is used to jump.

The Fast Inverse Square Root algorithm calculates distance in 3D to control the size and brightness of objects accordingly. By applying the algorithm, we can dynamically adjust these visual properties based on the object's distance from the viewer, creating a realistic and visually appealing rendering in the 3D environment.

### MoveVector