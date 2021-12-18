#!/bin/bash
$(count=0)
$(exit=0)
$(exit_orig=0)
$(rm -rf output)
$(mkdir output)
$(ls -la > infile)

count=$((count+1))
echo '================================================================'
echo '             Test' $count ">> Check the executable"
echo '================================================================'
if [ ! -f "pipex" ]; then
	echo "$(tput setaf 1)name [KO]$(tput sgr 0)"
	echo
	exit 0
else
	echo "$(tput setaf 2)name [OK]$(tput sgr 0)"
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '        Test' $count ">> Invalid number of arguments"
echo '================================================================'
./pipex infile
valgrind --leak-check=full --log-file="output/valgrind${count}" ./pipex infile >/dev/null 2>&1
echo
if [ ! -f "output/valgrind${count}" ]; then
    echo "Valgrind not found!"
else
	< output/valgrind${count} grep "still reachable"
	ret=$?
	if [[ $ret -eq 1 ]]; then
    	echo "$(tput setaf 2)memcheck [OK]$(tput sgr 0)"
	else
    	echo "$(tput setaf 1)memcheck [KO]$(tput sgr 0)"
	fi
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '        Test' $count ">> Invalid number of arguments"
echo '================================================================'
./pipex infile "cat" "grep $" "wc -l" "output/outfile${count}"
valgrind --leak-check=full --log-file="output/valgrind${count}" ./pipex infile "cat" "grep $" "wc -l" output/valgrind >/dev/null 2>&1
echo
if [ ! -f "output/valgrind${count}" ]; then
    echo "Valgrind not found!"
else
	< output/valgrind${count} grep "still reachable"
	ret=$?
	if [[ $ret -eq 1 ]]; then
    	echo "$(tput setaf 2)memcheck [OK]$(tput sgr 0)"
	else
    	echo "$(tput setaf 1)memcheck [KO]$(tput sgr 0)"
	fi
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '                Test' $count ">> Invalid infile"
echo '================================================================'
chmod 000 infile
./pipex file1 "cat" "tr [a-z] [A-Z]" "output/outfile${count}"
echo "exit code" $?
exit=$?
< file1 cat | tr [a-z] [A-Z] > "output/outfile${count}-orig"
echo "exit code" $?
exit_orig=$?
echo
if [[ $exit = $exit_orig ]]; then
    echo "$(tput setaf 2)exit code [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)exit code [KO]$(tput sgr 0)"
fi
diff "output/outfile${count}" "output/outfile${count}-orig"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff [KO]$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/valgrind${count}" ./pipex infile "cat" "tr [a-z] [A-Z]" output/valgrind >/dev/null 2>&1
chmod 777 infile
if [ ! -f "output/valgrind${count}" ]; then
    echo "Valgrind not found!"
else
	< output/valgrind${count} grep "still reachable"
	ret=$?
	if [[ $ret -eq 1 ]]; then
    	echo "$(tput setaf 2)memcheck [OK]$(tput sgr 0)"
	else
    	echo "$(tput setaf 1)memcheck [KO]$(tput sgr 0)"
	fi
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
exit=$?
< infile cat | tr [a-z] [A-Z] > "output/outfile${count}-orig"
echo "exit code" $?
exit_orig=$?
echo
if [[ $exit = $exit_orig ]]; then
    echo "$(tput setaf 2)exit code [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)exit code [KO]$(tput sgr 0)"
fi
diff "output/outfile${count}" "output/outfile${count}-orig"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff [KO]$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/valgrind${count}" ./pipex infile "cat" "tr [a-z] [A-Z]" output/valgrind >/dev/null 2>&1
chmod 777 infile
if [ ! -f "output/valgrind${count}" ]; then
    echo "Valgrind not found!"
else
	< output/valgrind${count} grep "still reachable"
	ret=$?
	if [[ $ret -eq 1 ]]; then
    	echo "$(tput setaf 2)memcheck [OK]$(tput sgr 0)"
	else
    	echo "$(tput setaf 1)memcheck [KO]$(tput sgr 0)"
	fi
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
exit=$?
touch "output/outfile${count}-orig"
chmod 000 "output/outfile${count}-orig"
< infile cat | tr [a-z] [A-Z] > "output/outfile${count}-orig"
echo "exit code" $?
exit_orig=$?
chmod 777 "output/outfile${count}"
chmod 777 "output/outfile${count}-orig"
echo
if [[ $exit = $exit_orig ]]; then
    echo "$(tput setaf 2)exit code [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)exit code [KO]$(tput sgr 0)"
