* @ValidationCode : MjotNjUzMzY3NjU5OkNwMTI1MjoxNzA0NDQ3MDMyNTE1OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 15:00:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPD.LT.USER.LIMITS(Y.ID)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.B.UPD.LT.USER.LIMITS
*--------------------------------------------------------------------------------------------------------
*Description       : The routine is the process routine for the multi threaded job, the routine
*                    nullify the values in the date field based on certain conditon
*In Parameter      : Y.ID
*Out Parameter     :
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                Reference                      Description
*   ------         ------             -------------                    -------------
*  11/11/2010    A.SabariKumar        ODR-2010-07-0075                Initial Creation
*  08/04/2011    Pradeep S            PACS00036002                    Removed section NULL.MM.LIM.DATE &
*                                                                     NULL.SC.LIM.DATE
*  20/10/2011    Pradeep S            PACS00149084                    Write to REDO.APAP.FX.BRN.POSN  is
*                                                                     removed
* Date                   who                   Reference
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                R22 UTILITY AUTO CONVERSION   Change F.READ to F.READU
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.UPD.LT.USER.LIMITS.COMMON
    $INSERT I_F.REDO.APAP.FX.BRN.POSN
    $INSERT I_F.REDO.APAP.FX.BRN.COND
    $INSERT I_F.REDO.APAP.USER.LIMITS

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

*--------------------------------------------------------------------------------------------------------
INITIALISE:
***********

    Y.INIT = ''
    Y.CNTR = ''
    Y.APPLICATION = ''
    Y.LST.WORKING.DAY = ''
    R.USER.LIMIT = ''
    R.REDO.APAP.FX.BRN.COND = ''
    R.REDO.APAP.FX.BRN.POSN = ''
    R.LOG.REC = ''
RETURN

*--------------------------------------------------------------------------------------------------------
PROCESS:
***********

*    CALL F.READ(FN.REDO.APAP.USER.LIMITS,Y.ID,R.USER.LIMIT,F.REDO.APAP.USER.LIMITS,F.ERR)
    CALL F.READU(FN.REDO.APAP.USER.LIMITS,Y.ID,R.USER.LIMIT,F.REDO.APAP.USER.LIMITS,F.ERR,'');* R22 UTILITY AUTO CONVERSION
*CALL F.READ(FN.DATES,ID.COMPANY,R.DATE,F.DATES,ERR)
    Y.LST.WORKING.DAY = TODAY
*R.DATE<EB.DAT.LAST.WORKING.DAY>
    Y.APPLICATION = R.USER.LIMIT<REDO.USR.LIM.APPLICATION>
    CHANGE @VM TO @FM IN Y.APPLICATION
    Y.CNTR = DCOUNT(Y.APPLICATION,@FM)
    Y.INIT = 1
    Y.SIN.TXN.DATE = ''
    Y.TOT.TXN.DATE = ''
    Y.TRADER.LIM.DATE = ''
    LOOP
    WHILE Y.INIT LE Y.CNTR
        Y.SIN.TXN.DATE = R.USER.LIMIT<REDO.USR.LIM.SIN.TXN.LIM.DATE,Y.INIT>
        Y.TOT.TXN.DATE = R.USER.LIMIT<REDO.USR.LIM.TOT.TXN.LIM.DATE,Y.INIT>
        Y.TRADER.LIM.DATE = R.USER.LIMIT<REDO.USR.LIM.TRA.LIM.VALID.DATE,Y.INIT>
        GOSUB NULLIFY.USR.LIM
        Y.INIT + = 1
    REPEAT
    GOSUB NULL.BPS.DATE
*PACS00036002 - S
* GOSUB NULL.MM.LIM.DATE                                                                                                                             E
* GOSUB NULL.SC.LIM.DATE
*PACS00036002 - E

    CALL F.WRITE(FN.REDO.APAP.USER.LIMITS,Y.ID,R.USER.LIMIT)
*PACS00037714 - S
    IF R.LOG.REC THEN
        Y.TXN.DTLS.ID = Y.ID:"-":Y.LST.WORKING.DAY
        CALL F.WRITE(FN.REDO.APAP.USER.TXN.DTLS,Y.TXN.DTLS.ID,R.LOG.REC)
    END
*PACS00037714 - E

