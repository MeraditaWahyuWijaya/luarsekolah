plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.luarsekolah"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        // WAJIB: Untuk memperbaiki error flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.luarsekolah"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Sementara pakai debug agar bisa build release
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // WAJIB untuk mendukung Java 8+ API yang dipakai flutter_local_notifications
   coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")


    // Kotlin stdlib (biasanya otomatis)
    implementation("org.jetbrains.kotlin:kotlin-stdlib")
}

flutter {
    source = "../.."
}
