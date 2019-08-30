#！/bin/bash

# Cashier="Cashier"
# templateName="SampleModule"
# Common="Common"
# Phone="Phone"
# Pad="Pad"

# Template

export LC_COLLATE='C'
export LC_CTYPE='C'

ModuleName=$1

if [[ "$ModuleName"x == "x" ]]; then
echo "Please provide ModuleName!!!"
exit
fi

# git clone "git@gitlab.qima-inc.com:normandy-ios/ZanXcodeTemplates.git"

# cd ./ZanXcodeTemplates/Samples

rm -rf $ModuleName
cp -r TemplateModule $ModuleName
cd $ModuleName

#sed -i "s/oldstring/newstring/g" `grep oldstring -rl path`
echo ""
echo "Replacing placeholders in all files..."
sed -i "" "s/Template/$ModuleName/g" `grep Template -rl "./Template"`
sed -i "" "s/Template/$ModuleName/g" `grep Template -rl "./Template.xcodeproj"` 
sed -i "" "s/__UserName__/$USER/g" `grep __UserName__ -rl "./Template"` 
sed -i "" "s/__Year__/$(date '+%Y')/g" `grep __Year__ -rl "./Template"` 
sed -i "" "s/__YMD__/$(date '+%Y.%m.%d')/g" `grep __YMD__ -rl "./Template"` 

echo ""
echo "Renaming folders and files..."
IFS=$'\n'
for ((i=0; i<1;))
do
	i=1
	for file in `find . -name "*Template*"`
	do
		i=0
		newFile=${file//Template/$ModuleName}
		mv "$file" "$newFile"
		echo "Renamed $file to $newFile"
		break
	done
done

echo "Done! Now you have your $ModuleName project."
open .
