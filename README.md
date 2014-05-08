#Flappy Bird FPGA 

##Objective 
Our objective was to recreate the game Flappy Bird, with an emphasis on replicating the physics 
component of the gameplay. The design was implemented through Verilog code, to be synthesized and 
downloaded onto a Nexys­3 Spartan 6 FPGA board. The game is displayed using the Nexys board’s VGA 
output and controlled via button inputs. 
 
##Design 
Our Verilog version of Flappy Bird consists of four core modules that fuel the game’s 
functionality. The modules each receive the same Start, Stop and Ack signals, which synchronize their 
functionality when a player starts, loses, and restarts the game. 

The X_RAM_NOREAD module contains a small state machine that manages the x­coordinate 
output of the five pipe obstacles. The module contains two arrays, each of five 10­bit numbers; one array 
holds the 10­bit x­coordinates of the pipes’ left edge, and the other holds the right edge coordinates. When 
the machine is reset to the Initial state, the arrays are set to their hard­coded initial values. When the 
player presses start, the state moves to the Count state, which decrements each value in the arrays by 
one, thus gradually moving the pipes left along the screen during gameplay. The module outputs ten 10­bit 
values: five represent each value in the left­edge array, and five represent each value in the right­edge 
array.  

The module also outputs an array index out_pipe, which is the index of the pipe which the bird is 
approaching (referred to as the pipe in scope). In the Initial state, this index is initialized to the third pipe, 
which is immediately to the right of the bird when gameplay begins. During the Count state, as the pipes 
decrement in position, the coordinates of the pipe at index out_pipe are checked to determine if the pipe 
has passed the bird’s x­position. If the pipe has passed the bird, out_pipe is incremented to represent the 
next pipe to be in scope. Additionally, each time out_pipe is increments, the player’s score is incremented. 
When the player hits an obstacle, the state machine receives an input signal to stop. It transitions 
to the Stop state, where the decrementation of the coordinates stops and an Ack signal is awaited. 
 
Y_ROM is a modified ROM that outputs the y­coordinates of each pipe’s top edge and bottom 
edge. The output is based on the index from X_RAM_NOREAD. The Y_ROM contains five hard­coded 
heights for the pipes, which rotate depending on which pipe is in scope. 
 
The flight_physics module outputs the bird’s x and y coordinates. The state machine contains 
three states: Initial, Flight, and Stop. Upon reset, in the Initial state, the bird’s x and y coordinates are set. 
When the player presses Start, the machine moves to the Flight state. 

In the Flight state, only the bird’s y­coordinates change; the x­coordinates are always constant. 
This state utilizes the input of a button press to change the bird’s position when it jumps. To ensure that the 
player cannot just hold down the button to increase the bird’s position, there is an internal signal that 
checks whether or not the button press signal was high for consecutive clocks. The signal J is initialized to 0, and when the button press is received J is set to 1. A button press is not recognized when J is 1. Any
time a button press is not being received, the J is reset to 0.

To calculate the bird’s movements, the module contains two 10­bit registers named PositiveSpeed 
and NegativeSpeed. When a button press is accepted, NegativeSpeed is set to zero, and PositiveSpeed is 
set to a constant value FLIGHT_VELOCITY to represent some amount of upward movement, in pixels 
per clock. If there is no incoming button press, then the machine modifies the bird’s velocity to account for 
gravity. Each clock that the jump button is not pressed, the GRAVITY constant is subtracted from 
PositiveSpeed to make the bird’s positive velocity become slower and slower as time goes on. If the result 
of subtracting GRAVITY from PositiveSpeed is negative, the value is added to NegativeSpeed. Each 
subsequent clock that NegativeSpeed is positive and PositiveSpeed is 0, GRAVITY is added to 
NegativeSpeed to make the bird fall faster and faster. 

