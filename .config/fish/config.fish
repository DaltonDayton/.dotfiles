if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Define the ll abbreviation
abbr --add ll 'ls -AFhosv'

# Define a function that first clears the screen and then uses the same command as the ll abbreviation
function clear_and_list
    clear
    ls -AFhosv
end

# Create an abbreviation for the clear_and_list function
abbr --add cll clear_and_list

abbr --add githist "git log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --graph --date=short --date-order"
