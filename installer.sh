#!/usr/bin/env python3
# This script will install some themes
# IMPORT
import os, subprocess, sys, traceback, pkg_resources
from datetime import datetime


# VARS AND OTHER
CONFIG_FILE = './config.yaml'
REQUIREMENTS = ["pyyaml"]


# FUNCS
def log(msg: str, new_line = False) -> None:
    if new_line:
        print()
    print("::", msg, "::")


def handle_errors(func):
    def inner_func():
        try:
            func()
        except Exception as error:
            dateandtime = datetime.now().strftime("[%d/%m/%Y %H:%M:%S]")
            current_dir = os.getcwd()
            log_file = os.path.join(current_dir, "log.txt")

            with open(log_file, "a") as file:
                file.write(dateandtime + "\n")
                traceback.print_exc(file=file)
                file.write("\n")
            log(f"There was an error! Please check the log at {log_file}.")

            sys.exit(1)

        except KeyboardInterrupt:
            log("Aborting...", new_line=True)
            sys.exit(130)
        else:
            return func
    return inner_func


def join_list(lst: list, char="\n", number=True) -> list:
    if number:
        lst = [f"{i+1}) {lst[i]}" for i in range(0, len(lst))]
    return char.join(lst)


def get_input(msg: str, options="", char=":", input_char="=>", new_line=True):
    if options:
        opt = "\n" + options
    if new_line:
        new_line_char = '\n'
    return input(f"{msg}{char} {opt}{new_line_char}{input_char}")


def read_config(config_file) -> dict:
    import yaml
    with open(config_file, 'r') as file:
        config = yaml.load(file.read(), Loader=yaml.SafeLoader)
    return config


def run_command(cmd: str, err_msg: str, success_msg="", alt_cmd="", raise_exception=True, shell=False) -> None:
    try:
        cmd = os.path.expandvars(cmd)
        if shell:
            subprocess.check_call(cmd, shell=True)
        else:
            subprocess.check_call(cmd.split())

    except (subprocess.SubprocessError, Exception):
        if alt_cmd:
            run_command(alt_cmd, err_msg, success_msg)
        if raise_exception:
            raise Exception(err_msg)
    else:
        if success_msg:
            log(success_msg)


def install_py_req(requirements: list) -> None:
    installed = {pkg.key for pkg in pkg_resources.working_set}
    missing = set(requirements) - installed

    err_msg = "Couldn't setup Python. Please read the README.md for more info"
    success_msg = "Python setup successfully!"
    if missing:
        log("Setting up Python...")
        requires = " ".join(requirements)
        run_command(f"pip3 install {requires}",
                    err_msg, success_msg,
                    alt_cmd=f"pip install {requires}",
                    raise_exception=False)


def install_dependencies(config: dict, distro_name: str) -> None:
    log("Installing dependencies...")

    distro = config["distros"][distro_name]
    pkg_man = distro["pkg_man"]

    dep = config["dependencies"][distro_name]
    if not dep:
        log("There are no dependencies. Skipping...")
        return
    to_install = " ".join(dep)

    flags = distro["flags"] if "flags" in distro else ""

    command = f"{pkg_man} {to_install} {flags}"
    run_command(command, "Couldn't install dependencies", "Dependencies installed successfully!")


def install(config: dict, distro, distros) -> None:
    pkgs = config["install"]
    for pkg in pkgs:
        log(f"Installing {pkg}..")
        for cmd in pkgs[pkg]:
            if isinstance(cmd, dict):
                for command in cmd[distro]:
                    run_command(command, f"Couldn't install {pkg}.", shell=True)
            else:
                run_command(cmd, f"Couldn't install {pkg}.", shell=True)


# MAIN
@handle_errors
def main() -> None:
    install_py_req(REQUIREMENTS)

    config = read_config(CONFIG_FILE)
    distros = list(config["distros"])
    distro_input = int(get_input("Select your distro", join_list(distros)))
    distro = distros[distro_input-1]
    install_dependencies(config, distro)
    install(config, distro, distros)

    log("The installation was complete!")


if __name__ == "__main__":
    main()
