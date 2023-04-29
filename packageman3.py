import os
import subprocess

class UserChoice:
    """
        Processes what characters in input correspond to which action.
    """

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

class AnsiblePlaybook:
    """
        Run an ansible playbook with or without root.
    """

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

    def run(self):
        command = []

        if self.is_root():
            command.append("sudo")

        command.extend(["ansible-playbook", self.get_path()])
        subprocess.run(command)

class TermColors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'



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
        rawUserInput = input("Playbook Number [q/c]: ")
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

def IsRoot() -> bool:
    return os.geteuid() == 0



############## MAIN PROGRAM ####################




if not IsRoot():
    print(f"{TermColors.OKCYAN}You are not root, only non-root playbooks will be listed.")
else:
    print(f"{TermColors.WARNING}You are root, all playbooks are listed.")

print("Your HOME is " + os.environ.get("HOME", "N/A") + TermColors.ENDC + "\n")



playbooks: dict[str, AnsiblePlaybook] = {}


# Scripts in 1st level run as root
if IsRoot():
    for file in os.listdir("ansible/"):
        relpath = os.path.join("ansible", file)
        if os.path.isfile(relpath):
            name = file.split('.')[0]
            playbook = AnsiblePlaybook(path=relpath, root=True)
            playbooks[name] = playbook

# Scripts in 2nd level run without root
if os.path.exists("ansible/no_root/"):
    for file in os.listdir("ansible/no_root/"):
        relpath = os.path.join("ansible/no_root/", file)

        if os.path.isfile(relpath):
            name = file.split('.')[0]
            playbook = AnsiblePlaybook(path=relpath, root=False)
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
            playbooks[option].run()

        break




