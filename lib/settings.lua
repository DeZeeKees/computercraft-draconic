function DefineSettings()

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
        description = "Reactor Maximum ReactorTemperature",
        default = 8000,
        type = "number"
    })

    settings.define("draco.max_temp", {
        description = "Reactor Target ReactorTemperature",
        default = 8500,
        type = "number"
    })

    settings.define("draco.target_saturation", {
        description = "Reactor Target ReactorSaturation",
        default = 0.50,
        type = "number"
    })

    settings.define("draco.min_saturation", {
        description = "Reactor Minimum ReactorSaturation",
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

    settings.define("draco.output_adjustment_amount", {
        description = "Amount that the output parameter get changed",
        default = 1000,
        type = "number"
    })

    settings.define("draco.input_adjustment_amount", {
        description = "Amount that the input parameter get changed",
        default = 1000,
        type = "number"
    })

    settings.define("draco.monitor_id", {
        description = "id of the Monitor",
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

    settings.define("draco.update_delay", {
        description = "Defines how fast the script runs",
        default = 1,
        type = "number"
    })

end

return DefineSettings