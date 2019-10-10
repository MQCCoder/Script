#获取podspec文件名称

packageDIR=`pwd`
podName=${packageDIR##*/}
podspecFile=${podName}'.podspec'

echo "podName ----->"${podName}
echo 'COMMIT-podspec-FILE'

sourceRepo='http://192.168.1.33:9090/Pods/Specs.git'
sourceRepoName='Specs'

version=$1
if [ ! $version ]; then
  version=`git describe --abbrev=0`
  # 更新版本号
  sed -i "" "s/= \'[0-9]*\.[0-9]*\.[0-9]*\'/= \'"${version}"\'/g" ${podspecFile}
else
	# 更新版本号
	sed -i "" "s/= \'[0-9]*\.[0-9]*\.[0-9]*\'/= \'"${version}"\'/g" ${podspecFile}

	git status
	git add .
	git commit -m "[Update] ${podName}.podspec to (${version})"
	git tag ${version}
	git push
fi

echo '更新版本号'

cd ..

specsDir=`pwd`/${sourceRepoName}/
echo "specsdir ---->"$specsDir

if [ -d $specsDir ]; then
	cd $specsDir
	git pull
else
	git clone $sourceRepo
	cd $specsDir
fi

echo 'FILE-PATH:'
echo ${specsDir}${podName}/${version}
echo $packageDIR/${podspecFile}

mkdir -p  ${specsDir}${podName}/${version}
echo ${specsDir}${podName}/${version}/${podspecFile}

cp $packageDIR/${podspecFile} ${specsDir}${podName}/${version}
echo '文件copy'

nowDIR=`pwd`
echo 'nowDIR->' ${nowDIR}

git status
git add .
git commit -m "[Add] ${podName} (${version})"
git push

cd ..
rm -rf specs
