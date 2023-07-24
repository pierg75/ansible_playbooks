# Playbook to install my own dotfiles

This clones the repository and copies the configuration files in the right places.
There are few things that you manually have to do:

- Install the required collections:
    ```
    ansible-galaxy collection install -r collections/requirements.yml
    ```


- Set in the inventory file the host where this is applied, whether is localhost or 
  a remote host. If remote, you need to make sure you have access to it and if it requires
  a username/password, you can set them in the inventory in the form of:

    ```
    192.168.122.217     ansible_user=root   ansible_ssh_password=passwd
    ```
- If you want to just apply it to localhost, use this in the inventory:
    ```
    localhost 		ansible_connection=local
    ```

- Define the packages to be installed. These needs to be configured as role variables with
  value true in the dotfile.yml playbook. The variables needs to be named as "install_PACKAGE",
  where PACKAGE is the package (i.e. zsh, hyprland, rofi, etc) that you want to install.
  e.g.:

  
  ```
  ...
  roles:
    - role: install_dotfiles
      dest_user: plambri
      install_zsh: true
      install_hyprland: true
      install_wofi: true
      install_dunst: true
  ...
  ```

  If a variable is not defined or false, it won't be installed.

- Run the playbook:

```
# ansible-playbook dotfile.yml
```

## Troubleshooting

- Setting the variable "debug" to true in the file "roles/install_dotfiles/vars/main.yml" 
  will print out all the ansible_facts

- nvim will probably require some other packages to be installed, like `nodejs` (npm) or `tar` or `zip`, depending on the local configuration
