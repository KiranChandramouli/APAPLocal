* @ValidationCode : MjotOTEwMjUyODk5OkNwMTI1MjoxNjgwNzY4OTcxODk0OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 13:46:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.DISP.MSG
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This subroutine would show a override message, which would deliver
* the user a message if the option for the field, STOPPAYMENT.STATUS has been
* selected as Non-Confirmed
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
** Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference                       Description
* 25-Nov-2009       SHANKAR RAJU                                    Initial Creation
* 08-May-2012       Pradeep S        PACS00195882                   Override handling
*06-04-2023         Conversion Tool   R22 Auto Code conversion      VM TO @VM , ++ TO +=1
*06-04-2023          Samaran T        Manual R22 Code Conversion    No Changes

*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.OVERRIDE
    $INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT
    $INSERT I_F.OFS.SOURCE
    $INSERT I_GTS.COMMON

*------------------------------MAIN------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------

*------------------------------INIT------------------------------------------
INIT:

    CURR.NO = 0
    CALL STORE.OVERRIDE(CURR.NO)          ;* PACS00195882 - S/E

    FN.REDO.PAYMENT.STOP.ACCOUNT='F.REDO.PAYMENT.STOP.ACCOUNT'
    F.REDO.PAYMENT.STOP.ACCOUNT =''
    CALL OPF(FN.REDO.PAYMENT.STOP.ACCOUNT,F.REDO.PAYMENT.STOP.ACCOUNT)
RETURN
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
PROCESS:
    Y.FLAG = ''
    Y.FROM = R.NEW(REDO.PS.ACCT.AMT.FROM)
    Y.TO = R.NEW(REDO.PS.ACCT.AMT.TO)
    Y.COUNT = DCOUNT(Y.FROM,@VM)
    Y.CNT =1
    LOOP
    WHILE Y.CNT LE Y.COUNT
        Y.AMT.FR = Y.FROM<1,Y.CNT>
        Y.AMT.TO = Y.TO<1,Y.CNT>
        R.NEW(REDO.PS.ACCT.AMT.FROM)<1,Y.CNT> = FMT(Y.AMT.FR,"R2#10")
        R.NEW(REDO.PS.ACCT.AMT.TO)<1,Y.CNT>   = FMT(Y.AMT.TO,"R2#10")
        Y.CNT += 1
    REPEAT
    STATUS.PAY = R.NEW(REDO.PS.ACCT.PAY.STOP.STATUS)
    STATUS.COUNT = DCOUNT(STATUS.PAY,@VM)
    START.COUNT = 1
    LOOP
    WHILE START.COUNT LE STATUS.COUNT
        IF R.NEW(REDO.PS.ACCT.PAY.STOP.STATUS)<1,START.COUNT> EQ 'NONCONFIRMED' THEN
            OVERRIDE.FLAG = 1
        END
        START.COUNT += 1
    REPEAT
    Y.FLAG  = R.NEW(REDO.PS.ACCT.OVERRIDE)
    IF OVERRIDE.FLAG THEN
        IF Y.FLAG THEN
            CNT=DCOUNT(R.NEW(REDO.PS.ACCT.OVERRIDE),@VM)
            R.NEW(REDO.PS.ACCT.OVERRIDE) = ''
            GOSUB OVERRIDE.MESSAGE
        END ELSE
            CNT=DCOUNT(R.NEW(REDO.PS.ACCT.OVERRIDE),@VM)
            GOSUB OVERRIDE.MESSAGE
        END
    END

RETURN
*******************
OVERRIDE.MESSAGE:
********************
    TEXT = 'OVERRIDE1'
    CALL STORE.OVERRIDE(CNT+1)
    TEXT = 'OVERRIDE2'
    CALL STORE.OVERRIDE(CNT+2)
    TEXT = 'OVERRIDE3'
    CALL STORE.OVERRIDE(CNT+3)
    TEXT = 'OVERRIDE4'
    CALL STORE.OVERRIDE(CNT+4)
    TEXT = 'OVERRIDE5'
    CALL STORE.OVERRIDE(CNT+5)
    TEXT = 'OVERRIDE6'
    CALL STORE.OVERRIDE(CNT+6)
    TEXT = 'OVERRIDE7'
    CALL STORE.OVERRIDE(CNT+7)

RETURN
*----------------------------------------------------------------------------
END
