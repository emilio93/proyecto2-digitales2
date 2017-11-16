folder=build
# folder=$1

cd build
for file in ./*-sintetizado.v; do
  moduleName=${file/.\//}
  moduleName=${moduleName/-sintetizado.v/}
  newModuleName=${moduleName}Synth
  echo "build/${file/.\//}: ${moduleName} -> ${newModuleName}"
  echo "sed -i \"s/module ${moduleName}/module  ${newModuleName}/g\" \"${file}\""
  sed -i "s/module ${moduleName}/module  ${newModuleName}/" "${file}"
  echo ""
done
