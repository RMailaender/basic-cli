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