function Terminal()
    while LoopStatus do 
        term.write("> ")
  
        local input = read()

        if input == "exit" then
            LoopStatus = false

        elseif input == "clear" then
            term.clear()

        elseif input == "status" then
            print(status)

        elseif (input == "start") then
            if (status == "cold" or status == "cooling" or status == "warming_up") then

                print("Charging Reactor")
                Reactor.chargeReactor()

                print("Setting in and output to defaults")
                print("Input: " .. tostring(ReactorStartupInput))
                print("Output: " .. tostring(ReactorStartupOutput))

                FluxgateInjector.setSignalLowFlow(ReactorStartupInput)
                FluxgateOutput.setSignalLowFlow(ReactorStartupOutput)

                while status == "warming_up" do
                    print("attempting to start Reactor")
                    Reactor.activateReactor()
                    sleep(1)
                end

                print("Starting Draconic Reactor.")
            end
        elseif (input == "stop") then
            if (status == "running" or status == "warming_up") then
                Reactor.stopReactor()
                print("Stopping Reactor.")
            else
                print("Unable to stop Reactor.")
            end
        end
    end
end

return Terminal