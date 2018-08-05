function test_logging()::Void
    info(string("DEBUG: This is an example debug message."))
    info(string("This is an example info message."))
    warn(string("This is an example warning."))
    return nothing
end
