{
    buildManifests(path, manifestName, manifests)::
    { ["build/%s/%s-%s.json" %[path, manifestName, i]] : manifests[i] for i in std.range(0, std.length(manifests) - 1) },
    buildManifest(path, manifestName, manifest)::
    { ["build/%s/%s.json" %[path, manifestName]] : manifest }
}