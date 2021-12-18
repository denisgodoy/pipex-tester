#!/bin/bash
$(count=0)
$(ls -la > infile)
$(rm -rf output)
$(mkdir output)

count=$((count+1))
echo '================================================================'
echo '        Test' $count ">> Invalid number of arguments"
echo '================================================================'
echo "argc = 2"
./pipex infile
valgrind --leak-check=full --log-file="output/test${count}" ./pipex infile >/dev/null 2>&1
< output/test${count} grep "still reachable"
ret=$?
if [[ $ret -eq 1 ]]; then
    echo "$(tput setaf 2)memcheck OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)memcheck KO$(tput sgr 0)"
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '        Test' $count ">> Invalid number of arguments"
echo '================================================================'
echo "argc = 5"
./pipex infile "cat" "grep $" "wc -l" "output/outfile${count}"
valgrind --leak-check=full --log-file="output/test${count}" ./pipex infile "cat" "grep $" "wc -l" output/outfile >/dev/null 2>&1
< output/test${count} grep "still reachable"
ret=$?
if [[ $ret -eq 1 ]]; then
    echo "$(tput setaf 2)memcheck OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)memcheck KO$(tput sgr 0)"
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '              Test' $count ">> Infile bad permission"
echo '================================================================'
chmod 000 infile
./pipex infile "cat" "tr [a-z] [A-Z]" "output/outfile${count}"
echo "exit code" $?
< infile cat | tr [a-z] [A-Z] > "output/out${count}"
echo "exit code" $?
diff "output/outfile${count}" "output/out${count}"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff KO$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/test${count}" ./pipex infile "cat" "tr [a-z] [A-Z]" output/outfile >/dev/null 2>&1
chmod 777 infile
< output/test${count} grep "still reachable"
ret=$?
if [[ $ret -eq 1 ]]; then
    echo "$(tput setaf 2)memcheck OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)memcheck KO$(tput sgr 0)"
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '              Test' $count ">> Outfile bad permission"
echo '================================================================'
touch "output/outfile${count}"
chmod 000 "output/outfile${count}"
./pipex infile "cat" "tr [a-z] [A-Z]" "output/outfile${count}"
echo "exit code" $?
touch "output/out${count}"
chmod 000 "output/out${count}"
< infile cat | tr [a-z] [A-Z] > "output/out${count}"
echo "exit code" $?
chmod 777 "output/outfile${count}" "output/out${count}"
diff "output/outfile${count}" "output/out${count}"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff KO$(tput sgr 0)"
fi
chmod 000 "output/outfile"
valgrind --leak-check=full --log-file="output/test${count}" ./pipex infile "cat" "tr [a-z] [A-Z]" output/outfile >/dev/null 2>&1
< output/test${count} grep "still reachable"
ret=$?
if [[ $ret -eq 1 ]]; then
    echo "$(tput setaf 2)memcheck OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)memcheck KO$(tput sgr 0)"
fi
chmod 777 "output/outfile"
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '                Test' $count ">> Invalid command 2"
echo '================================================================'
./pipex infile "cat" "trzero [a-z] [A-Z]" "output/outfile${count}"
echo "exit code" $?
< infile cat | trzero [a-z] [A-Z] > "output/out${count}"
echo "exit code" $?
diff "output/outfile${count}" "output/out${count}"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff KO$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/test${count}" ./pipex infile "cat" "trzero [a-z] [A-Z]" output/outfile >/dev/null 2>&1
< output/test${count} grep "still reachable"
ret=$?
if [[ $ret -eq 1 ]]; then
    echo "$(tput setaf 2)memcheck OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)memcheck KO$(tput sgr 0)"
fi
echo
sleep 1

count=$((count+1))
echo '================================================================'
echo '                Test' $count ">> Invalid command 1"
echo '================================================================'
./pipex infile "catzado" "tr [a-z] [A-Z]" "output/outfile${count}"
echo "exit code" $?
< infile catzado | tr [a-z] [A-Z] > "output/out${count}"
echo "exit code" $?
diff "output/outfile${count}" "output/out${count}"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff KO$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/test${count}" ./pipex infile "catzado" "tr [a-z] [A-Z]" output/outfile >/dev/null 2>&1
< output/test${count} grep "still reachable"
ret=$?
if [[ $ret -eq 1 ]]; then
    echo "$(tput setaf 2)memcheck OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)memcheck KO$(tput sgr 0)"
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '                Test' $count ">> Valid commands"
echo '================================================================'
./pipex infile "grep .c" "wc -l" "output/outfile${count}"
echo "exit code" $?
< infile grep .c | wc -l > "output/out${count}"
echo "exit code" $?
diff "output/outfile${count}" "output/out${count}"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff KO$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/test${count}" ./pipex infile "grep .c" "wc -l" output/outfile >/dev/null 2>&1
< output/test${count} grep "still reachable"
ret=$?
if [[ $ret -eq 1 ]]; then
    echo "$(tput setaf 2)memcheck OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)memcheck KO$(tput sgr 0)"
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '                Test' $count ">> Valid commands"
echo '================================================================'
./pipex /dev/urandom "head -n 10" "wc -l" "output/outfile${count}"
echo "exit code" $?
<  /dev/urandom head -n 10 | wc -l  > "output/out${count}"
echo "exit code" $?
diff "output/outfile${count}" "output/out${count}"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff KO$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/test${count}" ./pipex /dev/urandom "head -n 10" "wc -l" output/outfile >/dev/null 2>&1
< output/test${count} grep "still reachable"
ret=$?
if [[ $ret -eq 1 ]]; then
    echo "$(tput setaf 2)memcheck OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)memcheck KO$(tput sgr 0)"
fi
sleep 1

echo
count=$((count+1))
echo
echo '================================================================'
echo '                Test' $count ">> Valid commands"
echo '================================================================'
./pipex infile "cat" "tr [a-z] [A-Z]" "output/outfile${count}"
echo "exit code" $?
< infile cat | tr [a-z] [A-Z] > "output/out${count}"
echo "exit code" $?
diff "output/outfile${count}" "output/out${count}"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff KO$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/test${count}" ./pipex infile "cat" "tr [a-z] [A-Z]" output/outfile >/dev/null 2>&1
< output/test${count} grep "still reachable"
ret=$?
if [[ $ret -eq 1 ]]; then
    echo "$(tput setaf 2)memcheck OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)memcheck KO$(tput sgr 0)"
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '                Test' $count ">> Valid commands"
echo '================================================================'
./pipex infile "cat" "tr - ' '" "output/outfile${count}"
echo "exit code" $?
<  infile cat | tr - ' ' > "output/out${count}"
echo "exit code" $?
diff "output/outfile${count}" "output/out${count}"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff KO$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/test${count}" ./pipex infile "cat" "tr - ' '" output/outfile >/dev/null 2>&1
< output/test${count} grep "still reachable"
ret=$?
if [[ $ret -eq 1 ]]; then
    echo "$(tput setaf 2)memcheck OK$(tput sgr 0)"
else
    echo "$(tput setaf 1)memcheck KO$(tput sgr 0)"
fi
