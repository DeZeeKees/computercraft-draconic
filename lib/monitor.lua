function MonitorDisplay()
    Monitor.clear()
    Monitor.setCursorPos(1,1)
    Monitor.setTextColor(colors.white)
    Monitor.write("Draconic Reactor Status")

    Monitor.setCursorPos(1,3)
    Monitor.write("ReactorTemperature: " .. ReactorTemperature .. " C")
    if ReactorTemperature >= MaxReactorTemperature then
        Monitor.setTextColor(colors.red)
        Monitor.write(" (High!)")
    else
        Monitor.setTextColor(colors.lime)
        Monitor.write(" (Stable)")
    end
    
    Monitor.setCursorPos(1,5)
    Monitor.setTextColor(colors.white)
    Monitor.write("Field Strength: " .. math.floor(ReactorFieldStrength * 100) .. "%")
    if ReactorFieldStrength < MinReactorFieldStrength then
        Monitor.setTextColor(colors.red)
        Monitor.write(" (Low!)")
    else
        Monitor.setTextColor(colors.lime)
        Monitor.write(" (Stable)")
    end
    
    Monitor.setCursorPos(1,7)
    Monitor.setTextColor(colors.white)
    Monitor.write("Energy ReactorSaturation: " .. math.floor(ReactorSaturation * 100) .. "%")
    if ReactorSaturation < MinReactorSaturation then
        Monitor.setTextColor(colors.red)
        Monitor.write(" (Low!)")
    else
        Monitor.setTextColor(colors.lime)
        Monitor.write(" (Stable)")
    end

    Monitor.setCursorPos(1,9)
    Monitor.setTextColor(colors.white)
    Monitor.write("Reactor Status: " .. ReactorStatus)

    Monitor.setCursorPos(1,11)
    Monitor.setTextColor(colors.white)
    Monitor.write("Flux Output:" .. FluxgateOutput.getSignalLowFlow())
    
    Monitor.setCursorPos(1,12)
    Monitor.write("Actual Output: " .. ReactorCurrentOutput)
end

return MonitorDisplay