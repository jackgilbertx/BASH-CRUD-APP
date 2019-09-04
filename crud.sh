#!/bin/bash
#This script will maintain an editable contact list
contact_list=address_book.txt

confirm(){
until [[ $confirmed =~ [YN] ]] ; do
read -p "Are you sure? Y/N: " confirmed

if [[ $confirmed = "Y" ]] 
then
   echo ""
   echo "---Contact Deleted---"
elif  [[ $confirmed = "N" ]]
	then
	return 1; main_menu
else
  echo "Must choose either Y/N - press crtl+c to exit"
fi

done
confirmed=
}
keep_order(){
	sed -i 's/.*) //' $contact_list
	echo "$(awk '{print NR ")", $0}' $contact_list)" > $contact_list
	sed -i '/^.\{,3\}$/d' $contact_list
}
search_contact(){
    echo "[press q for main menu]"
	read -p "Enter name: " name
	if [[ $name =~ [qQ] ]] ; then 
	main_menu
	else
	grep -i "$name" $contact_list || echo "NO matches"  
    fi
}
add_contact(){
    echo "[press q for main menu]"
	sed -i '/^$/d' $contact_list
	line_number=($(wc -l $contact_list | awk '{ print $1 }'))
	line_num=$(( line_number + 1 ))
	read -p "Enter name: " name
	if [[ $name =~ [qQ] ]] ; then 
	main_menu
	fi
	read -p "Enter phone: " phone
	if [[ $phone =~ [qQ] ]] ; then 
	main_menu
	fi

		echo "$line_num) $name - $phone" >> $contact_list
		echo "--Contact Successfully Added---"
		echo ""

}
show_contacts(){
	echo ""
	echo "--CONTACTS--"
	cat $contact_list
	echo ""
}
delete_contact(){
lines=($(wc -l $contact_list | awk '{ print $1 }'))
echo "[press q for main menu]"
cat $contact_list
echo ""
until (( 1 <= x && x <= $lines )) || [[ $x =~ [qQ] ]] ; do
read -p "Choose valid number to delete contact: " x
done
 if [[ $x =~ [qQ] ]] ; then 
	 x= ; main_menu
 fi
confirm && sed -i "/^$x/ d" $contact_list
keep_order
x= ; main_menu

}
edit_contact(){
    lines=($(wc -l $contact_list | awk '{ print $1 }'))
    echo "[press q for main menu]"
	cat $contact_list
	echo ""
	until (( 1 <= y && y <= $lines )) || [[ $y =~ [qQ] ]] ; do
	read -p "Choose valid number to edit: " y
	done
	if [[ $y =~ [qQ] ]] ; then 
		y= ; main_menu
    fi
	ph_name=$(head -$y $contact_list | tail -1 | grep -Po '(?<=([ ^])).*(?= [-])')
	ph_phone=$(head -$y $contact_list | tail -1 | grep -oP '(?<=- ).*')
	read -e -p  "Edit Name: " -i "$ph_name" name_edit
	read -e -p "Edit Phone: " -i "$ph_phone" phone_edit
		sed -i "/^$y/c$y) ${name_edit} - ${phone_edit}" $contact_list 
		echo "---Contact Edited---" 
		y= ; main_menu
}

main_menu(){
echo ""
echo "------CRUD APP------"
select action in Search Add Edit Delete Show Exit
do
case $action in

	Search) search_contact ;;
	Add)    add_contact ;;
	Edit)   edit_contact ;;
	Delete) delete_contact ;;
	Show) show_contacts ;;
	Exit) exit ;;
	*) echo "Must choose 1-6" ;;
esac
done
echo ""
}
main_menu

#place-holder for edit function
#grep -Po '(?<=([ ^])).*(?= [-])' $contact_list