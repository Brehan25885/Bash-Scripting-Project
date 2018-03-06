#!/bin/bash

cd databases
create_menu(){
read -p "Create Database type 1 / Select Database type 2: " choice
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
test -d $Database_name && echo "The database already exists" || mkdir $Database_name || tables_menu

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
                            a) create_tables
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

create_menu
