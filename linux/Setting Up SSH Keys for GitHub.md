# Setting Up SSH

[Github - Generate new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

```
ssh-keygen -t ed25519 -C "your_email@example.com"
```
.pub file will be under .ssh in the home file if you excepted the defaults
```
cd ~/..ssh/
```
```
# copy these contents and paste them into "add SSH key" in Github
nano id_ed25519.pub
```
Now, your key should be saved in Github
