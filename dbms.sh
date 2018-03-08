#!/bin/bash

cd databasess
create_menu(){
read -p "Create Database type 1
Select Database type 2
" choice
case $choice in
"1") create_database
;;
"2") select_database
;;
*) exit 0
;;
esac

}
create_database(){
read -p "Enter Database name: " Database_name
if [[ -d $Database_name ]]
  then
    echo "The database already exists"
else
    mkdir $Database_name
    create_menu
  fi
}
tables_menu(){
              read -p "
              Create tables type a
              Select table type b
              Alter Table type c
              Add Record type d
              Edit Record[s] type e
              Delete Record[s] type f
              Select Record[s] type g
              Display Table type h
              Sort Table type i
              Drop Table j
              Exit k
              " option
              case $option in
                            a) create_table
                              ;;
                            b) select_table
                              ;;
                            c) alter_table
                                ;;
                            d) add_record
                              ;;
                            e) edit_record
                              ;;
                            f)delete_record
                            ;;
                            g)select_record
                            ;;
                            h)display_table
                            ;;
                            i)sort_table
                            ;;
                            j)drop_table
                            ;;
                            k) exit 0
                            ;;
                            *) exit 0
                            ;;
                          esac

}
select_database(){
  read -p "Enter Database name: " Database_name
  cd $Database_name
  tables_menu

}
create_table(){
read -p "Enter Table name: " table_name
if [[ -f $table_name ]]
  then
    echo "The table already exists"
else
  read -p "Enter Number of columns: " table_col
  count=1
  primary_key=""
   constraint="Field""|""Type""|""key"
    while [ $count -le $table_col ]
    do
      read -p "Enter column name number $count: " col_name
      read -p "Enter col type number $count:
               int type i
               varchar type c
               text type t
               date type d
               float type f
               " col_type
      case $col_type in
        i)vartype="int"
        ;;
        c)vartype="char"
        ;;
        t)vartype="text"
        ;;
        d)vartype="date"
        ;;
        f)vartype="float"
        ;;
        *) echo "wrong choice"
        ;;
        esac
        if [[ $primary_key=="" ]];then
        read -p "make primary key:yes press y no press n " p_choices
        case $p_choices in
          y) primary_key="Primary Key";
           constraint+="\n"$col_name"|"$vartype"|"$primary_key
           ;;
           n) constraint+="\n"$col_name"|"$vartype"|"""
           ;;
           *) echo "wrong choice"
           ;;
         esac
       else
         constraint+="\n"$col_name"|"$vartype"|"""
       fi
        if [[ $count == $table_col ]]; then
              temp=$temp$col_name
            else
              temp=$temp$col_name"|"
        fi



    ((count++))
    done
    touch .$table_name
    echo -e $constraint >> .$table_name
    touch $table_name
    echo -e $temp >> $table_name
    if [[ $? == 0 ]]
      then
        echo "Table Created Successfully"
  tables_menu
    else
      echo "Error Creating Table $tableName"
      tables_menu
      fi
  fi

}
drop_table (){
  read -p "Enter table name : " table_name
  rm $table_name
  if [[ $? == 0 ]]
  then
    echo "Table Dropped Successfully"
  else
    echo "Error Dropping Table $tName"
  fi
tables_menu

}

create_menu
