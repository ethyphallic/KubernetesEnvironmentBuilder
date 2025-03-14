function(path, manifestName, manifest) {
  ["build/%s/%s.json" %[path, manifestName]] : manifest
}