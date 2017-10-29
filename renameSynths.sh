folder=build
# folder=$1

cd build
for file in ./*-sintetizado.v; do
  moduleName=${file/.\//}
  moduleName=${moduleName/-sintetizado.v/}
  newModuleName=${moduleName}Synth
  echo "${file}:"
  echo "    ${moduleName} -> ${newModuleName}"
  echo "sed -i \"s/module ${moduleName}/module  ${newModuleName}/g\" \"${file}\""
  sed -i "s/module ${moduleName}/module  ${newModuleName}/" "${file}"
done