fi
diff "output/outfile${count}" "output/outfile${count}-orig"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff [KO]$(tput sgr 0)"
fi
if [ -f "output/outfile" ]; then
	chmod 000 "output/outfile"
fi
valgrind --leak-check=full --log-file="output/valgrind${count}" ./pipex infile "cat" "tr [a-z] [A-Z]" output/valgrind >/dev/null 2>&1
if [ ! -f "output/valgrind${count}" ]; then
    echo "Valgrind not found!"
else
	< output/valgrind${count} grep "still reachable"
	ret=$?
	if [[ $ret -eq 1 ]]; then
    	echo "$(tput setaf 2)memcheck [OK]$(tput sgr 0)"
	else
    	echo "$(tput setaf 1)memcheck [KO]$(tput sgr 0)"
	fi
fi
if [ -f "output/outfile" ]; then
	chmod 777 "output/outfile"
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '                Test' $count ">> Invalid command 1"
echo '================================================================'
./pipex infile "catzado" "tr [a-z] [A-Z]" "output/outfile${count}"
echo "exit code" $?
exit=$?
< infile catzado | tr [a-z] [A-Z] > "output/outfile${count}-orig"
echo "exit code" $?
exit_orig=$?
echo
if [[ $exit = $exit_orig ]]; then
    echo "$(tput setaf 2)exit code [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)exit code [KO]$(tput sgr 0)"
fi
diff "output/outfile${count}" "output/outfile${count}-orig"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff [KO]$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/valgrind${count}" ./pipex infile "catzado" "tr [a-z] [A-Z]" output/valgrind >/dev/null 2>&1
if [ ! -f "output/valgrind${count}" ]; then
    echo "Valgrind not found!"
else
	< output/valgrind${count} grep "still reachable"
	ret=$?
	if [[ $ret -eq 1 ]]; then
    	echo "$(tput setaf 2)memcheck [OK]$(tput sgr 0)"
	else
    	echo "$(tput setaf 1)memcheck [KO]$(tput sgr 0)"
	fi
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '                Test' $count ">> Invalid command 2"
echo '================================================================'
./pipex infile "cat" "trzero [a-z] [A-Z]" "output/outfile${count}"
echo "exit code" $?
exit=$?
< infile cat | trzero [a-z] [A-Z] > "output/outfile${count}-orig"
echo "exit code" $?
exit_orig=$?
echo
if [[ $exit = $exit_orig ]]; then
    echo "$(tput setaf 2)exit code [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)exit code [KO]$(tput sgr 0)"
fi
diff "output/outfile${count}" "output/outfile${count}-orig"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff [KO]$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/valgrind${count}" ./pipex infile "cat" "trzero [a-z] [A-Z]" output/valgrind >/dev/null 2>&1
if [ ! -f "output/valgrind${count}" ]; then
    echo "Valgrind not found!"
else
	< output/valgrind${count} grep "still reachable"
	ret=$?
	if [[ $ret -eq 1 ]]; then
    	echo "$(tput setaf 2)memcheck [OK]$(tput sgr 0)"
	else
    	echo "$(tput setaf 1)memcheck [KO]$(tput sgr 0)"
	fi
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '                Test' $count ">> Both invalid commands"
echo '================================================================'
./pipex infile "ls-l" "grepzao x" "output/outfile${count}"
echo "exit code" $?
exit=$?
< infile ls-l | grepzao x > "output/outfile${count}-orig"
echo "exit code" $?
exit_orig=$?
echo
if [[ $exit = $exit_orig ]]; then
    echo "$(tput setaf 2)exit code [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)exit code [KO]$(tput sgr 0)"
fi
diff "output/outfile${count}" "output/outfile${count}-orig"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff [KO]$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/valgrind${count}" ./pipex infile "ls-l" "grepzao x" output/valgrind >/dev/null 2>&1
if [ ! -f "output/valgrind${count}" ]; then
    echo "Valgrind not found!"
else
	< output/valgrind${count} grep "still reachable"
	ret=$?
	if [[ $ret -eq 1 ]]; then
    	echo "$(tput setaf 2)memcheck [OK]$(tput sgr 0)"
	else
    	echo "$(tput setaf 1)memcheck [KO]$(tput sgr 0)"
	fi
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '                Test' $count ">> Valid commands"
echo '================================================================'
./pipex infile "grep d" "cat -e" "output/outfile${count}"
echo "exit code" $?
exit=$?
< infile grep d | cat -e > "output/outfile${count}-orig"
echo "exit code" $?
exit_orig=$?
echo
if [[ $exit = $exit_orig ]]; then
    echo "$(tput setaf 2)exit code [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)exit code [KO]$(tput sgr 0)"
