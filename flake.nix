{
  description = "Snip text from the screen and read it aloud";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      runtimeDeps = pkgs: with pkgs; [
        gnome-screenshot
        tesseract
        rhvoice
      ];
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          snip-ocr-tts = pkgs.stdenv.mkDerivation {
            pname = "snip-ocr-tts";
            version = "0.1.0";
            src = ./.;

            nativeBuildInputs = [ pkgs.makeWrapper ];
            dontBuild = true;

            installPhase = ''
              runHook preInstall
              install -Dm755 bin/start-snip-ocr-tts.sh "$out/bin/start-snip-ocr-tts"
              install -Dm755 bin/stop-tts.sh "$out/bin/stop-tts"
              for script in start-snip-ocr-tts stop-tts; do
                wrapProgram "$out/bin/$script" \
                  --prefix PATH : ${pkgs.lib.makeBinPath (runtimeDeps pkgs)}
              done
              runHook postInstall
            '';

            meta = {
              description = "Snip text from the screen and read it aloud";
              homepage = "https://github.com/mpawlowski/snip-ocr-tts";
              license = pkgs.lib.licenses.mit;
              platforms = pkgs.lib.platforms.linux;
              mainProgram = "start-snip-ocr-tts";
            };
          };
        in
        {
          default = snip-ocr-tts;
          snip-ocr-tts = snip-ocr-tts;
        }
      );

      apps = forAllSystems (system: {
        default = self.apps.${system}.start;
        start = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/start-snip-ocr-tts";
          meta.description = "Snip a screen region, OCR it, and read it aloud";
        };
        stop = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/stop-tts";
          meta.description = "Stop all text to speech currently running";
        };
      });

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = runtimeDeps pkgs;
          };
        }
      );
    };
}
