-- Draconic Reactor Auto-Stabilizer
-- Adjusts fluxgate settings to maintain stability

-- Functions

function defineSettings()

    settings.define("draco.target_field_strength", {
        description = "Reactor Target Field Strength",
        default = 0.10,
        type = "number"
    })

    settings.define("draco.min_field_strength", {
        description = "Reactor Minimum Field Strength",
        default = 0.06,
        type = "number"
    })

    settings.define("draco.target_temp", {
        description = "Reactor Maximum Temperature",
        default = 8000,
        type = "number"
    })

    settings.define("draco.max_temp", {
        description = "Reactor Target Temperature",
        default = 8500,
        type = "number"
    })

    settings.define("draco.target_saturation", {
        description = "Reactor Target Saturation",
        default = 0.50,
        type = "number"
    })

    settings.define("draco.min_saturation", {
        description = "Reactor Minimum Saturation",
        default = 0.10,
        type = "number"
    })

    settings.define("draco.startup_output", {
        description = "Reactor Output At Startup",
        default = 4000000,
        type = "number"
    })

    settings.define("draco.startup_input", {
        description = "Reactor Output At Startup",
        default = 1400000,
        type = "number"
    })

    settings.define("draco.param_adjustment_amount", {
        description = "Amount that the input and output parameters get changed",
        default = 1000,
        type = "number"
    })

    settings.define("draco.monitor_id", {
        description = "id of the monitor",
        default = 1,
        type = "number"
    })

    settings.define("draco.input_flowgate_id", {
        description = "Id of input flowgate",
        default = 2,
        type = "number"
    })

    settings.define("draco.output_flowgate_id", {
        description = "Id of output flowgate",
        default = 3,
        type = "number"
    })

end

function monitorDisplay()
    monitor.clear()
    monitor.setCursorPos(1,1)
    monitor.setTextColor(colors.white)
    monitor.write("Draconic Reactor Status")

    monitor.setCursorPos(1,3)
    monitor.write("Temperature: " .. temperature .. " C")
    if temperature >= maxTemperature then
        monitor.setTextColor(colors.red)
        monitor.write(" (High!)")
    else
        monitor.setTextColor(colors.lime)
        monitor.write(" (Stable)")
    end
    
    monitor.setCursorPos(1,5)
    monitor.setTextColor(colors.white)
    monitor.write("Field Strength: " .. math.floor(fieldStrength * 100) .. "%")
    if fieldStrength < minFieldStrength then
        monitor.setTextColor(colors.red)
        monitor.write(" (Low!)")
    else
        monitor.setTextColor(colors.lime)
        monitor.write(" (Stable)")
    end
    
    monitor.setCursorPos(1,7)
    monitor.setTextColor(colors.white)
    monitor.write("Energy Saturation: " .. math.floor(saturation * 100) .. "%")
    if saturation < minSaturation then
        monitor.setTextColor(colors.red)
        monitor.write(" (Low!)")
    else
        monitor.setTextColor(colors.lime)
        monitor.write(" (Stable)")
    end

    monitor.setCursorPos(1,9)
    monitor.setTextColor(colors.white)
    monitor.write("Energy Saturation: " .. status)
end

function regulateReactor()
    -- Adjust Output Fluxgate to gradually raise temperature while maintaining minimum saturation
    if temperature < targetTemperature then
        fluxgateOutput.setSignalLowFlow(fluxgateOutput.getSignalLowFlow() + paramAdjustmentAmount)
    elseif saturation > targetSaturation then
        fluxgateOutput.setSignalLowFlow(math.max(0, fluxgateOutput.getSignalLowFlow() - paramAdjustmentAmount))
    end

    -- Ensure saturation never drops below the minimum threshold, but allow gradual decrease
    if saturation < minSaturation then
        paramAdjustmentAmount = math.max(0, paramAdjustmentAmount - 100)
    else
        paramAdjustmentAmount = math.min(1000, paramAdjustmentAmount + 100)
    end

    -- Adjust Injector Fluxgate to maintain field strength
    if fieldStrength < targetFieldStrength then
        fluxgateInjector.setSignalLowFlow(fluxgateInjector.getSignalLowFlow() + paramAdjustmentAmount)
    elseif fieldStrength > targetFieldStrength then
        fluxgateInjector.setSignalLowFlow(math.max(0, fluxgateInjector.getSignalLowFlow() - paramAdjustmentAmount))
    end
end

function terminal()
    while loopStatus do 
        term.write("> ")
  
        local input = read()

        if input == "exit" then
            loopStatus = false

        elseif input == "clear" then
            term.clear()

        elseif input == "status" then
            print(status)

        elseif (input == "start") then
            if (status == "cold" or status == "cooling" or status == "warming_up") then

                print("Charging reactor")
                reactor.chargeReactor()

                print("Setting in and output to defaults")
                print("Input: " .. tostring(startupInput))
                print("Output: " .. tostring(startupOutput))

                fluxgateInjector.setSignalLowFlow(startupInput)
                fluxgateOutput.setSignalLowFlow(startupOutput)

                while status == "warming_up" do
                    print("attempting to start reactor")
                    reactor.activateReactor()
                    sleep(1)
                end

                print("Starting Draconic Reactor.")
            end
        elseif (input == "stop") then
            if (status == "running" or status == "warming_up") then
                reactor.stopReactor()
                print("Stopping reactor.")
            else
                print("Unable to stop reactor.")
            end
        end
    end
end

function mainLoop()
    while loopStatus do

        info = reactor.getReactorInfo()
        saturation = info.energySaturation / info.maxEnergySaturation
        fieldStrength = info.fieldStrength / info.maxFieldStrength
        temperature = info.temperature
        status = info.status
    
        if monitor then
            monitorDisplay()
        end
    
        if status == "running" then
            regulateReactor()
        end
    
        sleep(0.1)
    end
end

defineSettings()

-- Configuration
targetFieldStrength = settings.get("draco.target_field_strength")
targetTemperature = settings.get("draco.target_temp")
targetSaturation = settings.get("draco.target_saturation")

minFieldStrength = settings.get("draco.min_field_strength")
maxTemperature = settings.get("draco.max_temp")
minSaturation = settings.get("draco.min_saturation")

paramAdjustmentAmount = settings.get("draco.param_adjustment_amount")
startupInput = settings.get("draco.startup_input")
startupOutput = settings.get("draco.startup_output")

-- Peripheral Wrapping
reactor = peripheral.wrap("right")

fluxInputId = tostring(settings.get("draco.input_flowgate_id"))
fluxOutputId = tostring(settings.get("draco.output_flowgate_id"))
monitorId = tostring(settings.get("draco.monitor_id"))

fluxgateInjector = peripheral.wrap("flow_gate_"  .. fluxInputId)
fluxgateOutput = peripheral.wrap("flow_gate_"  .. fluxOutputId)
monitor = peripheral.wrap("monitor_" .. monitorId)

-- Program variables

loopStatus = true

info = reactor.getReactorInfo()
saturation = 0
fieldStrength = 0
temperature = 0
status = ""

-- Clear Terminal before starting program
term.clear()

if not info then
    print("Error: Unable to fetch reactor data.")
    return
end

if not fluxgateInjector or not fluxgateOutput then
    print("Flux input and output not connected properly")
    print("Check the connection to the computer or change the id's using the set command")
    return
end

-- Initialize Monitor
if monitor then
    monitor.clear()
    monitor.setTextScale(1)
else
    print("No monitor connected")
    sleep(5)
end

-- Main Loop
parallel.waitForAny(mainLoop, terminal)

print("program exited")