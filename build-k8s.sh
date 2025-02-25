ID=$1
if [ -z $ID ]; then
    echo "No argument supplied"
else

    [ -d "build" ] && sh -c -e "rm -r build"
    mkdir -p "build/cluster"
    mkdir -p "build/cluster/namespace"
    mkdir -p "build/sut"
    mkdir -p "build/kafka"
    mkdir -p "build/load"
    mkdir -p "build/load/datasource"
    mkdir -p "build/load/load"
    mkdir -p "build/load/sink"
    mkdir -p "build/chaos"
    mkdir -p "build/monitor"

    if [[ "$(uname -s)" == MINGW* ]] || [[ "$(uname -s)" == MSYS* ]]; then
        # Windows
        WIN_PWD=$(pwd -W 2>/dev/null || cygpath -w "$(pwd)" 2>/dev/null || echo "$(pwd)")
        
        CMD_PWD=$(echo "/$WIN_PWD" | sed 's/://' | sed 's/\\/\//g')
        
        MSYS_NO_PATHCONV=1 docker run --rm --name jsonnet -v $CMD_PWD:/src \
            syseleven/jsonnet-builder -m . k8s/main.jsonnet -V ID=$ID
    else
        # Standard: Linux / Mac
        docker run --rm --name jsonnet -v $(pwd):/src \
            syseleven/jsonnet-builder -m . k8s/main.jsonnet -V ID=$ID
    fi
fi