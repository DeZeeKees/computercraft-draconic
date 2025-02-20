-- Draconic Reactor Auto-Stabilizer
-- Adjusts fluxgate settings to maintain stability

-- Configuration
local targetSaturation = 0.50
local minSaturation = 0.10
local targetFieldStrength = 0.20
local targetTemperature = 8000
local outputAdjustment = 1000

-- Peripheral Wrapping
local reactor = peripheral.wrap("right")
local fluxgateInjector = peripheral.wrap("flow_gate_2")
local fluxgateOutput = peripheral.wrap("flow_gate_1")
local monitor = peripheral.wrap("monitor_1")

-- Initialize Monitor
monitor.clear()
monitor.setTextScale(1)

-- Main Loop
while true do
    local info = reactor.getReactorInfo()
    if not info then
        monitor.setCursorPos(1,1)
        monitor.setTextColor(colors.red)
        monitor.write("Error: Unable to fetch reactor data.")
        sleep(1)
        goto continue
    end

    local saturation = info.energySaturation / info.maxEnergySaturation
    local fieldStrength = info.fieldStrength / info.maxFieldStrength
    local temperature = info.temperature

    -- Adjust Output Fluxgate to gradually raise temperature while maintaining minimum saturation
    if temperature < targetTemperature then
        fluxgateOutput.setSignalLowFlow(fluxgateOutput.getSignalLowFlow() + outputAdjustment)
    elseif saturation > targetSaturation then
        fluxgateOutput.setSignalLowFlow(math.max(0, fluxgateOutput.getSignalLowFlow() - outputAdjustment))
    end

    -- Ensure saturation never drops below the minimum threshold, but allow gradual decrease
    if saturation < minSaturation then
        outputAdjustment = math.max(0, outputAdjustment - 100)
    else
        outputAdjustment = math.min(1000, outputAdjustment + 100)
    end

    -- Adjust Injector Fluxgate to maintain field strength
    if fieldStrength < targetFieldStrength then
        fluxgateInjector.setSignalLowFlow(fluxgateInjector.getSignalLowFlow() + 1000)
    elseif fieldStrength > targetFieldStrength then
        fluxgateInjector.setSignalLowFlow(math.max(0, fluxgateInjector.getSignalLowFlow() - 1000))
    end

    -- Display Data on Monitor
    monitor.clear()
    monitor.setCursorPos(1,1)
    monitor.setTextColor(colors.white)
    monitor.write("Draconic Reactor Status")

    monitor.setCursorPos(1,3)
    monitor.write("Temperature: " .. temperature .. " C")
    if temperature >= targetTemperature then
        monitor.setTextColor(colors.red)
        monitor.write(" (High!)")
    else
        monitor.setTextColor(colors.lime)
        monitor.write(" (Stable)")
    end
    
    monitor.setCursorPos(1,5)
    monitor.setTextColor(colors.white)
    monitor.write("Field Strength: " .. math.floor(fieldStrength * 100) .. "%")
    if fieldStrength < targetFieldStrength then
        monitor.setTextColor(colors.red)
        monitor.write(" (Low!)")
    else
        monitor.setTextColor(colors.lime)
        monitor.write(" (Stable)")
    end
    
    monitor.setCursorPos(1,7)
    monitor.setTextColor(colors.white)
    monitor.write("Energy Saturation: " .. math.floor(saturation * 100) .. "%")
    if saturation < targetSaturation then
        monitor.setTextColor(colors.red)
        monitor.write(" (Low!)")
    else
        monitor.setTextColor(colors.lime)
        monitor.write(" (Stable)")
    end

    sleep(0.1)
    ::continue::
end
