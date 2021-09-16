{ makeWrapper, symlinkJoin, thunar, thunarPlugins, lib }:

symlinkJoin {
  name = "thunar-with-plugins-${thunar.version}";

  paths = [ thunar ] ++ thunarPlugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    # wrap executables so that they find the plugins
    for exec in bin/thunar bin/thunar-settings; do
      rm "$out/$exec"
      makeWrapper "${thunar}/$exec" "$out/$exec" \
        --set THUNARX_MODULE_DIR "$out/lib/thunarx-3"
    done

    # NOTE: we need to remove the folder symlink itself and create
    # a new folder before trying to substitute any file below.
    rm -f "$out/lib/systemd/user"
    mkdir -p "$out/lib/systemd/user"

    # point to wrapped binary in all service files
    for file in "lib/systemd/user/thunar.service" \
      "share/dbus-1/services/org.xfce.FileManager.service" \
      "share/dbus-1/services/org.xfce.Thunar.FileManager1.service" \
      "share/dbus-1/services/org.xfce.Thunar.service"
    do
      rm -f "$out/$file"
      substitute "${thunar}/$file" "$out/$file" \
        --replace "${thunar}" "$out"
    done
  '';

  meta = with lib; {
    inherit (thunar.meta) homepage license platforms maintainers;

    description = thunar.meta.description + optionalString
      (0 != length thunarPlugins)
      " (with plugins: ${concatStringsSep  ", " (map (x: x.name) thunarPlugins)})";
  };
}
