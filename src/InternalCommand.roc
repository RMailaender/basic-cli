interface InternalCommand
    exposes []
    imports []

RunErr : [
    NotFound,
    PermissionDenied,
    TimedOut,
    BrokenPipe,
    InvalidInput,
    Interrupted,
    Unsupported,
    OutOfMemory,
    Unrecognized I32 Str,
]

ProcessOutput : {
    status: [Success, Errored],
    stdout: List U8,
    stderr: List U8,
}

RunResult : [ Ok ProcessOutput, Err RunErr ]