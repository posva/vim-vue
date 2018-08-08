# posva/vim-make

Small docker image with vim, make and git

## Building

```sh
cd .circleci
docker rmi vim-make # remove old image
docker build -t vim-make .
docker run -it vim-make /bin/date
docker commit $(docker ps -lq) vim-make
docker push posva/vim-make:0.3 # replace the tag with a new one
docker container rm $(docker ps -lq) # remove container
```

## Cleaning

To remove old images and containers, use `docker images` and `docker ps -a`.
Then remove them with `docker rmi <image>` and `docker container rm <container>`

## Update `config.yml`

Make sure to update the tag in the `image` section of `.config.yml`
