UVec4 :: struct {
    x: u32 #align VECTOR_ALIGNMENT;
    y: u32;
    z: u32;
    w: u32;

    #overlay(x)
    values: [4]u32;
}

Vec3 :: struct {
    x: float #align VECTOR_ALIGNMENT;
    y: float;
    z: float;

    #overlay(x)
    values: [4]float;

    Make :: (x : float, y : float, z : float) -> Vec3 #foreign JoltC "JPH_Vec3_Make";
}

Vec4 :: struct {
    x: float #align VECTOR_ALIGNMENT;
    y: float;
    z: float;
    w: float;

    #overlay(x)
    values: [4]float;
}

Mat44 :: struct {
    cols: [4]Vec4;
}

DVec3 :: union {
    x: float64 #align DVECTOR_ALIGNMENT;
    y: float64;
    z: float64;

    #overlay(x)
    values: [4]float64;

    Make :: (x : float64, y : float64, z : float64) -> DVec3 #foreign JoltC "JPH_DVec3_Make";
}

DMat44 :: struct {
    cols: [3]Vec4;
    col3: DVec3;
}

Quat :: struct {
    x: float #align VECTOR_ALIGNMENT;
    y: float;
    z: float;
    w: float = 1;

    #overlay(x)
    values: [4]float;
}

#if !#exists(DOUBLE_PRECISION) {
    DOUBLE_PRECISION :: 0;
}
#if !#exists(CROSS_PLATFORM_DETERMINISTIC) {
    CROSS_PLATFORM_DETERMINISTIC :: 0;
}
#if !#exists(FLOATING_POINT_EXCEPTIONS_ENABLED) {
    FLOATING_POINT_EXCEPTIONS_ENABLED :: 0;
}
#if !#exists(PROFILE_ENABLED) {
    PROFILE_ENABLED :: 0;
}
#if !#exists(EXTERNAL_PROFILE) {
    EXTERNAL_PROFILE :: 0;
}
#if !#exists(DEBUG_RENDERER) {
    DEBUG_RENDERER :: 0;
}
#if !#exists(DISABLE_TEMP_ALLOCATOR) {
    DISABLE_TEMP_ALLOCATOR :: 0;
}
#if !#exists(DISABLE_CUSTOM_ALLOCATOR) {
    DISABLE_CUSTOM_ALLOCATOR :: 0;
}
#if !#exists(OBJECT_LAYER_BITS) {
    OBJECT_LAYER_BITS :: 16;
}
#if !#exists(ENABLE_ASSERTS) {
    ENABLE_ASSERTS :: 0;
}
#if !#exists(OBJECT_STREAM) {
    OBJECT_STREAM :: 0;
}

VERSION_FEATURES :: cast(u64, VERSION_FEATURE_BIT_1) | (VERSION_FEATURE_BIT_2 << 1) | (VERSION_FEATURE_BIT_3 << 2) | (VERSION_FEATURE_BIT_4 << 3) | (VERSION_FEATURE_BIT_5 << 4) | (VERSION_FEATURE_BIT_6 << 5) | (VERSION_FEATURE_BIT_7 << 6) | (VERSION_FEATURE_BIT_8 << 7) | (VERSION_FEATURE_BIT_9 << 8) | (VERSION_FEATURE_BIT_10 << 9) | (VERSION_FEATURE_BIT_11 << 10);

JoltC :: #library "libJoltC"; // Replace this with wherever your lib is

#load "jolt.jai";

