//**********************************************************************
// FPGA SPI Communication Demo Sketch
//----------------------------------------------------------------------
// 2023 (c) Davide Nardella
// Released under MIT License
//**********************************************************************
#include "FPGADriver.h"

  #define buffersize 256 // This must match with the buffer size into FPGA

  uint8_t copi_data[buffersize];
  uint8_t cipo_data[buffersize];

  FPGAClass FPGA;

// ---------------------------------------------------------------------
// SS SPI pin
// ---------------------------------------------------------------------
// Portenta H7 = PIN_SPI_SS (7)
// Nano Family, UNO Family and GIGA R1 WIFI = 10
// Anyway, you can use whatever GPIO pin you prefer
// ---------------------------------------------------------------------
#ifndef PIN_SPI_SS
    #define PIN_SPI_SS 10
#endif

void setup() {
    // Start with 10 MHz here. Once you are confident with you cabling, you can raise that param
    FPGA.begin(PIN_SPI_SS, &copi_data, &cipo_data, buffersize, 10000000);
    Serial.begin(9600);
    for (int c = 0; c < buffersize; c++)
        copi_data[c] = c;
}

void Dump(void *Buffer, int Length)
{
    int i, cnt=0;
    pbyte buf = pbyte(Buffer);

    for (i = 0; i < Length; i++)
    {        
        cnt++;
        if (buf[i]<0x10)
            Serial.print("0");
        Serial.print(buf[i], HEX);
        Serial.print(" ");
        if (cnt==32)
        {
            cnt=0;
            Serial.println();
        }
    }  
    Serial.println("-----------------------------------------------------------------------------------------------");
}

void loop() {
    // Clear CIPO
    for (int c = 0; c < buffersize; c++)
        cipo_data[c] = 0;
    // Exchanges Data    
    Serial.println(FPGA.Exchange(0, 256));
    // Dump CIPO
    Dump(&cipo_data, 256);
    delay(1000);  
}
