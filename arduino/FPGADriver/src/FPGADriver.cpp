//**********************************************************************
// FPGA SPI Communication Driver
//----------------------------------------------------------------------
// 2023 (c) Davide Nardella
// Released under MIT License
//**********************************************************************
#include "FPGADriver.h"

void FPGAClass::begin(pin_size_t SS_PIN, void* data_out, void* data_in, int BufferSize, uint32_t Clock)
{      
    _SS = SS_PIN;
    copi_data = pbyte(data_out);
    cipo_data = pbyte(data_in);
    BufSize = BufferSize;
    pinMode(_SS, OUTPUT); // set the _SS pin as an output
    digitalWrite(_SS, HIGH); 
    SPI.begin();
    SPIFPGASettings = SPISettings(Clock, MSBFIRST, SPI_MODE0);   
}

int FPGAClass::SendAddress(uint16_t Address)
{
    uint8_t echo[2];
    pword pEcho = pword(&echo);
    echo[1] = SPI.transfer(Address >> 8);
    echo[0] = SPI.transfer(Address & 0x00FF);  
    return (*pEcho << 1 | 1 == Address) ? FPGA_SUCCESS : FPGA_COMERROR;
}

int FPGAClass::Exchange(uint16_t Start, uint16_t Size)
{
    uint16_t StartAddress = (Start + Size) * 8 - 1;
    uint16_t EndByte = Start + Size;
    int Result = FPGA_SUCCESS;

    if (EndByte <= BufSize)
    {
        digitalWrite(_SS, LOW);     
        SPI.beginTransaction(SPIFPGASettings);
        Result = SendAddress(StartAddress);
        if (Result == FPGA_SUCCESS)
            for (int c = EndByte - 1; c >= Start; c--)
                cipo_data[c] = SPI.transfer(copi_data[c]); // Exchange Payload                                
        SPI.endTransaction();
        digitalWrite(_SS, HIGH);     
    }
    else 
        Result = FPGA_PARERROR;

    return Result;
}
