#find ./ -name \*py -not -name \*migrations\* | xargs pep8 --show-source -r --ignore=E501
find -path ./migrations -prune -o -name \*py -print | xargs pep8 --show-source -r --ignore=E501
