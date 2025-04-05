function(token, username, caData, server="https://kube1-1:6443")
{
  apiVersion: "v1",
  clusters: [
    {
      cluster: {
        "certificate-authority-data": caData,
        server: server
      },
      name: "cluster.local"
    }
  ],
  contexts: [
    {
      context: {
        cluster: "cluster.local",
        user: username,
        namespace: "scalablemine-%s" %[username]
      },
      name: "%s@cluster.local" %[username]
    }
  ],
  "current-context": "%s@cluster.local" %[username],
  kind: "Config",
  preferences: {},
  users: [
    {
      name: username,
      user: {
        token: token
      }
    }
  ]
}
