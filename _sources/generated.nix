# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl }:
{
  edopro = {
    pname = "edopro";
    version = "39.3.1";
    src = fetchurl {
      url = "https://github.com/ProjectIgnis/edopro-assets/releases/download/39.3.1/ProjectIgnis-EDOPro-39.3.1-linux.tar.gz";
      sha256 = "0klwysah93qxyisk59mjiymkzgqb5j8d9la9i9npjzcam69kpcbk";
    };
  };
  eontimer = {
    pname = "eontimer";
    version = "d53e42a508de4003b719791ce36e37a8f49dbfc9";
    src = fetchgit {
      url = "https://github.com/dylmeadows/EonTimer";
      rev = "d53e42a508de4003b719791ce36e37a8f49dbfc9";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "0gjn0ypch8ynqzjd6z0fqivgx0rjqfdr0j3256nw6z528ql4bscd";
    };
  };
  eontimer-qtsass = {
    pname = "eontimer-qtsass";
    version = "0.3.0";
    src = fetchurl {
      sha256 = "1rqzvshyx7666bc8xxzx3k6k6a4r9r51zxqqjq5kmqm9rrirzi17";
      url = "https://pypi.io/packages/source/q/qtsass/qtsass-0.3.0.tar.gz";
    };
  };
  gcs = {
    pname = "gcs";
    version = "v4.37.1";
    src = fetchgit {
      url = "https://github.com/richardwilkes/gcs";
      rev = "v4.37.1";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "0mxl7mcgq74q5m6b95lq7jdwlpcr3wvpjf516cpj1lr92ns7cwyf";
    };
  };
  pokefinder = {
    pname = "pokefinder";
    version = "ca9644d4ac0ba687c21c1344ab3be0dc31157c3b";
    src = fetchgit {
      url = "https://github.com/Admiral-Fish/PokeFinder";
      rev = "ca9644d4ac0ba687c21c1344ab3be0dc31157c3b";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "0x5hqmmq2c6fyv8hs537f0ljppb27cf626a0hvk0j67py49x7y3i";
    };
  };
}
