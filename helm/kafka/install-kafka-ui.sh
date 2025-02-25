ID=$1
if [ -z $ID ]; then
  echo "No argument supplied"
else
  helm repo add kafka-ui https://provectus.github.io/kafka-ui-charts

  if [[ "$(uname -s)" == MINGW* ]] || [[ "$(uname -s)" == MSYS* ]]; then
    # Windows
    WIN_PWD=$(pwd -W 2>/dev/null || cygpath -w "$(pwd)" 2>/dev/null || echo "$(pwd)")
    
    CMD_PWD=$(echo "/$WIN_PWD" | sed 's/://' | sed 's/\\/\//g')
    
    MSYS_NO_PATHCONV=1 docker run --rm --name jsonnet \
      -v "$CMD_PWD/../../global.jsonnet:/src/global.jsonnet" \
      -v "$CMD_PWD/../../config.json:/src/config.json" \
      -v "$CMD_PWD:/src" \
      syseleven/jsonnet-builder -m /src /src/kafka-ui-values.jsonnet
  else
    # Standard: Linux / Mac
    docker run --rm --name jsonnet \
        -v "$(pwd)/../../global.jsonnet:/src/global.jsonnet" \
        -v "$(pwd)/../../config.json:/src/config.json" \
        -v "$(pwd):/src" \
        syseleven/jsonnet-builder -m /src /src/kafka-ui-values.jsonnet
  fi

  helm install kafka-ui kafka-ui/kafka-ui -f kafka-ui-values.json --set createGlobalResources=false --skip-crds -n scalablemine-$ID-kafka
  sh -c -e "rm kafka-ui-values.json config.json global.jsonnet"
fi