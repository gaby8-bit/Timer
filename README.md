# Timer
This project is developed as part of a university assignment to create a timer in assembling language for P89C51RD2 80C51 8-bit Flash microcontroller family made by Philips.
The initial data are: 
- The display of seconds, minutes and hours is is realized through 6 7-segment displays 
- The 7-segment displays are controlled as follows by 2 8255A circuits: 
o Seconds – PA and PB from the first circuit 8255 (U4) 
o Minutes – PC from the first circuit 8255 (U4) and PA from the second circuit 8255 (U5) 
o Hours – PB and PC from the second circuit 8255 (U5) 
- The time base is obtained with the help of an 8253 circuit (U6) which has a CLK0 input connected to 
rectangular signal generator providing pulse trains with frequency fclk = 1 
MHz. The OUT0 output represents an interrupt request (INT0 input) to the microcontroller. Period 
of the OUT0 signal is T=20msec. 
8255 circuits will be programmed in mode 0 normal outputs (all ports) 
The 8253 circuit, channel 0, will be programmed in mode 1. 
The assigned addresses (in the MDX area) are:

|   Circuit   | Resource | Address |
|:-----------:|:--------:|:-------:|
| 8255_0 (U4) |    PA    |  8000h  |
|             |    PB    |  8001h  |
|             |    PC    |  8002h  |
|             |    CC    |  8003h  |
| 8255_1 (U5) |    PA    |  8004h  |
|             |    PB    |  8005h  |
|             |    PC    |  8006h  |
|             |    CC    |  8007h  |
|  8253 (U6)  |  Canal 0 |  8008h  |
|             |    CC    |  800Bh  |

NOTE: for the simulation in Proteus for the clock generator, the frequency will be set to 1KHz and 
the time constant that must be loaded into counter 0 will have the value CBh. These values ​​are required 
for simulation due to the speed limitations of the simulation environment.
This project includes a Proteus file with the schema simulation and code.



                    
