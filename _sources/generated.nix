# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  edopro = {
    pname = "edopro";
    version = "40.0.2";
    src = fetchurl {
      url = "https://github.com/ProjectIgnis/edopro-assets/releases/download/40.0.2/ProjectIgnis-EDOPro-40.0.2-linux.tar.gz";
      sha256 = "sha256-3GQNZFdVU3/G1WgyCUqryStqgVlWT6Qq3h4zuswUZ6U=";
    };
  };
  eontimer = {
    pname = "eontimer";
    version = "d53e42a508de4003b719791ce36e37a8f49dbfc9";
    src = fetchFromGitHub ({
      owner = "DasAmpharos";
      repo = "EonTimer";
      rev = "d53e42a508de4003b719791ce36e37a8f49dbfc9";
      fetchSubmodules = false;
      sha256 = "sha256-jelFKEaifMOtKWJIkJvDMoP+dsQOfNPkx9YjyK4HVj4=";
    });
  };
  eontimer-qtsass = {
    pname = "eontimer-qtsass";
    version = "0.3.2";
    src = fetchurl {
      url = "https://pypi.io/packages/source/q/qtsass/qtsass-0.3.2.tar.gz";
      sha256 = "sha256-twrR1KKDOdtDVALzaZWTR0TmXGn6TV1xZziFSrvx07Y=";
    };
  };
  fbi = {
    pname = "fbi";
    version = "2.6.1";
    src = fetchFromGitHub ({
      owner = "Steveice10";
      repo = "FBI";
      rev = "2.6.1";
      fetchSubmodules = false;
      sha256 = "sha256-KUXAgiCF++JfpwpA3A0/2IGXdyRL2mUMJo4v4kMAJPE=";
    });
  };
  gcs = {
    pname = "gcs";
    version = "v4.37.1";
    src = fetchFromGitHub ({
      owner = "richardwilkes";
      repo = "gcs";
      rev = "v4.37.1";
      fetchSubmodules = false;
      sha256 = "sha256-znN2tBUp0yAvM6E4eTcfmV3KmzyYlrRMLZgc/Fg9tFc=";
    });
  };
  pokefinder = {
    pname = "pokefinder";
    version = "v4.0.1";
    src = fetchFromGitHub ({
      owner = "Admiral-Fish";
      repo = "PokeFinder";
      rev = "v4.0.1";
      fetchSubmodules = true;
      sha256 = "sha256-j7xgjNF8NWLFVPNItWcFM5WL8yPxgHxVX00x7lt45WI=";
    });
  };
}
