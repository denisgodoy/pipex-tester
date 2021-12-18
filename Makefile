NAME := test.sh

all:
	$(MAKE) -C ../ all
	cp ../pipex .
	./$(NAME)

clean:
	$(RM) -r output/
	$(RM) infile

fclean: clean
	$(RM) pipex

re: fclean all
