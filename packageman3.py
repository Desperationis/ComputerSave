import os
import subprocess

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

class Playbook:
    def __init__(self, path : str, root : bool):
        self.set_root(root)
        self.set_path(path)

    def set_root(self, root : bool):
        self.root = root

    def set_path(self, path : str):
        self.path = os.path.abspath(path)

    def is_root(self) -> bool:
        return self.root

    def get_path(self) -> str:
        return self.path


def PrintOptions(options, selected):
    """
        Prints out the options in "1 Option" format. If any of the elements in
        options are found in selected, it will show as "(1) Option".

        options: List of strings
        selected: List of strings
    """

    print("Please select a playbook by number. End or start with ! to unselect.") 
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

        if userChoice.isNumber():
            optionChoice = userChoice.getNumber()
            if optionChoice < 1 or optionChoice > numOptions:
                print("That is not a menu option.")
                continue

            return userChoice


        print("That is not a number.")



# Scripts in ansible are executed in root
playbooks: dict[str, Playbook] = {}
for file in os.listdir("ansible/"):
    name = file.split('.')[0]
    abspath = os.path.join("ansible/", file)
    playbook = Playbook(path=abspath, root=True)
    playbooks[name] = playbook

if os.path.exists("ansible/no_root/"):
    for file in os.listdir("ansible/no_root/"):
        name = file.split('.')[0]
        abspath = os.path.join("ansible/no_root/", file)
        playbook = Playbook(path=abspath, root=False)
        playbooks[name] = playbook

options = list(playbooks.keys())
selected = []

while True:
    PrintOptions(options, selected)
    userInput = GetUserInput(len(options))

    if userInput.isQuit():
        break;

    if userInput.isNumber():
        option = options[userInput.getNumber() - 1]

        if userInput.isUnselect():
            print(f"You unselected \"{option}\". \n")
            if option in selected:
                selected.remove(option)

        else:
            print(f"You selected \"{option}\". \n")
            if option not in selected:
                selected.append(option)

    if userInput.isAccept():
        for option in selected:
            fullPath = playbooks[option].get_path()
            root = playbooks[option].is_root()
            command = []

            if root:
                command.append("sudo")

            command.extend(["ansible-playbook", fullPath])
            subprocess.run(command)

        break




