#!/bin/bash
set -e # exit with nonzero exit code if anything fails

# squash messages
git config --global push.default matching

# prepare respec build

# clear the respec directory
#rm -rf respec || exit 0;

cd ${DIR_NAME}
git clone "https://${GH_TOKEN}@${GH_REF}"
cd ${REPO_NAME}

git config user.name "Openactive Bot"
git config user.email "hello@openactive.io"

echo "metadata.json:"
cat metadata.json
echo ""
echo "Performing merge..."

# Configure git's merge to permanently ignore all upstream changes to locally-changed files
git config merge.pin.driver true
echo index.html merge=pin >> .git/info/attributes
echo metadata.json merge=pin >> .git/info/attributes
echo images/bg.jpg merge=pin >> .git/info/attributes
echo images/logo.png merge=pin >> .git/info/attributes

git remote add upstream https://${GH_TOKEN}@github.com:openactive/dataset-site-generator.git
git fetch upstream
git pull upstream master -Xtheirs

echo ""
echo "Regenerating index.html..."

../../../generator-standalone.js --template generator/template.html --metadata metadata.json --output index.html

echo ""
echo "Committing index.html..."
git add index.html
git commit -m "Regeneration of index.html by Openactive Bot"

echo ""
echo "Pushing..."
git push

echo ""

exit 0