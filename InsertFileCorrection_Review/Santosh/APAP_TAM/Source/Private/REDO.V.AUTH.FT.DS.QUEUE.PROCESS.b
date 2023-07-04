* @ValidationCode : MjotMTg4MDI2NjUxOkNwMTI1MjoxNjg4NDUzNDAxNjg5OklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jul 2023 12:20:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-105</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.AUTH.FT.DS.QUEUE.PROCESS
*-------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Sakthi Sellappillai
* PROGRAM NAME : REDO.V.AUTH.FT.DS.QUEUE.PROCESS
* ODR NUMBER   :
*-------------------------------------------------------------------------------------------------------
* DESCRIPTION : This Auth routine is used for to update REDO.APAP.H.DEAL.SLIP.QUEUE with the TXN  Deal Slips
*-------------------------------------------------------------------------------------------------------
*IN : N/A
*OUT : N/A
*-------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date                 Developer               Reference                  Description
*--------             ------------             ----------                 ------------
*08-12-2010           Sakthi Sellappillai                                 Initial creation
*26-06-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*26-06-2023    VICTORIA S          R22 MANUAL CONVERSION   VM TO @VM,INSERT FILE MODIFIED
*03-07-2023    Narmadha            R22 MANUAL CONVERSION   EMPACT- Field validation on TFS and write on table REDO.APAP.H.DEAL.SLIP.QUEUE will empact
*-------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DEAL.SLIP.FORMAT
    $INSERT I_DEAL.SLIP.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
*$INSERT I_F.T24.FUND.SERVICES ;*R22 MANUAL CONVERSION
    $INSERT I_GTS.COMMON
    $INSERT I_RC.COMMON
    $INSERT I_F.LOCKING
    $INSERT I_F.REDO.APAP.H.DEAL.SLIP.QUEUE
    $INSERT I_F.REDO.APAP.H.REPRINT.SEQ

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------------------------------
INITIALISE:
*-------------------------------------------------------------------------------------------------------

    FN.REDO.APAP.H.DEAL.SLIP.QUEUE = 'F.REDO.APAP.H.DEAL.SLIP.QUEUE'
    F.REDO.APAP.H.DEAL.SLIP.QUEUE = ''
    R.REDO.APAP.H.DEAL.SLIP.QUEUE = ''
    Y.REDO.DS.QUEUE.ERR = ''
    CALL OPF(FN.REDO.APAP.H.DEAL.SLIP.QUEUE,F.REDO.APAP.H.DEAL.SLIP.QUEUE)

* PACS00245671 - S
    FN.REDO.APAP.H.REPRINT.SEQ = 'F.REDO.APAP.H.REPRINT.SEQ'
    F.REDO.APAP.H.REPRINT.SEQ = ''
    R.REDO.APAP.H.REPRINT.SEQ = ''
    Y.REDO.DS.QUEUE.ERR = ''
    CALL OPF(FN.REDO.APAP.H.REPRINT.SEQ,F.REDO.APAP.H.REPRINT.SEQ)
    Y.TXN.DSLIP = ''
* PACS00245671 - E

    FN.LOCKING = 'F.LOCKING'
    F.LOCKING = ''
    CALL OPF(FN.LOCKING,F.LOCKING)

*    OFS$DEAL.SLIP.PRINTING = 1


RETURN
*******
PROCESS:
********
    Y.CONTRACT.NO = ID.NEW
    Y.CONT.NO = Y.CONTRACT.NO[1,2]
    Y.DEAL.SLIP.FUNC.VAL = ''
    Y.REC.STAT.VAL = ''
    Y.DS.QUEUE.PRINT.VAL = ''
    Y.REC.DATE.TIME.VAL = ''
    Y.REC.INPUTTER.VAL = ''
    Y.REC.INPUT.VAL = ''
    Y.LAST.DEAL.SLIP.ID = ''
    Y.DS.QUEUE.REPRINT.VAL = ''
    Y.DS.QUEUE.SEQ.NO = ''
    DEAL.SLIP.ID = ''
    Y.DEAL.SLIP.FUNC.VAL = R.VERSION(61)

    IF (Y.DEAL.SLIP.FUNC.VAL<1,1> EQ 'I' OR Y.DEAL.SLIP.FUNC.VAL<1,1> EQ 'A') OR (PGM.VERSION EQ ',LCY.COLLECT' AND APPLICATION EQ 'T24.FUND.SERVICES') THEN      ;* PACS00253760 - S/E

        IF Y.CONT.NO EQ 'FT' THEN
            GOSUB LOCKING
            GOSUB PROCESS.FT.RECORD.STATUS
        END
        IF Y.CONT.NO EQ 'TT' THEN
            GOSUB LOCKING
            GOSUB PROCESS.TT.RECORD.STATUS
        END

        IF PGM.VERSION EQ ',LCY.COLLECT' AND APPLICATION EQ 'T24.FUND.SERVICES' THEN
            Y.DEAL.LIST = 'REDO.DEP.TFS'
        END ELSE
            Y.DEAL.LIST = R.VERSION(60)
        END

        IF Y.CONTRACT.NO[1,5] EQ 'T24FS' THEN
            GOSUB LOCKING
            GOSUB PROCESS.T24FS.RECORD.STATUS
        END

        IF Y.REC.STAT.VAL EQ 'INAU' THEN
            GOSUB WRITE.INAU
        END
        IF Y.REC.STAT.VAL EQ 'INAO' THEN
            GOSUB WRITE.INAO
        END