In actually modifying the bird’s position each clock, one of two scenarios can occur: (1) 
PositiveSpeed is positive and NegativeSpeed is 0, meaning the bird is rising; (2) NegativeSpeed is positive 
and PositiveSpeed is 0, meaning the bird is falling. In the first scenario, PositiveSpeed is subtracted from 
the bird’s y position to make it rise in the display. In the second, NegativeSpeed is added to the position to 
make the bird fall.  
 
The obstacle_logic module handles checking whether the bird has hit an obstacle during gameplay. 
It takes as input the outputs from the aforementioned modules: the bird’s x­ and y­ coordinates, as well as 
the x­ and y­ coordinates of the pipe in scope. The state machine structure is also similar to the previous 
modules, with Initial, Check, and Lose (Stop) states. The Initial state merely awaits the Start signal in 
order to begin the Check state. In the Check state, the bird’s coordinates and the pipe coordinates are 
compared for overlap to check if the bird and pipe have collided. If they do collide, the machine moves to 
the Lose state. This modules Lose state is a signal for the other modules to move to their Stop states. 
 
The vga_top module contains logic to output the game display via VGA, and display the user’s 
score simultaneously via the SSD’s on the Nexys3 and a simulated SSD on screen.  To display the bird, 
the CounterX and CounterY values from the provided hvsync_generator are compared to the bird’s 
current coordinates, generated by flight_physics.  The result of this comparison generates an Red signal. 
To display the pipes, the counter values are compared to the horizontal and vertical edges of the pipes as 
generated by the X and Y roms; the result of this comparison generates a Green signa..  Special care is 
taken to ensure that pixels occupied by either the score display and bird are not also written green, which 
would result in a blended color.   

When the player loses the game, the display flashes blue and waits a short duration, 
then accepts an Ack signal from a button press to restart the game. A short always block toggles a 
Flash_Blue register; this is used to generate the Blue output. 
 
Similar code is used to output the user’s score to both the physical SSD and the simulated SSD in 
the upper left corner of the game display.  Wires representing ‘segments’ of the on­screen number are 
simply 5x50 pixel regions on the screen.  An always block with a switch­case statement determines which 
segments should be filled in; the segments are ORed and this resulting VGA_NUM_OUTPUT is also 
used to generate the Red signal.  Likewise, for the physical SSD, the case statement selects the proper 
value for SSD_CATHODES that illuminates the proper segments on the display.   
 
##Challenges 
A challenge we faced was deciding on the best approach to passing the coordinates from one 
module to another. For the bird, we initially only produced and output one x­ and y­ coordinate to pinpoint 
its center. For the pipes, we initially only produced one x­ coordinate for one vertical edge and one y­ 
coordinate for one horizontal edge. We planned to pass these single coordinates from the X_RAM and 
Y_ROM modules to the other modules, where we would later calculate the other coordinates according to 
the module’s need. This was a bad design because it was prone to error, since several modules required 
the same coordinate information, but would be calculating the coordinates separately. We decided to 
output all of the boundary coordinates for the bird and the pipes from their respective modules which, 
while making the RAM and ROM bulkier, make information more consistent. 

The flight physics were a challenge, but not necessarily a struggle. The fact that the bird stays at 
one x­coordinate for the entirety of the game made calculating the movements much simpler than initially 
imagined. After that realization, the physics was just a matter of constantly applying gravity to the bird to 
mimic the constant pull of gravity in real life. The bouncing effect of the bird’s jumps are a natural result 
of applying gravity. 

Earlier versions of the game utilized a 3­bit VGA output with one signal each for red, green, and 
blue.  This resulted in a dim display.  Switching to 8­bit VGA allowed the display to be crisp and bright. 
  
##Modifications 
Compared to the original design of Flappy Bird, our version has several aspects that make it easier 
to play ­ the user sees 4 pipes on screen, versus one or two, making it easier to ‘plan ahead’ and navigate 
obstacles.  The layout could be changed to reflect the original game. Additionally, the implementation of 
random obstacles heights would bring our version closer to the original game. Currently, the score display 
is a single digit only; improvements could be made to show double digit scores. 