CheckVersionID :: () {
    LogError :: (message : string, location := #caller_location) {
        info: Log_Info;
        info.source_identifier = context.log_source_identifier;
        info.location          = location;
        info.common_flags      = .ERROR;
        context.logger(message, context.logger_data, info);
    }

    if VERSION_ID != GetJoltVersionID() && !context.handling_assertion_failure {
        bindings_features := cast(EFeatures, VERSION_FEATURES);
        compiled_features := cast(EFeatures, GetJoltVersionID() >> 24);

        LogError("Jolt version ID mismatch between the compiled library and the bindings. The bindings were either generated with a different Jolt version or different feature defines.");

        if (bindings_features & .DoublePrecision) != (compiled_features & .DoublePrecision) {
            if compiled_features & .DoublePrecision {
                LogError("Feature flag DoublePrecision mismatch. The feature was compiled in but not enabled when generating the bindings.");
            } else {
                LogError("Feature flag DoublePrecision mismatch. The feature was turned on when generating the bindings but not when compiling JoltC.");
            }
        }
        if (bindings_features & .CrossPlatformDeterministic) != (compiled_features & .CrossPlatformDeterministic) {
            if compiled_features & .CrossPlatformDeterministic {
                LogError("Feature flag CrossPlatformDeterministic mismatch. The feature was compiled in but not enabled when generating the bindings.");
            } else {
                LogError("Feature flag CrossPlatformDeterministic mismatch. The feature was turned on when generating the bindings but not when compiling JoltC.");
            }
        }
        if (bindings_features & .FloatingPointExceptionsEnabled) != (compiled_features & .FloatingPointExceptionsEnabled) {
            if compiled_features & .FloatingPointExceptionsEnabled {
                LogError("Feature flag FloatingPointExceptionsEnabled mismatch. The feature was compiled in but not enabled when generating the bindings.");
            } else {
                LogError("Feature flag FloatingPointExceptionsEnabled mismatch. The feature was turned on when generating the bindings but not when compiling JoltC.");
            }
        }
        if (bindings_features & .ProfileEnabled) != (compiled_features & .ProfileEnabled) {
            if compiled_features & .ProfileEnabled {
                LogError("Feature flag ProfileEnabled mismatch. The feature was compiled in but not enabled when generating the bindings.");
            } else {
                LogError("Feature flag ProfileEnabled mismatch. The feature was turned on when generating the bindings but not when compiling JoltC.");
            }
        }
        if (bindings_features & .ExternalProfile) != (compiled_features & .ExternalProfile) {
            if compiled_features & .ExternalProfile {
                LogError("Feature flag ExternalProfile mismatch. The feature was compiled in but not enabled when generating the bindings.");
            } else {
                LogError("Feature flag ExternalProfile mismatch. The feature was turned on when generating the bindings but not when compiling JoltC.");
            }
        }
        if (bindings_features & .DebugRenderer) != (compiled_features & .DebugRenderer) {
            if compiled_features & .DebugRenderer {
                LogError("Feature flag DebugRenderer mismatch. The feature was compiled in but not enabled when generating the bindings.");
            } else {
                LogError("Feature flag DebugRenderer mismatch. The feature was turned on when generating the bindings but not when compiling JoltC.");
            }
        }
        if (bindings_features & .DisableTempAllocator) != (compiled_features & .DisableTempAllocator) {
            if compiled_features & .DisableTempAllocator {
                LogError("Feature flag DisableTempAllocator mismatch. The feature was compiled in but not enabled when generating the bindings.");
            } else {
                LogError("Feature flag DisableTempAllocator mismatch. The feature was turned on when generating the bindings but not when compiling JoltC.");
            }
        }
        if (bindings_features & .DisableCustomAllocator) != (compiled_features & .DisableCustomAllocator) {
            if compiled_features & .DisableCustomAllocator {
                LogError("Feature flag DisableCustomAllocator mismatch. The feature was compiled in but not enabled when generating the bindings.");
            } else {
                LogError("Feature flag DisableCustomAllocator mismatch. The feature was turned on when generating the bindings but not when compiling JoltC.");
            }
        }
        if (bindings_features & .ObjectLayer32Bits) != (compiled_features & .ObjectLayer32Bits) {
            if compiled_features & .ObjectLayer32Bits {
                LogError("Feature flag ObjectLayer32Bits mismatch. The feature was compiled in but not enabled when generating the bindings.");
            } else {
                LogError("Feature flag ObjectLayer32Bits mismatch. The feature was turned on when generating the bindings but not when compiling JoltC.");
            }
        }
        if (bindings_features & .EnableAsserts) != (compiled_features & .EnableAsserts) {
            if compiled_features & .EnableAsserts {
                LogError("Feature flag EnableAsserts mismatch. The feature was compiled in but not enabled when generating the bindings.");
            } else {
                LogError("Feature flag EnableAsserts mismatch. The feature was turned on when generating the bindings but not when compiling JoltC.");
            }
        }
        if (bindings_features & .ObjectStream) != (compiled_features & .ObjectStream) {
            if compiled_features & .ObjectStream {
                LogError("Feature flag ObjectStream mismatch. The feature was compiled in but not enabled when generating the bindings.");
            } else {
                LogError("Feature flag ObjectStream mismatch. The feature was turned on when generating the bindings but not when compiling JoltC.");
            }
        }

        context.handling_assertion_failure = true;
        should_break := context.assertion_failed(#location(), "");
        context.handling_assertion_failure = false;

        debug_break();
    }
}
