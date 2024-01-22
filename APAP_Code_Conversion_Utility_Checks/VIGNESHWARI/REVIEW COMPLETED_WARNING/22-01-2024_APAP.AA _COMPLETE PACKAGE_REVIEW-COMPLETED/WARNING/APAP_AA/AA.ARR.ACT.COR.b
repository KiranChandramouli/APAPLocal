* @ValidationCode : MjotMTk2MDUzNTI0NjpDcDEyNTI6MTcwMzE5OTQzNDc5MTp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Dec 2023 04:27:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA ;*MANUAL R22 CODE CONVERSION
PROGRAM AA.ARR.ACT.COR

*-----------------------------------------------------------------------------------
* Modification History:
*

*DATE                 WHO                  REFERENCE                    DESCRIPTION

*28/03/2023         SURESH        MANUAL R22 CODE CONVERSION    Package Name added APAP.AA
* 28/03/2023      Conversion Tool        AUTO R22 CODE CONVERSION          FM to @FM,= to EQ
*21-12-2023        VIGNESHWARI      MANUAL R22 CODE CONVERSION      CHANGED F.READ TO F.READU,OPF IS CALL,CALL RTN MODIFIED
*-----------------------------------------------------------------------------------
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
    $USING EB.TransactionControl

    F.AA.ARRANGEMENT.ACTIVITY = 'FBNK.AA.ARRANGEMENT.ACTIVITY'
    FN.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(F.AA.ARRANGEMENT.ACTIVITY,FN.AA.ARRANGEMENT.ACTIVITY)  ;*MANUAL R22 CODE CONVERSION-CHANGED F.READ TO F.READU,OPF IS CALL
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
        IF LEN(AA.ACT.ID) EQ 18 THEN     ;* If it is USER activity then only go inside ;*AUTO R22 CODE CONVERSION

*            READ R.AA.ACT FROM FN.AA.ARRANGEMENT.ACTIVITY,AA.ACT.ID ELSE ;*Tus Start
            *CALL F.READ(F.AA.ARRANGEMENT.ACTIVITY,AA.ACT.ID,R.AA.ACT,FN.AA.ARRANGEMENT.ACTIVITY,R.AA.ACT.ERR)
            CALL F.READU(F.AA.ARRANGEMENT.ACTIVITY,AA.ACT.ID,R.AA.ACT,FN.AA.ARRANGEMENT.ACTIVITY,R.AA.ACT.ERR,"")   ;*MANUAL R22 CODE CONVERSION-CHANGED F.READ TO F.READU , Variable Modified the position in F.READ
            IF R.AA.ACT.ERR THEN  ;* Tus End
                PRINT "Unable able to read record ":AA.ACT.ID:" from FBNK.AA.ARRANGEMENT.ACTIVITY."
            END
            IF R.AA.ACT<167> NE "" THEN
                TEMP.AA.ACT = FIELD( R.AA.ACT, @FM, 1,48) ;*AUTO R22 CODE CONVERSION
*  WRITE TEMP.AA.ACT TO FN.AA.ARRANGEMENT.ACTIVITY,AA.ACT.ID ;*Tus Start
                CALL F.WRITE(F.AA.ARRANGEMENT.ACTIVITY,AA.ACT.ID,TEMP.AA.ACT) ;* Tus End
*CALL JOURNAL.UPDATE('')
                EB.TransactionControl.JournalUpdate('') ;*MANUAL R22 CODE CONVERSION-CALL RTN MODIFIED
                CRT "                 Processed the AA.ARRANGEMENT.ACTIVITY record :":AA.ACT.ID
            END
        END

    REPEAT
    EXECUTE "COMO OFF AA.ARR.ACT.COR"
END
