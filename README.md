# How does your system work?
The webserver, sinatra on thin server, on starting up reads 
the entire file and detects the starting line offset bytes. 
The line offset bytes are written to a file as unsigned long longs, 
and the total line count is memorized. Every request to /lines/<line index>
validates that line index is less than the line count. After that 2
unsigned long longs, start and end, are read from the line offset bytes file,
16 bytes. Then end - start - 1 bytes are read from the file and served
to the client, this strips the newline character from the line.

# How will your system perform with a 1 GB file? a 10 GB file? a 100 GB file?
The system should be able to scale with the size of most files quite easily,
since it uses the disk to maintain it's line offset map. The line offset map
should enable the access of any line in the file with predictable results, 
reading a line in the middle of the file should be the same as reading a line
at the end of the file. The worst case file is one where it is only newline
characters, which could produce a line offset map which is 8 times the size
of the file being served.

# How will your system perform with 100 users? 10000 users? 1000000 users?
The system should be able to handle concurrent requests with thin, but it may
degrade with multiple concurrent users. It would degrade due to disk
contention as disks can't handle concurrent reads at random parts of a file.

# What documentation, websites, papers, etc did you consult in doing this assignment?
I used google, stackoverflow, and a couple of random blog posts via googling for example sinatra apps.

# What third-party libraries or other tools does the system use? How did you choose each library or framework you used?
I used the following gems config, thin, and sinatra. I used config for managing arguments in the app. I used thin for the basic webserver. I used sinatra for managing http routes in the app. I chose config and thin from past experience in ruby apps. This was the first time I used sinatra, but I had seen it a lot in searching for examples of building apps on top of thin.

# How long did you spend on this exercise? If you had unlimited more time to spend on this, how would you spend it and how would you prioritize each item?
I spent 3 to 4 hours on this exercise, and the below is a prioritized lists
of improvements.
1. Improving the line offset mapping algorithm.
   * It would be better if it was sensitive to the size of the file
   * The line offset mapping could be held entirely in memory if it were small enough
2. Caching line index lookups
3. Move line offset mapping generation outside of webserver bootup
   * It is costly to regenerate the mapping for the same file across restarts
4. Using rubocop to keep project source code clean
5. Create rspec test suite to attempt to prevent regressions
6. Make sure app follows Sinatra best practices

# If you were to critique your code, what would you have to say about it?
1. Did I follow Sinatra best practices?
2. Should I have written lib/line_indxer.rb with class methods? It was originally written that way because I couldn't get the LineServerApp#initialize to
work with args, but super() vs super made the difference. I just never got around to refactoring.
