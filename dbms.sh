#!/bin/bash
database_name="databasess"
if ! [[ -d $database_name ]]
  then
    mkdir databasess
  fi
cd databasess
create_menu(){
read -p "Create Database type 1
Select Database type 2
Exit type 0
" choice
case $choice in
"1") create_database
;;
"2") select_database
;;
"0") exit 0
;;
*) create_menu
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
  if ! [[ -d $Database_name ]]; then
    echo "

    The database doesn't exist

"
    create_menu
  else
  cd $Database_name
fi
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
               text type t
               date type d
               " col_type
      case $col_type in
        i)vartype="int"
        ;;
        t)vartype="text"
        ;;
        d)vartype="date"
        ;;
        *) echo "wrong choice"
        ;;
        esac
        if [[ $primary_key == "" ]];then
        read -p "make primary key:yes press y no press n " p_choices
        case $p_choices in
          y) primary_key="PrimaryKey"
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
  if ! [[ -f $table_name ]]
    then
      echo "The table doesn't exist"
      tables_menu
    fi
  rm $table_name
  rm .$table_name

  if [[ $? == 0 ]]
  then
    echo "Table Dropped Successfully"
  else
    echo "Error Dropping Table $tName"
  fi
tables_menu

}
add_record(){
  read -p "Enter table name : " table_name
  if ! [[ -f $table_name ]]
    then
      echo "The table doesn't exist choose another table"
else
   num_col=`awk 'END{print NR}' .$table_name`
  for (( i = 2; i <= $num_col; i++ )); do
    colName=$(awk 'BEGIN{FS="|"}{ if(NR=='$i') print $1}' .$table_name)
    colType=$( awk 'BEGIN{FS="|"}{if(NR=='$i') print $2}' .$table_name)
    colKey=$( awk 'BEGIN{FS="|"}{if(NR=='$i') print $3}' .$table_name)
    echo -e "$colName ($colType) = \c"
    read data

    if [[ $colType == "int" ]]; then
    while ! [[ $data =~ ^[0-9]*$ ]]; do
      echo -e "invalid DataType !!"
      echo -e "$colName ($colType) = \c"
      read data
    done
    fi

  if [[ $colType == "text" ]]; then
  while ! [[ $data =~ ^[a-zA-Z]*$ ]]; do
    echo -e "invalid DataType !!"
    echo -e "$colName ($colType) = \c"
    read data
  done
fi
if [[ $colType == "date" ]]; then
  while ! [[ $data =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; do
  echo -e "invalid DataType insert date as YYYY-MM-DD"
  echo -e "$colName ($colType) = \c"
  read data
done
fi



  if [[ $colKey == "PrimaryKey" ]]; then
        while [[ true ]]; do
          if [[ $data =~ ^[`awk 'BEGIN{FS="|" ; ORS=" "}{if(NR != 1)print $(('$i'-1))}' $table_name`]$ ]]; then
              echo -e "invalid input for Primary Key !!"
            elif [[ $data == "" ]]; then
                echo -e "please enter value "
                  else
                      break;
            fi
          echo -e "$colName ($colType) = \c"
          read data
        done
  fi


  if [[ $i == $num_col ]]; then
     row=$row$data"\n"
   else
     row=$row$data"|"
   fi
 done
 echo -e $row"\c" >> $table_name

 if [[ $? == 0 ]]
 then
   echo "Data Inserted Successfully"
 else
   echo "Error Inserting Data into Table $table_name"
 fi

 row=""
fi
 tables_menu


}

function select_record() {
  read -p "
            select table type a
            select by col type b
            select by row type c
            back to the main menu 0
            Exit k
  " option
  case $option in
                a) read -p "Enter table name : " table_name
                if [ -f $table_name ]; then
                  cat $table_name
                  echo "<html>" > $table_name.html

                  echo "<Body>" >> $table_name.html

                  awk 'BEGIN{FS="|"; print "<table border="1">"} {print "<tr>";for(i=1;i<=NF;i++)print "<td>" $i"</td>";print "</tr>"} END{print "</table>"}' $table_name >> $table_name.html

                  echo "</Body>" >> $table_name.html

                  echo "</html>" >> $table_name.html

                  echo "open the html file ^_^"


                else
                  echo "The table doesn't exist in the database"
                fi
                  ;;
                b) read -p "Enter table name : " table_name
                  read -p "Enter the col number: " col_no
                field_no=$(awk -F'|' '{print NF; exit}' $table_name)
                field=$(( field_no ))
                if [ $col_no -gt $field ]; then
                    echo "The field number doesn't exists"
                    select_record
                  fi
                if [ -f $table_name ]; then
                      if [ $col_no -le $field ]
                      then
                        touch temp
                        cat $table_name | cut -d '|' -f "$col_no" > temp
                        echo "<html>" > $table_name.html

                        echo "<Body>" >> $table_name.html

                         awk 'BEGIN{print "<table border="1">"} {print "<tr>";print "<td>" $0"</td>";print "</tr>"} END{print "</table>"}' temp >> $table_name.html

                        echo "</Body>" >> $table_name.html

                        echo "</html>" >> $table_name.html
                        echo "open the html file ^_^"
                    else
                      echo "column number not found"
                    fi

                else
                  echo " The table doesn't exist in the database"
                fi
                  ;;
                c) read -p "Enter table name : " table_name
                  read -p "Enter the row number: " row_no
                if [ -f $table_name ]; then
                      row_num=$(cat $table_name | wc -l)
                    row=$(( row_num ))
                    if [ $row_no -gt $row ]; then
                      echo "The row number doesn't exist"
                      select_record
                    elif [ $row_no -le $row ]
                      then
                        touch temp

                        cat $table_name | head -1 > temp
                        cat $table_name | sed -n "$row_no"p >> temp
                        echo "<html>" > $table_name.html

                        echo "<Body>" >> $table_name.html
                        awk 'BEGIN{FS="|"; print "<table border="1">"} {print "<tr>";for(i=1;i<=NF;i++)print "<td>" $i"</td>";print "</tr>"} END{print "</table>"}' temp >> $table_name.html
                        echo "</Body>" >> $table_name.html
                        echo "</html>" >> $table_name.html
                        echo "open the html file ^_^"

                        else
                      echo "column number not found"
                    fi

                else
                  echo " The table doesn't exist in the database"
                fi
                    ;;
                "0") tables_menu
                ;;
                k) exit 0
                ;;
                *) exit 0
                ;;
              esac

  tables_menu
}

