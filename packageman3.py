import os

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



# Load up playbooks as "filename" without extension
playbooks = {}
for file in os.listdir("ansible/"):
    name = file.split('.')[0]
    playbooks[name] = os.path.join("ansible/", file)
    playbooks[name] = os.path.abspath(playbooks[name])

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
            fullPath = playbooks[option]
            command = "sudo ansible-playbook {0}"

            # Use os.system instead of subprocess so that stdout is outputted as
            # the process is running and stdin is connected.
            os.system(command.format(fullPath))

        break