* PACS00245671 - S

        TXN.LIST.COUNT = DCOUNT(Y.DEAL.LIST,@VM) ;*R22 MANUAL CONVERSION
        VAR.TEMP.CNT   = 1
        LOOP
        WHILE VAR.TEMP.CNT LE TXN.LIST.COUNT
            GOSUB WRITE.PRINT.SEQ
            VAR.TEMP.CNT++
        REPEAT
* PACS00245671 - E

    END

RETURN

************************
PROCESS.FT.RECORD.STATUS:
*************************

    Y.REC.STAT.VAL = R.NEW(FT.RECORD.STATUS)
    Y.REC.DATE.TIME.VAL = R.NEW(FT.DATE.TIME)
    Y.REC.INPUTTER.VAL = R.NEW(FT.INPUTTER)
    Y.REC.INPUT.VAL = Y.REC.INPUTTER.VAL['_',2,1]
    DEAL.SLIP.ID = R.VERSION(60)
    Y.LAST.DEAL.SLIP.ID = DEAL.SLIP.ID<1,1>

    IF Y.REC.STAT.VAL EQ 'INAU' THEN
        ID.NEW = Y.CONTRACT.NO
        Y.LAST.DEAL.SLIP.ID = DEAL.SLIP.ID
        IF Y.LAST.DEAL.SLIP.ID THEN
            Y.DS.QUEUE.PRINT.VAL = 'YES'
            Y.DS.QUEUE.REPRINT.VAL = 'NO'
        END
    END

    IF Y.REC.STAT.VAL EQ 'INAO' THEN
        IF Y.LAST.DEAL.SLIP.ID THEN
            Y.DS.QUEUE.PRINT.VAL = 'NO'
            Y.DS.QUEUE.REPRINT.VAL = 'NO'
        END
    END

RETURN
*****************************
PROCESS.TT.RECORD.STATUS:
*****************************

    Y.REC.STAT.VAL = R.NEW(TT.TE.RECORD.STATUS)
    Y.REC.DATE.TIME.VAL = R.NEW(TT.TE.DATE.TIME)
    Y.REC.INPUTTER.VAL = R.NEW(TT.TE.INPUTTER)
    Y.REC.INPUT.VAL = Y.REC.INPUTTER.VAL['_',2,1]
    DEAL.SLIP.ID = R.VERSION(60)
    Y.LAST.DEAL.SLIP.ID = DEAL.SLIP.ID<1,1>

    IF Y.REC.STAT.VAL EQ 'INAU' THEN
        ID.NEW = Y.CONTRACT.NO
        Y.LAST.DEAL.SLIP.ID = DEAL.SLIP.ID
        IF Y.LAST.DEAL.SLIP.ID THEN
            Y.DS.QUEUE.PRINT.VAL = 'YES'
            Y.DS.QUEUE.REPRINT.VAL = 'NO'
        END
    END
    IF Y.REC.STAT.VAL EQ 'INAO' THEN
        IF Y.LAST.DEAL.SLIP.ID THEN
            Y.DS.QUEUE.PRINT.VAL = 'NO'
            Y.DS.QUEUE.REPRINT.VAL = 'NO'
        END
    END

RETURN
***************************
PROCESS.T24FS.RECORD.STATUS:
****************************

    Y.REC.STAT.VAL = R.NEW(TFS.RECORD.STATUS)
    Y.REC.DATE.TIME.VAL = R.NEW(TFS.DATE.TIME)
    Y.REC.INPUTTER.VAL = R.NEW(TFS.INPUTTER)
    Y.REC.INPUT.VAL = Y.REC.INPUTTER.VAL['_',2,1]
    DEAL.SLIP.ID = Y.DEAL.LIST
    Y.LAST.DEAL.SLIP.ID = DEAL.SLIP.ID<1,1>

    IF Y.REC.STAT.VAL EQ 'INAU' THEN
        ID.NEW = Y.CONTRACT.NO
        Y.LAST.DEAL.SLIP.ID = DEAL.SLIP.ID
        IF Y.LAST.DEAL.SLIP.ID THEN
            Y.DS.QUEUE.PRINT.VAL = 'YES'
            Y.DS.QUEUE.REPRINT.VAL = 'NO'
        END
    END
    IF Y.REC.STAT.VAL EQ 'INAO' THEN
        IF Y.LAST.DEAL.SLIP.ID THEN
            Y.DS.QUEUE.PRINT.VAL = 'NO'
            Y.DS.QUEUE.REPRINT.VAL = 'NO'
        END
    END

