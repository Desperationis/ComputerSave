import yaml
import os

packageFile = open("config.yaml", "r")
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


def PrintOptions(options : list[str], selected : list[bool]):
    """
        Prints out the options in "1 Option" format. If any of the elements in
        options are found in selected, it will show as "(1) Option"
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

def CraftPackCommand(command : str, args : list[str]) -> str:
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

def GetPackages(option : str) -> list[str]:
    return config["packages"][option]


categories = [i for i in config["packages"]]
selected = []

while True:
    PrintOptions(categories, selected)
    userInput = GetUserInput(len(categories))

    if userInput.isQuit():
        break

    if userInput.isAccept():
        choice = input("Install or remove packages? [i/r] ")
        command = REMOVE_COMMAND if choice == "r" else INSTALL_COMMAND

        confirm = input("Are you sure? [y/n] ")
        if confirm == "y":
            for option in selected:
                packages = GetPackages(option)
                command = CraftPackCommand(command, packages)
                RunCommand(command)
            break

    if userInput.isNumber():
        option = categories[userInput.getNumber() - 1]

        if userInput.isUnselect():
            print("You unselected \"%s\".\n" % option)
            selected.remove(option)
        else:
            print("You selected \"%s\".\n" % option)
            selected.append(option)


