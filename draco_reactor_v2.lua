-- Draconic Reactor Auto-Stabilizer
-- Adjusts fluxgate settings to maintain stability

DefineSettings = require("lib.settings")
MonitorDisplay = require("lib.monitor")
RegulateReactor = require("lib.reactor")
Terminal = require("lib.terminal")

function MainLoop()
    while LoopStatus do

        ReactorInfo = Reactor.getReactorInfo()
        ReactorSaturation = ReactorInfo.energySaturation / ReactorInfo.maxEnergySaturation
        ReactorFieldStrength = ReactorInfo.fieldStrength / ReactorInfo.maxFieldStrength
        ReactorTemperature = ReactorInfo.temperature
        ReactorStatus = ReactorInfo.status
        ReactorCurrentOutput = ReactorInfo.generationRate
    
        if ReactorStatus == "running" then
            RegulateReactor()
        end

        if Monitor then
            MonitorDisplay()
        end
    
        sleep(ReactorUpdateDelay)
    end
end

-- Load settings from .settings file
DefineSettings()

-- Configuration
TargetReactorFieldStrength = settings.get("draco.target_field_strength")
TargetReactorTemperature = settings.get("draco.target_temp")
TargetReactorSaturation = settings.get("draco.target_saturation")

MinReactorFieldStrength = settings.get("draco.min_field_strength")
MaxReactorTemperature = settings.get("draco.max_temp")
MinReactorSaturation = settings.get("draco.min_saturation")
MaxReactorOutputOvershoot = settings.get("draco.max_output_overshoot")

ReactorOutputAdjustmentAmount = settings.get("draco.output_adjustment_amount")
ReactorInputAdjustmentAmount = settings.get("draco.draco.input_adjustment_amount")
ReactorStartupInput = settings.get("draco.startup_input")
ReactorStartupOutput = settings.get("draco.startup_output")

ReactorUpdateDelay = settings.get("draco.update_delay")

-- Peripheral Wrapping
Reactor = peripheral.wrap("right")

FluxInputId = tostring(settings.get("draco.input_flowgate_id"))
FluxOutputId = tostring(settings.get("draco.output_flowgate_id"))
MonitorId = tostring(settings.get("draco.monitor_id"))

FluxgateInjector = peripheral.wrap("flow_gate_"  .. FluxInputId)
FluxgateOutput = peripheral.wrap("flow_gate_"  .. FluxOutputId)
Monitor = peripheral.wrap("monitor_" .. MonitorId)

-- Program variables

LoopStatus = true

ReactorInfo = Reactor.getReactorInfo()
ReactorSaturation = 0
ReactorFieldStrength = 0
ReactorTemperature = 0
ReactorStatus = ""
ReactorCurrentOutput = 0

-- Clear Terminal before starting program
term.clear()

if not ReactorInfo then
    print("Error: Unable to fetch Reactor data.")
    return
end

if not FluxgateInjector or not FluxgateOutput then
    print("Flux input and output not connected properly")
    print("Check the connection to the computer or change the id's using the set command")
    return
end

-- Initialize Monitor
if Monitor then
    Monitor.clear()
    Monitor.setTextScale(1)
else
    print("No Monitor connected")
    sleep(5)
end

-- Main Loop
parallel.waitForAny(MainLoop, Terminal)

print("program exited")