function delete_record() {
  echo -e "Enter Table Name: \c"
  read table_name
  if ! [[ -f $table_name ]]
    then
      echo "The table doesn't exist"
      tables_menu
    fi
  echo -e "Enter val: \c"
  read val
del=$(sed -i "/$val/d" $table_name)
if [[ $? == 0 ]]
then
  echo "row Deleted Successfully"
else
  echo "Error deleting Data"
fi
tables_menu

}
function edit_record {
  read -p "Enter table name : " table_name
  if ! [[ -f $table_name ]]
    then
      echo "The table doesn't exist"
      tables_menu
    fi
  read -p "Enter col name : " field
field_name=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $table_name)
  if [[ $field_name == "" ]]
  then
    echo "Not Found"
    tables_menu
  else
    read -p "Enter value to be updated: " old_val
    result=$(cat $table_name | grep "$old_val")
      if [[ $result == "" ]]
      then
        echo "Value Not Found"
      tables_menu
     else
      read -p "Enter the new value: " newvalue
      update=$(sed -i "s/$old_val/$newvalue/g" $table_name)
      echo "The field was updated Successfully"
       fi
    fi
    tables_menu

}


function alter_table() {
  read -p "
            changing table name type c
            add a new field type a
            delete a field type d
            changing the datatype of a certain field type t
            change col name type f
            back to the main menu type 0
           " option
  case $option in
    c) renameTable
    ;;
    a)newField
    ;;
    d)deleteField
    ;;
    t)changeType
    ;;
    f)changeField
    ;;
    "0")tables_menu
    ;;
    *) echo "wrong choice"
    tables_menu
    ;;
    esac
  }
  function deleteField() {

    read -p "Enter table name : " table_name
    if ! [[ -f $table_name ]]
      then
        echo "The table doesn't exist"
        alter_table
      fi
    read -p "Enter the field name: " col_name
    field_no=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$col_name'") print i}}}' $table_name)
    echo "$field_no"
    if [[ $field_no == "" ]]
    then
      echo "Not Found"
      tables_menu
    else
      touch t
    fie=$(( field_no ))
    result=$(cat $table_name | cut -d '|' --complement -f "$fie")
    echo "$result" >> t
    echo "$result"
    mv t $table_name

      echo "the field was deleted Successfully"
    fi
    tables_menu

  }
  function newField() {

    read -p "Enter table name : " table_name
    if ! [[ -f $table_name ]]
      then
        echo "The table doesn't exist"
        alter_table
      fi
    read -p "Enter the new col name : " new_col
    read -p "Enter the new col type: " new_type
    case $new_type in
    "int")type="int"
    ;;
    "text")type="text"
    ;;
    "date")type="date"
    ;;
    *)echo "wrong choice"
    ;;
    esac
    #field_no=$(awk 'BEGIN{FS="|"}{if(NR==1){ print $0 "|",$new_col }}' $table_name)
    field_no= $(sed -i "1 s/$/|$new_col/" $table_name)
    echo "$new_col|$type" >> .$table_name
    echo "$field_no"
    echo "The field was added Successfully"
    tables_menu
  }
