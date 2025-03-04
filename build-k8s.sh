DIR=$(dirname "$(realpath "$0")")
[ -d "$DIR/build" ] && sh -c -e "rm -r $DIR/build"
mkdir -p "$DIR/build/cluster"
mkdir -p "$DIR/build/cluster/namespace"
mkdir -p "$DIR/build/sut"
mkdir -p "$DIR/build/kafka"
mkdir -p "$DIR/build/load"
mkdir -p "$DIR/build/load/datasource"
mkdir -p "$DIR/build/load/load"
mkdir -p "$DIR/build/load/sink"
mkdir -p "$DIR/build/chaos"
mkdir -p "$DIR/build/monitor"

# Note: MSYS_NO_PATHCONV=1 will be ignored by Linux / Mac | Used for Windows (Git Bash)
MSYS_NO_PATHCONV=1 docker run --rm --name jsonnet -v $DIR:/src \
    syseleven/jsonnet-builder -m . k8s/main.jsonnet