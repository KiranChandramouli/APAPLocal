PROGRAM AA.ARR.ACT.COR
*
* This program is delete the extra data which is present in the 167th positon of the
* AA.ARRANGEMENT.ACTIVITY record
*
* Author    : Duggineni Haribabu (dharibabu@temenos.com)
* Client    : APAP
* Issue Ref :PACS00193785
*
    $INSERT I_COMMON
    $INSERT I_EQUATE

    F.AA.ARRANGEMENT.ACTIVITY = 'FBNK.AA.ARRANGEMENT.ACTIVITY'
    FN.AA.ARRANGEMENT.ACTIVITY = ''
    EXECUTE "COMO ON AA.ARR.ACT.COR"
    OPEN F.AA.ARRANGEMENT.ACTIVITY TO FN.AA.ARRANGEMENT.ACTIVITY ELSE
        PRINT "Unable to open ":F.AA.ARRANGEMENT.ACTIVITY:" file."
    END

*TUS START
*    SELECT FN.AA.ARRANGEMENT.ACTIVITY   ;* Select the FBNK.AA.ARRANGEMENT.ACTIVITY file
*    LOOP
*        READNEXT AA.ACT.ID ELSE
*            AA.ACT.ID = ''
*        END
*    WHILE AA.ACT.ID
*    SEL.STMT = "SELECT FN.AA.ARRANGEMENT.ACTIVITY"   ;* Select the FBNK.AA.ARRANGEMENT.ACTIVITY file
    SEL.STMT = "SELECT FBNK.AA.ARRANGEMENT.ACTIVITY"   ;* Select the FBNK.AA.ARRANGEMENT.ACTIVITY file
    CALL EB.READLIST(SEL.STMT,ID.LIST,'',ID.SELECTED,ERR)
    LOOP
        REMOVE AA.ACT.ID FROM ID.LIST SETTING POS
    WHILE AA.ACT.ID : POS
*TUS END
        TEMP.AA.ACT = ""
        IF LEN(AA.ACT.ID) EQ 18 THEN     ;* If it is USER activity then only go inside

*            READ R.AA.ACT FROM FN.AA.ARRANGEMENT.ACTIVITY,AA.ACT.ID ELSE ;*Tus Start
            CALL F.READ(F.AA.ARRANGEMENT.ACTIVITY,AA.ACT.ID,R.AA.ACT,FN.AA.ARRANGEMENT.ACTIVITY,R.AA.ACT.ERR)
            IF R.AA.ACT.ERR THEN  ;* Tus End
                PRINT "Unable able to read record ":AA.ACT.ID:" from FBNK.AA.ARRANGEMENT.ACTIVITY."
            END
            IF R.AA.ACT<167> NE "" THEN
                TEMP.AA.ACT = FIELD( R.AA.ACT, @FM, 1,48)
*  WRITE TEMP.AA.ACT TO FN.AA.ARRANGEMENT.ACTIVITY,AA.ACT.ID ;*Tus Start
                CALL F.WRITE(F.AA.ARRANGEMENT.ACTIVITY,AA.ACT.ID,TEMP.AA.ACT) ;* Tus End
                CALL JOURNAL.UPDATE('')
                CRT "                 Processed the AA.ARRANGEMENT.ACTIVITY record :":AA.ACT.ID
            END
        END

    REPEAT
    EXECUTE "COMO OFF AA.ARR.ACT.COR"
END