function renameTable() {

  read -p "Enter table name : " table_name
  if ! [[ -f $table_name ]]
    then
      echo "The table doesn't exist"
      alter_table
    fi
  read -p "Enter the new name : " new_val
  mv $table_name $new_val
  mv .$table_name .$new_val
  echo "The file name was renamed Successfully"

}

  function changeType {
    read -p "Enter table name : " table_name
    if ! [[ -f $table_name ]]
      then
        echo "The table doesn't exist"
        alter_table
      fi
    read -p "Enter col name : " field
  field_no=$(awk "/$field/{ print NR; exit }" .$table_name)
  echo "$field_no"
    if [[ $field_no == "" ]]
    then
      echo "Not Found"
      tables_menu
    else
      read -p "Enter data type to be updated: " old_val
      result=$(cat .$table_name | grep "$old_val")
        if [[ $result == "" ]]
        then
          echo "Value Not Found"
        tables_menu
       else
        read -p "Enter the new value: " newvalue
        case $newvalue in
        "int")type="int"
        ;;
        "text")type="text"
        ;;
        *) echo "wrong choice"
          tables_menu
        ;;
        esac



        update=$(sed -i "$field_no s/$old_val/$type/g" .$table_name)
        echo "The field was updated Successfully"
         fi
      fi
      tables_menu

  }

  function changeField(){
  read -p "Enter table name : " table_name
  if ! [[ -f $table_name ]]
    then
      echo "The table doesn't exist"
      alter_table
    fi
  read -p "Enter col name : " field
field_name=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $table_name)
  if [[ $field_name == "" ]]
  then
    echo "Not Found"
    tables_menu
  else
    read -p "Enter the new value: " newvalue
    result=$(cat $table_name | grep "$field")
    update=$(sed -i "s/$field/$newvalue/g" $table_name)
    update2=$(sed -i "s/$field/$newvalue/g" .$table_name)
    echo "The field was updated Successfully"

    fi
    tables_menu

}

display_table(){
  read -p "Enter table name: " table_name
  if ! [[ -f $table_name ]]
    then
      echo "The table doesn't exist"
      tables_menu
    fi
 cat .$table_name
 tables_menu

}
sort_table(){
  read -p "Enter table name : " table_name
  if ! [[ -f $table_name ]]
    then
      echo "The table doesn't exist"
      tables_menu
    fi
  read -p "Enter the field name: " col_name
  field_no=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$col_name'") print i}}}' $table_name)
  if [[ $field_no == "" ]]
  then
    echo "Not Found"
    tables_menu
else
fieldN=$(( field_no ))
    head -n1 $table_name
    sed 1d $table_name | sort -V -k "$fieldN"
fi
tables_menu

}
create_menu
