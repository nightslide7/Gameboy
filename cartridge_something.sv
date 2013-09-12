typedef struct packed {
   logic GND //Ground, pin 31, ROM 16, MBC 12
   logic AUDIOIN //Almost certainly not used, pin 30
   logic n_RST //Reset, asserted low, pin 29, MBC 10
   logic D7 //Data bit 7, pin 28, ROM 21
   logic D6 //Data bit 6, pin 27, ROM 20
   logic D5 //Data bit 5, pin 26, ROM 19
   logic D4 //Data bit 4, pin 25, ROM 18, MBC 5
   logic D3 //Data bit 3, pin 24, ROM 17, MBC 4
   logic D2 //Data bit 2, pin 23, ROM 15, MBC 3
   logic D1 //Data bit 1, pin 22, ROM 14, MBC 2
   logic D0 //Data bit 0, pin 21, ROM 13, MBC 1
   logic A15 //Address 15, pin 20, ROM 22, MBC 21
   logic A14 //Address 15, pin 19,         MBC 20
   logic A13 //Address 15, pin 18, ROM 20, MBC 19
   logic A12 //Address 15, pin 17, ROM 4
   logic A11 //Address 15, pin 16, ROM 25
   logic A10 //Address 15, pin 15, ROM 23
   logic A9 //Address 15, pin 14, ROM 26
   logic A8 //Address 15, pin 13, ROM 27
   logic A7 //Address 15, pin 12, ROM 5
   logic A6 //Address 15, pin 11, ROM 6
   logic A5 //Address 15, pin 10, ROM 7
   logic A4 //Address 15, pin 9, ROM 8
   logic A3 //Address 15, pin 8, ROM 9
   logic A2 //Address 15, pin 7, ROM 10
   logic A1 //Address 15, pin 6, ROM 11
   logic A0 //Address 15, pin 5, ROM 12
   logic n_CS //SRAM select, asserted low, pin 4, MBC 23
   logic n_RD //Read enable, asserted low, pin 3, ROM 24, MBC 11
   logic n_WR //Write enable, asserted low, pin 2, MBC 22
   logic PHI //CPU Clock?, pin 1, not used
   logic VDD //+5 Volts, pin 0, ROM 32, MBC 24
   } pinout;


module cartridge_interface
  (input pinout pins,
   output ????);
   