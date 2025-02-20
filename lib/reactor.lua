function RegulateReactor()

    if IsStartingUp and ReactorCurrentOutput > ReactorStartupOutput then
        IsStartingUp = false
    end

    -- ensure the reactor doesn't go kabloowie
    if 
        ReactorTemperature > MaxReactorTemperature 
        or ( not IsStartingUp and FluxgateOutput.getSignalLowFlow() > (ReactorCurrentOutput + MaxReactorOutputOvershoot) )
        or ReactorFieldStrength < MinReactorFieldStrength
    then
        Reactor.stopReactor()
    end

    -- Adjust Output Fluxgate to gradually raise ReactorTemperature while maintaining minimum ReactorSaturation
    if ReactorTemperature < TargetReactorTemperature then
        FluxgateOutput.setSignalLowFlow(FluxgateOutput.getSignalLowFlow() + ReactorOutputAdjustmentAmount)
    elseif ReactorSaturation > TargetReactorSaturation then
        FluxgateOutput.setSignalLowFlow(math.max(0, FluxgateOutput.getSignalLowFlow() - ReactorOutputAdjustmentAmount))
    end

    -- Ensure ReactorSaturation never drops below the minimum threshold, but allow gradual decrease
    if ReactorSaturation < MinReactorSaturation then
        ReactorOutputAdjustmentAmount = math.max(0, ReactorOutputAdjustmentAmount - 100)
    else
        ReactorOutputAdjustmentAmount = math.min(1000, ReactorOutputAdjustmentAmount + 100)
    end

    -- Adjust Injector Fluxgate to maintain field strength
    if ReactorFieldStrength < TargetReactorFieldStrength then
        FluxgateInjector.setSignalLowFlow(FluxgateInjector.getSignalLowFlow() + ReactorOutputAdjustmentAmount)
    elseif ReactorFieldStrength > TargetReactorFieldStrength then
        FluxgateInjector.setSignalLowFlow(math.max(0, FluxgateInjector.getSignalLowFlow() - ReactorOutputAdjustmentAmount))
    end
end

return RegulateReactor