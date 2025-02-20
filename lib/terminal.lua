local commands = {
    exit = "exit",
    clear = "clear",
    status = "status",
    start = "start",
    stop = "stop",
    help = "help"
}

function Terminal()
    while LoopStatus do 
        term.write("> ")
  
        local input = read()

        if input == commands.exit then
            LoopStatus = false

        elseif input == commands.clear then
            term.setCursorPos(0,0)
            term.clear()

        elseif input == commands.status then
            print(ReactorStatus)

        elseif (input == commands.start) then
            if (ReactorStatus == "cold" or ReactorStatus == "cooling" or ReactorStatus == "warming_up") then

                print("Charging Reactor")
                Reactor.chargeReactor()

                print("Setting in and output to defaults")
                print("Input: " .. tostring(ReactorStartupInput))
                print("Output: " .. tostring(ReactorStartupOutput))

                FluxgateInjector.setSignalLowFlow(ReactorStartupInput)
                FluxgateOutput.setSignalLowFlow(ReactorStartupOutput)

                while ReactorStatus == "warming_up" do
                    print("attempting to start Reactor")
                    Reactor.activateReactor()
                    sleep(1)
                end

                print("Starting Draconic Reactor.")
            end
        elseif (input == commands.stop) then
            if (ReactorStatus == "running" or ReactorStatus == "warming_up") then
                Reactor.stopReactor()
                print("Stopping Reactor.")
            else
                print("Unable to stop Reactor.")
            end
        elseif (input == commands.help) then
            for _, cmd in pairs(commands) do
                print(cmd)
            end
        end
    end
end

return Terminal