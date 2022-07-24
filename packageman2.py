import os
import sys
try:
    import yaml
except ModuleNotFoundError:
    print("Please install PyYaml via \"pip3 install PyYaml\"")
    sys.exit(1)


packageFile = open("packages.yaml", "r")
lines = "".join([line for line in packageFile])
config = yaml.load(lines, Loader=yaml.Loader)

INSTALL_COMMAND = config["install"]
REMOVE_COMMAND = config["remove"]

class UserChoice:
    def __init__(self, userInput : str):
        self._userInput = userInput

    def isNumber(self) -> bool:
        tmp = self._userInput.replace("!", "") 
        return tmp.isdigit()

    def getNumber(self) -> int:
        tmp = self._userInput.replace("!", "") 
        return int(tmp)

    def isUnselect(self) -> bool:
        return self._userInput.startswith("!") or self._userInput.endswith("!")

    def isAccept(self) -> bool:
        return self._userInput.lower() == "c"

    def isQuit(self) -> bool:
        return self._userInput.lower() == "q"


def PrintOptions(options, selected):
    """
        Prints out the options in "1 Option" format. If any of the elements in
        options are found in selected, it will show as "(1) Option".

        options: List of strings
        selected: List of strings
    """

    print("Please select a package number. End or start with ! to unselect.") 
    for i, option in enumerate(options):
        if option in selected:
            print("(%s) %s" % (i+1, option))
        else:
            print("%s %s" % (i+1, option))


def GetUserInput(numOptions : int) -> UserChoice:
    """
        Gets a valid UserChoice from the user.
    """
    while True:
        rawUserInput = input("Pack # [q/c]: ")
        userChoice = UserChoice(rawUserInput)

        if userChoice.isAccept() or userChoice.isQuit():
            return userChoice

        elif userChoice.isUnselect() and userChoice.isNumber():
            return userChoice

        elif userChoice.isNumber():
            optionChoice = userChoice.getNumber()
            if optionChoice < 1 or optionChoice > numOptions:
                print("That is not a menu option.")
                continue
            else:
                return userChoice

        print("That is not a number.")


def IsRoot() -> bool:
    # Root is always UID 0
    return os.geteuid() == 0

def CraftPackCommand(command, args) -> str:
    """
        command args...

        Where `args` is a list of strings (could be a single element too).

        `command` is a command template that MUST contain "{package}"
        somewhere to insert the packages.
    """
    argString = " ".join(args)
    return command.replace("{package}", argString)

def RunCommand(command : str):
    os.system(command)

def GetPackages(option : str):
    """
        Get a specific list of packages from the config file given a category
        name.
    """
    return config["packages"][option]


def GetScripts():
    """
        Returns a list of strings that are the relative paths of all scripts in
        packages.d/
    """
    return [os.path.join("packages.d/",f) for f in os.listdir("packages.d/") ]

def GetScriptNames(scripts):
    """
        Given a list of strings of path names, return a list that only contains
        the name of the file without extensions.
    """

    names = []
    for script in scripts:
        name = os.path.basename(script).split(".")[0]
        names.append(name)

    return names

def SetEnv(variable : str, value : str):
    os.environ[variable] = value



scriptNames = GetScriptNames(GetScripts())
categories = [i for i in config["packages"]]
categories.extend(scriptNames)
selected = []

while True:
    PrintOptions(categories, selected)
    userInput = GetUserInput(len(categories))

    if userInput.isQuit():
        break

    if userInput.isAccept():
        choice = input("Install or remove? [i/r] ")
        command = REMOVE_COMMAND if choice == "r" else INSTALL_COMMAND

        confirm = input("Are you sure? [y/n] ")
        if confirm == "y":
            for option in selected:
                if option in scriptNames:
                    SetEnv("REMOVE", "0")
                    if choice == "r":
                        SetEnv("REMOVE", "1")

                    RunCommand("bash packages.d/%s.bash" % option)
                else:
                    packages = GetPackages(option)
                    fullCommand = CraftPackCommand(command, packages)
                    RunCommand(fullCommand)
            break

    if userInput.isNumber():
        option = categories[userInput.getNumber() - 1]

        if userInput.isUnselect():
            print("You unselected \"%s\".\n" % option)
            selected.remove(option)
        else:
            print("You selected \"%s\".\n" % option)
            if option not in selected:
                selected.append(option)


