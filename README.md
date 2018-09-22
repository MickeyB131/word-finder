# wordfinder
Instructions:
1. clone the repository
2. cd wordfinder
3. docker build -t submission .
4. docker run -d -p 3000:3000 submission
5. curl http://localhost:3000/ping
6. curl http://localhost:3000/wordfinder/dgo

'words' has been included in the build, as it is not part of the perl:5.28 container.
