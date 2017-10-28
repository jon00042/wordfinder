This GitHub projects contains an implementation of the coding task described by:

https://github.com/strategicdata/recruitment/wiki/Coding-task---BE

NOTE #1: This project is implemented to execute in a Docker container.  The expected container is based on Alpine Linux with all necessary components to run the Perl-based web framework Dancer.  Thus, the container must include: Perl, cpanm, Dancer, and all necessary software dependencies.  Of course, one need only download and build Dockerfile to create the container image.  Dockerfile also contains directives to deploy and start the 'wordfinder' application.

NOTE #2: This project was developed using Docker on 64-bit Intel based MacOS.  As such, the target Docker platform was: x86_64.  While Dockerfile can likely be built on any Docker supported platform, only x86_64 was tested.

NOTE #3: This project has NOT been pushed to Docker Hub: Dockerfile must be downloaded and built.

NOTE #4: No Alpine Linux package seems to include a dictionary of words.  As such, the 'dictionary' file in this project was copied from MacOS: /usr/share/dict/words

NOTE #5: MacOS's dictionary seems to count each letter of the alphabet as a word.  To suppress this from results, the application is implemented to ignore all single letter words from the dictionary.  At the moment, this restriction includes valid words 'a' and 'i'.  The application can always be patched to include these words if necessary.

NOTE #6: The project requirements didn't specify one way or another how to handle words with mixed case letters.  As such, the application only considers words from the dictionary with all lowercase letters.  This helps ignore capitalized proper nouns, which also appear in MacOS's dictionary.  Effectively, the application ignores any uppercase letters submitted.  The application can always be patched to integrate more specific requirements.

INSTALLATION INSTRUCTIONS
=========================
1) Ensure Docker is installed.

2) Download Dockerfile.  This GitHub repository does not necessarily need to be cloned, but that step is fine too.

3) In a terminal window, navigate to the directory where Dockerfile has been downloaded.

4) Run the following (as dictated by project requirements):

$ docker build -t submission .

It will take several minutes for the Docker image to build.

EXECUTION INSTRUCTIONS
======================
1) Instantiate an instance of the image (as dictated by project requirements) with:

$ docker run -d -p 8080:80 submission

2) Test the application with REST API URLs like:

$ curl http://localhost:8080/ping

$ curl http://localhost:8080/wordfinder/dgo

