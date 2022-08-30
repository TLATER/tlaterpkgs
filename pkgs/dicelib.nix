{
  sources,
  lib,
  stdenv,
  writeText,
  makeWrapper,
  perl,
  gradle,
  adoptopenjdk-hotspot-bin-16,
  exa,
}: let
  inherit (lib) escapeShellArgs;
  inherit (sources) maptool-dicelib;

  jdk = adoptopenjdk-hotspot-bin-16;

  substituteVersion = ''
    substituteInPlace ./build.gradle \
      --subst-var-by version ${maptool-dicelib.version} \
      --subst-var-by revision aaaaaaaaaa \
      --subst-var-by revisionFull aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
  '';

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

  addPomStep = ''
    cat >>build.gradle <<HERE
    publishing {
        publications {
            maven(MavenPublication) {
                groupId = "net.rptools.dicelib"
                artifactId = "dicelib"
                version = "${maptool-dicelib.version}"

                from components.java
            }
        }

        repositories {
            maven {
                url = layout.buildDirectory.dir('repos/releases')
            }
        }
    }
    HERE
  '';

  gradle-args = escapeShellArgs [
    "--no-daemon"
    "-Dorg.gradle.java.home=${jdk}"
  ];

  gradle-deps = stdenv.mkDerivation {
    name = "${maptool-dicelib.pname}-deps";
    inherit (maptool-dicelib) src;

    nativeBuildInputs = [gradle perl];

    patches = [./patches/remove-dev-plugins.patch];
    postPatch = substituteVersion + addResolveStep;

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle ${gradle-args} resolveDependencies
    '';

    # Mavenize dependency paths
    # e.g. org.codehaus.groovy/groovy/2.4.0/{hash}/groovy-2.4.0.jar -> org/codehaus/groovy/groovy/2.4.0/groovy-2.4.0.jar
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-bSUKEEpgcSRmEVJjphm4fpzD/DKBhH8nxawzMybJAR8=";
  };

  gradleInit = writeText "init.gradle" ''
    logger.lifecycle 'Replacing Maven repositories with ${gradle-deps}...'
    gradle.projectsLoaded {
      rootProject.allprojects {
        buildscript {
          repositories {
            clear()
            maven { url '${gradle-deps}' }
          }
        }
        repositories {
          clear()
          maven { url '${gradle-deps}' }
        }
      }
    }

    settingsEvaluated { settings ->
      settings.pluginManagement {
        repositories {
          maven { url '${gradle-deps}' }
        }
      }
    }
  '';
in
  stdenv.mkDerivation {
    inherit (maptool-dicelib) pname version src;

    nativeBuildInputs = [gradle];

    patches = [./patches/remove-dev-plugins.patch];
    postPatch = substituteVersion + addPomStep;

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --offline ${gradle-args} --info --init-script ${gradleInit} publish
    '';

    installPhase = ''
      mkdir -p $out
      cp -r build/repos/releases/* $out
    '';
  }
