NAME := test.sh

all:
	./$(NAME)

clean:
	$(RM) -r output/
	$(RM) infile

fclean: clean
	$(RM) pipex

re: fclean all
