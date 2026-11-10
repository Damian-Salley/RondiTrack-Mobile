import java.util.Base64

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "za.co.damiansalley.ronditrack_mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "za.co.damiansalley.ronditrack_mobile"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
        }
        create("prod") { dimension = "environment" }
    }

    // Reject a config for a different native flavour before packaging an APK.
    val dartDefines = (project.findProperty("dart-defines") as? String)
        ?.split(",")?.map { String(Base64.getDecoder().decode(it)) }.orEmpty()
    val configuredFlavor = dartDefines.firstOrNull { it.startsWith("FLAVOR=") }
        ?.substringAfter("=")
    val configuredUrl = dartDefines.firstOrNull { it.startsWith("API_BASE_URL=") }
        ?.substringAfter("=")
    gradle.taskGraph.whenReady {
        productFlavors.forEach { flavor ->
            val buildsFlavor = allTasks.any {
                it.project == project &&
                    it.name.contains(flavor.name.replaceFirstChar(Char::uppercase)) &&
                    (it.name.startsWith("assemble") || it.name.startsWith("bundle"))
            }
            if (buildsFlavor) {
                require(configuredFlavor == flavor.name && !configuredUrl.isNullOrBlank()) {
                    "Use --dart-define-from-file=config/${flavor.name}.json with --flavor ${flavor.name}"
                }
            }
        }
    }

    buildTypes {
        release {
            // Debug signing is used for assignment builds, not production publishing.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