*PACS00149084 - S
*CALL F.READ(FN.REDO.APAP.FX.BRN.POSN,ID.COMPANY,R.REDO.APAP.FX.BRN.POSN,F.REDO.APAP.FX.BRN.POSN,ERR)
*R.REDO.APAP.FX.BRN.POSN<REDO.BRN.POSN.BRN.TDY.TXN.VALUE> = ''
*CALL F.WRITE(FN.REDO.APAP.FX.BRN.POSN,ID.COMPANY,R.REDO.APAP.FX.BRN.POSN)
*PACS00149084 - E

    R.REDO.APAP.FX.BRN.COND<REDO.BRN.COND.FX.POSN> = ''
    CALL F.WRITE(FN.REDO.APAP.FX.BRN.COND,Y.ID2,R.REDO.APAP.FX.BRN.COND)
RETURN

*--------------------------------------------------------------------------------------------------------
NULLIFY.USR.LIM:
*-------------------

    GOSUB NULL.SIN.TXN.DATE
    GOSUB NULL.TOT.TXN.DATE
    GOSUB NULL.TRA.LIM.DATE
    GOSUB LOG.AMT.DTLS
    R.USER.LIMIT<REDO.USR.LIM.DLY.TOT.TXN.AMT,Y.INIT> = ''
    R.USER.LIMIT<REDO.USR.LIM.DLY.TOT.TXN.USD,Y.INIT> = ''    ;*PACS00037714 - S/E
RETURN

*--------------------------------------------------------------------------------------------------------
LOG.AMT.DTLS:
*-------------------

    Y.DAILY.DOP.AMT = R.USER.LIMIT<REDO.USR.LIM.DLY.TOT.TXN.AMT,Y.INIT>
    Y.DAILY.USD.AMT = R.USER.LIMIT<REDO.USR.LIM.DLY.TOT.TXN.USD,Y.INIT>

    IF Y.DAILY.DOP.AMT LE 0 THEN
        Y.DAILY.DOP.AMT = 0
    END
    IF Y.DAILY.USD.AMT LE 0 THEN
        Y.DAILY.USD.AMT = 0
    END

    R.LOG.REC<-1> = Y.APPLICATION<Y.INIT>:"*":Y.DAILY.DOP.AMT:"*":Y.DAILY.USD.AMT

RETURN

*--------------------------------------------------------------------------------------------------------
NULL.SIN.TXN.DATE:
*-------------------

    IF Y.SIN.TXN.DATE LE Y.LST.WORKING.DAY THEN
        R.USER.LIMIT<REDO.USR.LIM.SIN.TXN.LIM.DATE,Y.INIT> = ''
    END
RETURN

*--------------------------------------------------------------------------------------------------------
NULL.TOT.TXN.DATE:
*-----------------
    IF Y.TOT.TXN.DATE LE Y.LST.WORKING.DAY THEN
        R.USER.LIMIT<REDO.USR.LIM.TOT.TXN.LIM.DATE,Y.INIT> = ''
    END
RETURN

*--------------------------------------------------------------------------------------------------------
NULL.TRA.LIM.DATE:
*-------------------

    IF Y.TRADER.LIM.DATE LE Y.LST.WORKING.DAY THEN
        R.USER.LIMIT<REDO.USR.LIM.TRA.LIM.VALID.DATE,Y.INIT> = ''
    END
RETURN

*--------------------------------------------------------------------------------------------------------
NULL.BPS.DATE:
*---------------

    Y.BPS.VALID.DATE = R.USER.LIMIT<REDO.USR.LIM.BPS.LIM.VALID.DATE>
    IF Y.BPS.VALID.DATE LE Y.LST.WORKING.DAY THEN
        R.USER.LIMIT<REDO.USR.LIM.BPS.LIM.VALID.DATE> = ''
    END
RETURN

*--------------------------------------------------------------------------------------------------------
NULL.MM.LIM.DATE:
*------------------

    Y.MM.LIMIT.DATE = R.USER.LIMIT<REDO.USR.LIM.MM.LIMIT.DATE>
    IF Y.MM.LIMIT.DATE LE Y.LST.WORKING.DAY THEN
        R.USER.LIMIT<REDO.USR.LIM.MM.LIMIT.DATE> = ''
    END
RETURN

*--------------------------------------------------------------------------------------------------------
NULL.SC.LIM.DATE:
*------------------

    Y.SC.LIMIT.DATE = R.USER.LIMIT<REDO.USR.LIM.SC.LIMIT.DATE>
    IF Y.SC.LIMIT.DATE LE Y.LST.WORKING.DAY THEN
        R.USER.LIMIT<REDO.USR.LIM.SC.LIMIT.DATE> = ''
    END
RETURN
*--------------------------------------------------------------------------------------------------------
END
