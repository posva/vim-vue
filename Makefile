test: dependencies
	vim -u test/vimrc -c 'Vader! test/*.vader'

manual-test: dependencies
	vim -u test/vimrc_debug test

test-nvim: dependencies
	VADER_OUTPUT_FILE=/dev/stderr nvim -u test/vimrc -c 'Vader! test/*.vader' --headless

manual-test-nvim: dependencies
	nvim -u test/vimrc_debug test

dependencies = \
	'tpope/vim-scriptease' \
	'junegunn/vader.vim' \
	'cakebaker/scss-syntax.vim' \
	'digitaltoad/vim-pug' \
	'groenewege/vim-less' \
	'kchmck/vim-coffee-script' \
	'leafgarland/typescript-vim' \
	'slm-lang/vim-slm' \
	'wavded/vim-stylus' \
	'scrooloose/nerdcommenter'

dependencies:
	test -L pack/testing/start/vim-vue && exit 0; \
	mkdir -p pack/testing/start; \
	cd pack/testing/start; \
	for repo in $(dependencies); do git clone https://github.com/$$repo.git; done; \
	ln -s ../../.. vim-vue

clean:
	rm -rf pack

.PHONY: test test-nvim dependencies clean
