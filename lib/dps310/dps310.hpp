/**
 * @file dps310.hpp
 * @author Jordi Gauchía (jgauchia@jgauchia.com)
 * @brief  DPS310 Barometer Sensor functions - Native ESP-IDF driver
 * @version 0.3.2
 * @date 2026-10
 */

#pragma once

#ifdef DPS310

#define ENABLE_TEMP

#include "sdkconfig.h"
#include "i2c_espidf.hpp"
#include "i2c_driver_base.hpp"
#include <cstdint>

#define DPS310_ADDRESS 0x77

class DPS310_Driver : public I2CDriverBase
{
    private:
        int16_t c0;
        int16_t c1;
        int32_t c00;
        int32_t c10;
        int16_t c01;
        int16_t c11;
        int16_t c20;
        int16_t c21;
        int16_t c30;

        float kT;
        float kP;

        void readCoefficients();
        bool configure();

    public:
        DPS310_Driver();
        bool begin(uint8_t addr = DPS310_ADDRESS);
        #ifdef TOUCH_CAPACITIVE
            bool beginShared(int i2cPort, uint8_t addr = DPS310_ADDRESS);
        #endif
        float readAltitude(float pressure);
        void readAll(float &temp, float &pres);
};

extern DPS310_Driver dps;

void initDPS310();

#endif
