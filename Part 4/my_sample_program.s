//This is a sample assembly program for CO224 Lab 5
loadi 4 0x0A
loadi 5 0x01
loadi 6 0x01
loadi 7 0x09
sub 4 4 5
beq 0x01 4 6
j 0xFD
add 1 4 7

