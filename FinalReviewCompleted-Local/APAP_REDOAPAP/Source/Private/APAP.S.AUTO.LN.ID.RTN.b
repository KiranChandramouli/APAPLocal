* @ValidationCode : MjotOTA4NzE2ODAwOkNwMTI1MjoxNjgxMTk3ODM1NDQ1OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 12:53:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.S.AUTO.LN.ID.RTN
* ====================================================================================
*
*
*
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose : gives a Behaviour for fields
*
*
* Incoming:
* ---------
* NA
*
*
* Outgoing:
* ---------
* NA
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  :
* Date            :
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.CUSTOMER
    $INSERT I_System
    $INSERT I_GTS.COMMON
*
*************************************************************************
*

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
    FN.REDO.CREATE.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT'
    F.REDO.CREATE.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    APPL.NAME.ARR = "CUSTOMER"
    FLD.NAME.ARR = "NEW.LN.PROC"
    FLD.POS.ARR = ""
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    VAL.POS = FLD.POS.ARR<1,1>
RETURN

PROCESS:




    Y.RCA.ID = System.getVariable("CURRENT.RCA")

    IF E<1,1> EQ 'EB-UNKNOWN.VARIABLE' THEN
        E = "EB-NEW.LN.PROC.RCA.MISS"
        RETURN
    END
    CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,Y.RCA.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,Y.ARR.ERR)
    Y.CUSTOMER = R.REDO.CREATE.ARRANGEMENT<REDO.FC.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
    Y.VAL.PROC = R.CUSTOMER<EB.CUS.LOCAL.REF,VAL.POS>
    IF Y.VAL.PROC NE 'YES' THEN
        RETURN
    END
    Y.STATUS = R.REDO.CREATE.ARRANGEMENT<REDO.FC.LN.CREATION.STATUS>
    Y.ID.ARRANGEMENT = R.REDO.CREATE.ARRANGEMENT<REDO.FC.ID.ARRANGEMENT>
    GOSUB CHECK.STATUS
    GOSUB CHECK.ERR.VALUE

    READ R.AA.ARRANGEMENT FROM F.AA.ARRANGEMENT,Y.ID.ARRANGEMENT THEN
        E = "EB-NEW.LN.PROC.DONE":@FM:Y.ID.ARRANGEMENT
        RETURN
    END
RETURN

CHECK.STATUS:
    IF (Y.STATUS EQ "In Progress") OR (Y.STATUS EQ "In Queue") THEN
        E = "EB-NEW.LN.PROC.STAT":@FM:Y.STATUS
*        E = "Loan creation process is ": Y.STATUS
    END
RETURN

CHECK.ERR.VALUE:
    IF (Y.STATUS EQ "Error") THEN
        E = "EB-NEW.LN.PROC.ERR":@FM:Y.STATUS
*        E = "Loan Create process failed.View the Errors"
    END
RETURN


******************************FINAL END*************************************
END