RETURN
***********
WRITE.INAU:
***********
*
*OFS$DEAL.SLIP.PRINTING = 1 ;* Because of this varible, we are getting an error during authorisation
*                             "Report View - cannot read from &HOLD&", So this has been commented
    PRT.ADVICED.PRODUCED = ""
*
    CALL F.READ(FN.REDO.APAP.H.DEAL.SLIP.QUEUE,Y.CONTRACT.NO,R.REDO,F.REDO.APAP.H.DEAL.SLIP.QUEUE,ERR)

    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.DEAL.SLIP.ID,1> = Y.LAST.DEAL.SLIP.ID
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.TELLER.USER,1,1> = Y.REC.INPUT.VAL
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.TXN.DAY.TIME,1,1> = Y.REC.DATE.TIME.VAL
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.INIT.PRINT,1,1> = Y.DS.QUEUE.PRINT.VAL
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.REPRINT,1,1> = Y.DS.QUEUE.REPRINT.VAL
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.REPRINT.SEQ,1,1> = R.LOCKING<EB.LOK.CONTENT>

    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.TELLER.USER,1,2> = ''
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.TXN.DAY.TIME,1,2> = ''
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.INIT.PRINT,1,2> = 'NO'
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.REPRINT,1,2> = 'NO'

    CALL F.WRITE(FN.REDO.APAP.H.DEAL.SLIP.QUEUE,Y.CONTRACT.NO,R.REDO.APAP.H.DEAL.SLIP.QUEUE)

RETURN

************
WRITE.INAO:
************
*
*    OFS$DEAL.SLIP.PRINTING = 1          ;* Because of this varible, we are getting an error during authorisation
*                               "Report View - cannot read from &HOLD&", So this has been commented
    PRT.ADVICED.PRODUCED = ""
*
    CALL F.READ(FN.REDO.APAP.H.DEAL.SLIP.QUEUE,Y.CONTRACT.NO,R.REDO,F.REDO.APAP.H.DEAL.SLIP.QUEUE,ERR)
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.DEAL.SLIP.ID,1> = Y.LAST.DEAL.SLIP.ID
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.TELLER.USER,1,1> = ''
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.TXN.DAY.TIME,1,1> = ''
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.INIT.PRINT,1,1> = Y.DS.QUEUE.PRINT.VAL
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.REPRINT,1,1> = Y.DS.QUEUE.REPRINT.VAL
    R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.REPRINT.SEQ,1,1> = R.LOCKING<EB.LOK.CONTENT>

    CALL F.WRITE(FN.REDO.APAP.H.DEAL.SLIP.QUEUE,Y.CONTRACT.NO,R.REDO.APAP.H.DEAL.SLIP.QUEUE)

RETURN
*
*** <region name= WRITE.PRINT.SEQ>
WRITE.PRINT.SEQ:
*** <desc>Writes first record of Deal slip reprinting.</desc>

    Y.TXN.DSLIP = '' ; Y.TXN.DSLIP = Y.CONTRACT.NO: '-' :Y.DEAL.LIST<1,VAR.TEMP.CNT> ; Y.RAHRS.ERR = ""
    CALL F.READ(FN.REDO.APAP.H.REPRINT.SEQ,Y.TXN.DSLIP,R.REDO.APAP.H.REPRINT.SEQ,F.REDO.APAP.H.REPRINT.SEQ,Y.RAHRS.ERR)

    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.REPRINT.SEQ>   = '0'
    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.REPRINT.FLAG>  = 'NO'
    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.INIT.PRINT>    = 'NO'

    CALL F.WRITE(FN.REDO.APAP.H.REPRINT.SEQ,Y.TXN.DSLIP,R.REDO.APAP.H.REPRINT.SEQ)

RETURN
*** </region>
*
********
LOCKING:
********
    LOCKING.ID = Y.CONTRACT.NO
    R.LOCKING  = ''
    LOCKING.ER = ''
    CALL F.READ(FN.LOCKING,LOCKING.ID,R.LOCKING,F.LOCKING,LOCKING.ER)
    IF R.LOCKING THEN
        R.LOCKING<EB.LOK.CONTENT> = '0000'
        CALL F.WRITE(FN.LOCKING,LOCKING.ID,R.LOCKING)
    END ELSE
        R.LOCKING<EB.LOK.CONTENT> = '0000'
        CALL F.WRITE(FN.LOCKING,LOCKING.ID,R.LOCKING)
    END

RETURN
************************************************
END
*------------End of Program-----------------------------------------
