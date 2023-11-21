//**********************************************************************
// FPGA SPI Communication Driver
//----------------------------------------------------------------------
// 2023 (c) Davide Nardella
// Released under MIT License
//**********************************************************************
#ifndef fpgadriver_h
#define fpgadriver_h

#include <Arduino.h>
#include "SPI.h"

#ifndef pin_size_t
  typedef uint8_t pin_size_t;
#endif

#define DEFAULT_SPI_FREQUENCY 20000000

#define FPGA_SUCCESS   0
#define FPGA_COMERROR  1
#define FPGA_PARERROR  2

typedef uint16_t *pword;
typedef uint8_t *pbyte;

class FPGAClass 
{
    
private:
    pin_size_t _SS;
    pbyte copi_data;
    pbyte cipo_data;
    int BufSize;
    SPISettings SPIFPGASettings;
    int SendAddress(uint16_t Address);
public:
    void begin(pin_size_t SS_PIN, void* data_out, void* data_in, int BufferSize, uint32_t Clock = DEFAULT_SPI_FREQUENCY);
    int Exchange(uint16_t Start, uint16_t Size);
};
 




















#endif //fpgadriver_h