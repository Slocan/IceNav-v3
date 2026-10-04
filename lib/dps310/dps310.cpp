/**
 * @file dps310.cpp
 * @author Jordi Gauchía (jgauchia@jgauchia.com)
 * @brief  DPS310 Barometer Sensor functions - Native ESP-IDF driver
 * @version 0.3.2
 * @date 2026-10
 */

#include "dps310.hpp"

#ifdef DPS310

#include <cmath>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include "esp_log.h"

static const char *TAG = "DPS310";

DPS310_Driver dps = DPS310_Driver();

/**
 * @brief Constructs DPS310 driver with default configuration.
 */
DPS310_Driver::DPS310_Driver() :
    I2CDriverBase(DPS310_ADDRESS),
    c0(0), c1(0), c00(0), c10(0), c01(0), c11(0), c20(0), c21(0), c30(0),
    kT(1572864.0f), kP(1572864.0f)
{
}

/**
 * @brief Reads factory calibration coefficients from sensor.
 */
void DPS310_Driver::readCoefficients()
{
    uint8_t buffer[18];
    readBytes(0x10, buffer, 18);

    c0 = (int16_t)((buffer[0] << 4) | (buffer[1] >> 4));
    if (c0 & 0x0800) c0 |= 0xF000;

    c1 = (int16_t)(((buffer[1] & 0x0F) << 8) | buffer[2]);
    if (c1 & 0x0800) c1 |= 0xF000;

    c00 = (int32_t)((buffer[3] << 12) | (buffer[4] << 4) | (buffer[5] >> 4));
    if (c00 & 0x080000) c00 |= 0xFFF00000;

    c10 = (int32_t)(((buffer[5] & 0x0F) << 16) | (buffer[6] << 8) | buffer[7]);
    if (c10 & 0x080000) c10 |= 0xFFF00000;

    c01 = (int16_t)((buffer[8] << 8) | buffer[9]);
    c11 = (int16_t)((buffer[10] << 8) | buffer[11]);
    c20 = (int16_t)((buffer[12] << 8) | buffer[13]);
    c21 = (int16_t)((buffer[14] << 8) | buffer[15]);
    c30 = (int16_t)((buffer[16] << 8) | buffer[17]);
}

/**
 * @brief Soft-resets the sensor, loads coefficients and starts continuous mode.
 *
 * @details Pressure/temp config uses 1 Hz rate with 2x oversampling (scale
 *          factors kT/kP = 1572864). Continuous background measurement for both.
 *
 * @return true if product ID matches and coefficients become ready.
 */
bool DPS310_Driver::configure()
{
    uint8_t prodId = read8(0x0D);
    if ((prodId & 0xF0) != 0x10)
    {
        // Try alternate address 0x76 if 0x77 fails
        i2cAddr = 0x76;
        prodId = read8(0x0D);
        if ((prodId & 0xF0) != 0x10)
        {
            ESP_LOGE(TAG, "DPS310 not found (Prod ID: 0x%02X)", prodId);
            return false;
        }
    }

    write8(0x0C, 0x09);
    vTaskDelay(pdMS_TO_TICKS(10));

    uint8_t measCfg = 0;
    int retry = 50;
    while (retry-- > 0)
    {
        measCfg = read8(0x08);
        if (measCfg & 0x80)
            break;
        vTaskDelay(pdMS_TO_TICKS(5));
    }

    readCoefficients();

    // Pressure config: 1 measurement/sec, 2x oversampling
    write8(0x06, 0x01);
    // Temp config: MEMS sensor, 1 measurement/sec, 2x oversampling
    write8(0x07, 0x81);
    // Continuous background measurement mode for both pressure and temp
    write8(0x08, 0x07);
    // Shift config (no shift needed for 2x oversampling)
    write8(0x09, 0x00);

    ESP_LOGI(TAG, "DPS310 initialized successfully at 0x%02X", i2cAddr);
    return true;
}

/**
 * @brief Initializes the DPS310 sensor on the standalone I2C bus.
 *
 * @param addr I2C address (default 0x77, falls back to 0x76).
 * @return true if initialization successful, false otherwise.
 */
bool DPS310_Driver::begin(uint8_t addr)
{
    i2cAddr = addr;
    return configure();
}

#ifdef TOUCH_CAPACITIVE
/**
 * @brief Initializes the DPS310 over an I2C bus already owned by LovyanGFX.
 *
 * @param i2cPort I2C port already initialized by LovyanGFX (touch bus).
 * @param addr    I2C address (default 0x77, falls back to 0x76).
 * @return true if initialization successful, false otherwise.
 */
bool DPS310_Driver::beginShared(int i2cPort, uint8_t addr)
{
    I2CDriverBase::beginShared(i2cPort);
    i2cAddr = addr;
    return configure();
}
#endif

/**
 * @brief Reads compensated temperature (°C) and pressure (Pa).
 */
void DPS310_Driver::readAll(float &temp, float &pres)
{
    uint8_t pBuf[3];
    uint8_t tBuf[3];

    readBytes(0x00, pBuf, 3);
    readBytes(0x03, tBuf, 3);

    int32_t rawP = (int32_t)((pBuf[0] << 16) | (pBuf[1] << 8) | pBuf[2]);
    if (rawP & 0x800000) rawP |= 0xFF000000;

    int32_t rawT = (int32_t)((tBuf[0] << 16) | (tBuf[1] << 8) | tBuf[2]);
    if (rawT & 0x800000) rawT |= 0xFF000000;

    float rawT_sc = (float)rawT / kT;
    float rawP_sc = (float)rawP / kP;

    temp = (float)c0 * 0.5f + (float)c1 * rawT_sc;

    pres = (float)c00 + rawP_sc * ((float)c10 + rawP_sc * ((float)c20 + rawP_sc * (float)c30)) +
           rawT_sc * (float)c01 + rawT_sc * rawP_sc * ((float)c11 + rawP_sc * (float)c21);
}

/**
 * @brief Estimates altitude (m) from pressure using the barometric formula.
 */
float DPS310_Driver::readAltitude(float pressure)
{
    return 44330.0f * (1.0f - powf(pressure / 101325.0f, 0.1903f));
}

/**
 * @brief Initializes the DPS310 sensor.
 */
void initDPS310()
{
    dps.begin(DPS310_ADDRESS);
}

#endif
