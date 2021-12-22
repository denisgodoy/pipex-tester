NAME := test.sh

all:
	$(MAKE) -C ../ all
	cp ../pipex .
	./$(NAME)

clean:
	$(RM) -r output/
	$(RM) infile fn_used

fclean: clean
	$(RM) pipex

re: fclean all
