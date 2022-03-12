from PythonFileLibrary import *
import os

def GetPackages(fileReader, groupName : str) -> [str]:
    """
        Get all the packages that are listed under a "group", which is the name
        right next to ##.
    """ 

    fileReader.ResetCursor()

    content = []
    for line in fileReader:
        line = line.strip()
        if "//" in line:
            continue

        if "##" in line and groupName in line:
            fileReader.MoveCursorDown()
            line = fileReader.GetCurrentLine().strip()
            while len(line) != 0 and not fileReader.ReachedEnd():
                content.append(line)
                fileReader.MoveCursorDown()
                line = fileReader.GetCurrentLine().strip()

    fileReader.MoveCursorUp(1)

    return content

def GetGroups(fileReader) -> [str]:
    """
        Returns all the names of the groups ("Install" and "Remove" are not
        included). 
    """

    fileReader.ResetCursor()

    groups = []
    for line in fileReader:
        line = line.strip()
        if "##" not in line or "//" in line:
            continue

        group = line.replace("#", "").strip()
        if "Install" in line or "Remove" in line:
            continue

        groups.append(group)

    return groups


def IsRoot() -> bool:
    # Root is always UID 0
    return os.geteuid() == 0

def RunPackCommand(command : str, packages : [str]):
    packageString = " ".join(packages)
    os.system(command.replace("$package", packageString))

def PrintOptions(options : [str], selected : [bool]):
    """
        Prints out the options in "1 Option" format. If the corresponding
        index in selected is true, it shows up as "(1) Option"
    """

    print("Please select a package number. End or start with ! to unselect.") 
    groups = GetGroups(fileReader)
    for i, group in enumerate(groups):
        if selected[i]:
            print("(" + str(i + 1) + ") " + group)
        else:
            print(str(i + 1) + " " + group)


def GetUserInput(numOptions : int) -> [str, int]:
    """
        Gets an integer from the user, (1, numOptions],
        or "c" or "q". Returns [original message, int(message)].
        Ignores any !.
    """
    while True:
        rawUserInput = input("Pack # [q/c]: ")
        userInput = rawUserInput.replace("!", "").strip()

        if userInput in ["q", "c"]:
            return [rawUserInput, userInput]
        if userInput.isdigit():
            userInput = int(userInput)
            if userInput < 1 or userInput > numOptions:
                print("That is not a menu option.")
                continue
            else:
                return [rawUserInput, userInput]

        print("That is not a number.")

#if not IsRoot():
#    print("Please run this as root.")
#    quit()


fileReader = FileReader("packages.txt")
groups = GetGroups(fileReader)
selected = [False] * len(groups)

installCommand = GetPackages(fileReader, "Install")[0]
removeCommand = GetPackages(fileReader, "Remove")[0]

## GUI
userInput = ""
while True:
    PrintOptions(groups, selected)
    userInput = GetUserInput(len(groups))
    originalInput = userInput[0]
    menuChoice = userInput[1]
    if menuChoice == "q":
        break

    if menuChoice == "c":
        command = installCommand
        choice = input("Install or remove packages? [i/r] ")
        if choice == "r":
            command = removeCommand

        confirm = input("Are you sure? [y/n] ")
        if confirm == "y":
            for i, group in enumerate(groups):
                if selected[i]:
                    content = GetPackages(fileReader, group)
                    RunPackCommand(command, content)
            break
        else:
            continue

    if "!" in originalInput:
        print("You unselected \"" + groups[menuChoice - 1] + "\".\n")
    else:
        print("You selected \"" + groups[menuChoice - 1] + "\".\n")

    selected[menuChoice - 1] = not "!" in originalInput

    




