* @ValidationCode : MjotMTk4NDU3ODg2NTpDcDEyNTI6MTY4NDIyMjgzMjI4MDpJVFNTOi0xOi0xOjk4ODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 988
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*21/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*21/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.L.INTRANSIT.LOCK.CORR

**********************************************************************************
* Developed By : Ashokkumar
* Client Name  : APAP
* Description  : Routine to delete the unused or wrong locked record from the REDO.INTRANSIT.LOCK table.
**********************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
   $USING EB.TransactionControl


    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
******
    FN.SAVELIST = '&SAVEDLISTS&'; F.SAVELIST = ''
    OPEN FN.SAVELIST TO F.SAVELIST ELSE RETURN
    FN.REDO.INTRANSIT.LOCK = 'F.REDO.INTRANSIT.LOCK'; F.REDO.INTRANSIT.LOCK = ''
    CALL OPF(FN.REDO.INTRANSIT.LOCK,F.REDO.INTRANSIT.LOCK)
    SAVE.ID = 'REGISTER.TO.DELETE.csv'
    READ R.SAVELIST FROM F.SAVELIST,SAVE.ID ELSE RETURN
RETURN

PROCESS:
********
    LOOP
        REMOVE INTRANSIT.LOCK.ID FROM R.SAVELIST SETTING INT.POSN
    WHILE INTRANSIT.LOCK.ID:INT.POSN
        CRT INTRANSIT.LOCK.ID
        YINTRANSIT.LOCK.ID = FIELD(INTRANSIT.LOCK.ID,',',1)
        YAC.LOCK.ID = FIELD(INTRANSIT.LOCK.ID,',',2)
        ERR.REDO.INTRANSIT.LOCK = ''; R.REDO.INTRANSIT.LOCK = ''
*        CALL F.READ(FN.REDO.INTRANSIT.LOCK,YINTRANSIT.LOCK.ID,R.REDO.INTRANSIT.LOCK,F.REDO.INTRANSIT.LOCK,ERR.REDO.INTRANSIT.LOCK)
        CALL F.READU(FN.REDO.INTRANSIT.LOCK,YINTRANSIT.LOCK.ID,R.REDO.INTRANSIT.LOCK,F.REDO.INTRANSIT.LOCK,ERR.REDO.INTRANSIT.LOCK,'');* R22 UTILITY AUTO CONVERSION
        IF R.REDO.INTRANSIT.LOCK THEN
            LOCATE YAC.LOCK.ID IN R.REDO.INTRANSIT.LOCK SETTING YFM.POSN THEN
                DEL R.REDO.INTRANSIT.LOCK<YFM.POSN>
                YCNT = 0; YCNT = DCOUNT(R.REDO.INTRANSIT.LOCK,@FM)
                IF YCNT GE 1 THEN
                    CALL F.WRITE(FN.REDO.INTRANSIT.LOCK,YINTRANSIT.LOCK.ID,R.REDO.INTRANSIT.LOCK)
                END ELSE
                    CALL F.DELETE(FN.REDO.INTRANSIT.LOCK,YINTRANSIT.LOCK.ID)
                END
*                CALL JOURNAL.UPDATE('')
EB.TransactionControl.JournalUpdate('');* R22 UTILITY AUTO CONVERSION
            END
        END
    REPEAT

RETURN

END
