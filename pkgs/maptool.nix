{
  sources,
  lib,
  stdenv,
  writeText,
  makeWrapper,
  perl,
  gradle,
  protobuf3_17,
  jdk,
  adoptopenjdk-hotspot-bin-16,
  dicelib,
}: let
  inherit (lib) escapeShellArgs;
  inherit (sources) maptool maptool-dicelib;

  protobuf = protobuf3_17;
  build-jdk = adoptopenjdk-hotspot-bin-16;
  # Technically unsupported, but it works, and the adoptopenjdk jdk
  # doesn't have openjfx
  run-jdk = jdk;

  # Use the jdk supplied by nixpkgs, instead of one downloaded from
  # the internet.
  removeVendoredJDK = ''
    sed -i '/jdkHome =/c\jdkHome = "${build-jdk}"' build.gradle
  '';

  # Skip creating the .deb and .rpm packages, since we don't use them
  # anyway and using rpmbuild is nontrivial using nix.
  skipDebRpm = ''
    sed -i '/installerOutputDir =/c\\nskipInstaller = true' build.gradle
  '';

  # Use the protoc supplied by nixpkgs, instead of one downloaded from
  # the internet.
  fixProtoc = ''
    cat >>build.gradle <<HERE
    protobuf {
      protoc {
        path = '${protobuf}/bin/protoc'
      }
    }
    HERE
  '';

  # Add a task to just download dependencies. Used by gradle-deps to,
  # well, download dependencies.
  addResolveStep = ''
    cat >>build.gradle <<HERE
    task resolveDependencies {
      doLast {
        project.rootProject.allprojects.each { subProject ->
          subProject.buildscript.configurations.each { configuration ->
            resolveConfiguration(subProject, configuration, "buildscript config \''${configuration.name}")
          }
          subProject.configurations.each { configuration ->
            resolveConfiguration(subProject, configuration, "config \''${configuration.name}")
          }
        }
      }
    }
    void resolveConfiguration(subProject, configuration, name) {
      if (configuration.canBeResolved) {
        logger.info("Resolving project {} {}", subProject.name, name)
        configuration.resolve()
      }
    }
    HERE
  '';

  gradle-args = escapeShellArgs [
    "--no-daemon"
    "-PnoGit=true"
    "-PgitTag=${maptool.version}"
    "-PgitCommit=1234567890"
    "-Dorg.gradle.java.home=${build-jdk}"
    "-Dfile.encoding=utf-8"
  ];

  gradleInitDeps = writeText "init.gradle" ''
    logger.lifecycle 'Adding ${dicelib} to Maven repositories...'
    gradle.projectsLoaded {
      rootProject.allprojects {
        buildscript {
          repositories {
            maven { url '${dicelib}' }
          }
        }
        repositories {
          maven { url '${dicelib}' }
        }
      }
    }
  '';

  # Need some FOD sadly, since gradle is insane
  gradle-deps = stdenv.mkDerivation {
    name = "${maptool.pname}-deps";
    inherit (maptool) src;

    nativeBuildInputs = [gradle perl];

    patches = [./patches/remove-dev-config.patch];
    postPatch = fixProtoc + addResolveStep;

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle ${gradle-args} --init-script ${gradleInitDeps} resolveDependencies
    '';

    # Mavenize dependency paths
    # e.g. org.codehaus.groovy/groovy/2.4.0/{hash}/groovy-2.4.0.jar -> org/codehaus/groovy/groovy/2.4.0/groovy-2.4.0.jar
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh

      # Just gradle things
      mv $out/com/squareup/okio/okio/2.8.0/okio-jvm-2.8.0.jar $out/com/squareup/okio/okio/2.8.0/okio-2.8.0.jar
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-3pZ9ggRFCXNNV4854L7nZn5E1ShArKUNI1IyM4nMKMc=";
  };

  gradleInit = writeText "init.gradle" ''
    logger.lifecycle 'Replacing Maven repositories with ${dicelib} and ${gradle-deps}...'
    gradle.projectsLoaded {
      rootProject.allprojects {
        buildscript {
          repositories {
            clear()
            maven { url '${dicelib}' }
            maven { url '${gradle-deps}' }
          }
        }
        repositories {
          clear()
          maven { url '${dicelib}' }
          maven { url '${gradle-deps}' }
        }
      }
    }

    settingsEvaluated { settings ->
      settings.pluginManagement {
        repositories {
          maven { url '${dicelib}' }
          maven { url '${gradle-deps}' }
        }
      }
    }
  '';
in
  stdenv.mkDerivation {
    inherit (maptool) pname version src;

    nativeBuildInputs = [gradle makeWrapper];

    patches = [./patches/remove-dev-config.patch];
    postPatch = skipDebRpm + removeVendoredJDK + fixProtoc;

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --offline ${gradle-args} --info --init-script ${gradleInit} jpackage
    '';

    installPhase = ''
      mkdir -p $out/
      cp -r build/install/MapTool/* $out/
      wrapProgram $out/bin/MapTool --set JAVA_HOME '${run-jdk}'
    '';
  }