fi
diff "output/outfile${count}" "output/outfile${count}-orig"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff [KO]$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/valgrind${count}" ./pipex infile "grep .c" "wc -l" output/valgrind >/dev/null 2>&1
if [ ! -f "output/valgrind${count}" ]; then
    echo "Valgrind not found!"
else
	< output/valgrind${count} grep "still reachable"
	ret=$?
	if [[ $ret -eq 1 ]]; then
    	echo "$(tput setaf 2)memcheck [OK]$(tput sgr 0)"
	else
    	echo "$(tput setaf 1)memcheck [KO]$(tput sgr 0)"
	fi
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '                Test' $count ">> Valid commands"
echo '================================================================'
./pipex /dev/urandom "head -n 10" "wc -l" "output/outfile${count}"
echo "exit code" $?
exit=$?
<  /dev/urandom head -n 10 | wc -l  > "output/outfile${count}-orig"
echo "exit code" $?
exit_orig=$?
echo
if [[ $exit = $exit_orig ]]; then
    echo "$(tput setaf 2)exit code [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)exit code [KO]$(tput sgr 0)"
fi
diff "output/outfile${count}" "output/outfile${count}-orig"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff [KO]$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/valgrind${count}" ./pipex /dev/urandom "head -n 10" "wc -l" output/valgrind >/dev/null 2>&1
if [ ! -f "output/valgrind${count}" ]; then
    echo "Valgrind not found!"
else
	< output/valgrind${count} grep "still reachable"
	ret=$?
	if [[ $ret -eq 1 ]]; then
    	echo "$(tput setaf 2)memcheck [OK]$(tput sgr 0)"
	else
    	echo "$(tput setaf 1)memcheck [KO]$(tput sgr 0)"
	fi
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
exit=$?
< infile cat | tr [a-z] [A-Z] > "output/outfile${count}-orig"
echo "exit code" $?
exit_orig=$?
echo
if [[ $exit = $exit_orig ]]; then
    echo "$(tput setaf 2)exit code [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)exit code [KO]$(tput sgr 0)"
fi
diff "output/outfile${count}" "output/outfile${count}-orig"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff [KO]$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/valgrind${count}" ./pipex infile "cat" "tr [a-z] [A-Z]" output/valgrind >/dev/null 2>&1
if [ ! -f "output/valgrind${count}" ]; then
    echo "Valgrind not found!"
else
	< output/valgrind${count} grep "still reachable"
	ret=$?
	if [[ $ret -eq 1 ]]; then
    	echo "$(tput setaf 2)memcheck [OK]$(tput sgr 0)"
	else
    	echo "$(tput setaf 1)memcheck [KO]$(tput sgr 0)"
	fi
fi
sleep 1

echo
count=$((count+1))
echo '================================================================'
echo '                Test' $count ">> Valid commands"
echo '================================================================'
./pipex infile "grep pipex" "tr x ' '" "output/outfile${count}"
echo "exit code" $?
exit=$?
<  infile grep pipex | tr x ' ' > "output/outfile${count}-orig"
echo "exit code" $?
exit_orig=$?
echo
if [[ $exit = $exit_orig ]]; then
    echo "$(tput setaf 2)exit code [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)exit code [KO]$(tput sgr 0)"
fi
diff "output/outfile${count}" "output/outfile${count}-orig"
ret=$?
if [[ $ret -eq 0 ]]; then
    echo "$(tput setaf 2)diff [OK]$(tput sgr 0)"
else
    echo "$(tput setaf 1)diff [KO]$(tput sgr 0)"
fi
valgrind --leak-check=full --log-file="output/valgrind${count}" ./pipex infile "cat" "tr - ' '" output/valgrind >/dev/null 2>&1
if [ ! -f "output/valgrind${count}" ]; then
    echo "Valgrind not found!"
else
	< output/valgrind${count} grep "still reachable"
	ret=$?
	if [[ $ret -eq 1 ]]; then
    	echo "$(tput setaf 2)memcheck [OK]$(tput sgr 0)"
	else
    	echo "$(tput setaf 1)memcheck [KO]$(tput sgr 0)"
	fi
fi
echo

$(rm -f output/valgrind)
