SUBROUTINE REDO.AUT.LOCK.CHQ
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SRIRAMAN.C
* Program Name  : REDO.AUT.LOCK.CHQ
*-------------------------------------------------------------------------
* Description: This routine is a Auto New Content routine
*
*----------------------------------------------------------
* Linked with:  REDO.CLEARING.OUTWARD, FLOAT.EXT
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 25-11-10          ODR-2010-09-0251              Initial Creation
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DATES
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.REDO.CLEARING.OUTWARD


    GOSUB INIT
    GOSUB OPEN.FILE
    GOSUB PROCESS

RETURN

******
INIT:
******
    Y.FROM.DATE = ''
    Y.EXPOSURE.DATE = ''
    Y.TO.DATE = ''
    R.REC=''
RETURN
*********
OPEN.FILE:
*********


    FN.AC.LOC.ACC = 'F.AC.LOCKED.EVENTS'
    F.AC.LOC.ACC = ''
    CALL OPF(FN.AC.LOC.ACC,F.AC.LOC.ACC)

RETURN

*********
PROCESS:
********

    Y.TO.DATE = R.NEW(CLEAR.OUT.EXPOSURE.DATE)
    Y.FROM.DATE = R.OLD(CLEAR.OUT.EXPOSURE.DATE)
    Y.DATE = R.OLD(CLEAR.OUT.EXPOSURE.DATE)
    IF Y.DATE THEN
        YREGION = ''
        YDAYS.ORIG = '+1C'
        CALL CDT (YREGION,Y.DATE,YDAYS.ORIG)
        Y.FROM.DATE = Y.DATE
    END
    Y.ACCOUNT.NUMBER = R.NEW(CLEAR.OUT.ACCOUNT)
    Y.AMOUNT = R.NEW(CLEAR.OUT.AMOUNT)
    DESCRIPTION = ID.NEW

    R.REC<AC.LCK.FROM.DATE> = Y.FROM.DATE
    R.REC<AC.LCK.TO.DATE> = Y.TO.DATE
    R.REC<AC.LCK.ACCOUNT.NUMBER> = Y.ACCOUNT.NUMBER
    R.REC<AC.LCK.LOCKED.AMOUNT> = Y.AMOUNT
    R.REC<AC.LCK.DESCRIPTION> = DESCRIPTION

    OFSVERSION = "AC.LOCKED.EVENTS,REDO"
    OFSFUNCTION = 'I'
    PROCESS = 'PROCESS'
    OFS.SOURCE.ID = 'REDO.CHQ.ISSUE'
    APP.NAME = 'AC.LOCKED.EVENTS'
    GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = ''
    OFSSTRING = ''


    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCTION,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.REC,OFSSTRING)
    CALL OFS.POST.MESSAGE(OFSSTRING,OFS.MSG.ID,OFS.SOURCE.ID,OFS.OP)

RETURN

*********************
END

*End of program
