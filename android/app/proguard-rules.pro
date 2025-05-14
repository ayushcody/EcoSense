# Keep the missing classes
-keep class com.google.errorprone.annotations.** { *; }
-keep class javax.annotation.concurrent.** { *; }

# Keep Tink classes
-keep class com.google.crypto.tink.** { *; }
-keep class com.google.crypto.tink.proto.** { *; }

# Keep Flutter Secure Storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Additional rules for missing classes
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.concurrent.**
-dontwarn com.google.crypto.tink.**
-dontwarn com.google.crypto.tink.proto.**

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepnames class * implements java.io.Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
} 