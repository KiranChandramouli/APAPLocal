* @ValidationCode : Mjo1MTkzMDI1NDQ6Q3AxMjUyOjE2ODEyNzYwNDU0MTc6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:37:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LY.GEN.ACCMOV(Y.MOV.ID)
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
*  This routine is attached to the batch record BNK/REDO.B.LY.GEN.ACCMOV
*  Generate all the accountable movements for each one of the loyalty programs in
*  5 stages: points generated, available points, points used, due points and
*  maintenance points
*
* ------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     :
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 21-JUN-2011       A.Velasco     ODR-XXXX-XX-XXXX      Initial Creation
* 23-APR-2013       RMONDRAGON    ODR-2011-06-0243      Second Version
* 23-SEP-2013       RMONDRAGON    ODR-2011-06-0243      Third Version (update to use EB.ACCOUNTING)
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - VM TO @VM
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.LY.GEN.ACCMOV.COMMON
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_F.REDO.LY.POINTS.TOT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.ACCOUNT

    GOSUB INITIALISE

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*Get data from REDO.LY.POINTS.TOT for the record to process

    CALL F.READ(FN.REDO.LY.POINTS.TOT,Y.MOV.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,Y.ERR)

    IF R.REDO.LY.POINTS.TOT THEN
*Start the process
        Y.AMTFGEN = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.GEN.VALUE>
        Y.AMTFAVA = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.VALUE>
        Y.AMTFDUE = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.DUE.VALUE>
        GOSUB GET.DATA.PROGRAM

    END
*
RETURN
* ===============
GET.DATA.PROGRAM:
* ===============
*Get Id for REDO.LY.PROGRAM

    GOSUB GET.PROGRAM.ID

*Get data from REDO.LY.PROGRAM
    CALL F.READ(FN.REDO.LY.PROGRAM,Y.ID.PROGRAM,R.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM,Y.ERR)

    Y.TXNGEN    = R.REDO.LY.PROGRAM<REDO.PROG.TXN.TYPE.GEN>
    Y.DRACCTGEN = R.REDO.LY.PROGRAM<REDO.PROG.DR.ACCT.GEN>
    Y.CRACCTGEN = R.REDO.LY.PROGRAM<REDO.PROG.CR.ACCT.GEN>
    Y.TXNAVA    = R.REDO.LY.PROGRAM<REDO.PROG.TXN.TYPE.AVA>
    Y.DRACCTAVA = R.REDO.LY.PROGRAM<REDO.PROG.DR.ACCT.AVA>
    Y.CRACCTAVA = R.REDO.LY.PROGRAM<REDO.PROG.CR.ACCT.AVA>
    Y.TXNDUE    = R.REDO.LY.PROGRAM<REDO.PROG.TXN.TYPE.DUE>
    Y.DRACCTDUE = R.REDO.LY.PROGRAM<REDO.PROG.DR.ACCT.DUE>
    Y.CRACCTDUE = R.REDO.LY.PROGRAM<REDO.PROG.CR.ACCT.DUE>

    GOSUB GEN.PROCESS
    GOSUB AVA.PROCESS
    GOSUB DUE.PROCESS

    IF MULTI.STMT THEN
        CALL EB.ACCOUNTING("AC","SAO",MULTI.STMT,'')
    END

RETURN

* ============
GET.TXN.CODES:
* ============

    R.FT.TXN.TYPE.CONDITION = ''; TXNTC.ERR = ''
    CALL F.READ(FN.FT.TXN.TYPE.CONDITION,Y.TXNTC,R.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION,TXNTC.ERR)
    IF R.FT.TXN.TYPE.CONDITION THEN
        Y.TXN.DR = R.FT.TXN.TYPE.CONDITION<FT6.TXN.CODE.DR>
        Y.TXN.CR = R.FT.TXN.TYPE.CONDITION<FT6.TXN.CODE.CR>
    END

RETURN

* ==========
GEN.PROCESS:
* ==========
    Y.PROC = 'Y'

    IF Y.AMTFGEN EQ '' OR Y.AMTFGEN EQ 0 THEN
        Y.PROC = 'N'
    END

    IF Y.TXNGEN EQ '' THEN
        Y.PROC = 'N'
    END ELSE
        Y.TXNTC = Y.TXNGEN
        GOSUB GET.TXN.CODES
    END

    IF Y.PROC EQ 'Y' THEN
        Y.AMT = Y.AMTFGEN
        Y.DR.ACCT = Y.DRACCTGEN
        Y.CR.ACCT = Y.CRACCTGEN
        Y.PREF.EV = 'LYGEN'
        GOSUB GEN.ENTRY
    END

RETURN

* ==========
AVA.PROCESS:
* ==========
    Y.PROC = 'Y'

    IF Y.AMTFAVA EQ '' OR Y.AMTFAVA EQ 0 THEN
        Y.PROC = 'N'
    END

    IF Y.TXNAVA EQ '' THEN
        Y.PROC = 'N'
    END ELSE
        Y.TXNTC = Y.TXNAVA
        GOSUB GET.TXN.CODES
    END

    IF Y.PROC EQ 'Y' THEN
        Y.AMT = Y.AMTFAVA
        Y.DR.ACCT = Y.DRACCTAVA
        Y.CR.ACCT = Y.CRACCTAVA
        Y.PREF.EV = 'LYAVA'
        GOSUB GEN.ENTRY
    END

RETURN

* ==========
DUE.PROCESS:
* ==========
    Y.PROC = 'Y'

    IF Y.AMTFDUE EQ '' OR Y.AMTFDUE EQ 0 THEN
        Y.PROC = 'N'
    END

    IF Y.TXNDUE EQ '' THEN
        Y.PROC = 'N'
    END ELSE
        Y.TXNTC = Y.TXNDUE
        GOSUB GET.TXN.CODES
    END

    IF Y.PROC EQ 'Y' THEN
        Y.AMT = Y.AMTFDUE
        Y.DR.ACCT = Y.DRACCTDUE
        Y.CR.ACCT = Y.CRACCTDUE
        Y.PREF.EV = 'LYDUE'
        GOSUB GEN.ENTRY
    END

RETURN

* ========
GEN.ENTRY:
* ========
*Process Movement of points generated
    Y.VAL4 = Y.AMT

*Get the total number of values in Y.DRACCTGEN
    Y.TOTAL = DCOUNT(Y.DR.ACCT,@VM)

    FOR Y.POS = 1 TO Y.TOTAL
        IF Y.VAL4 GT 0 THEN
            Y.VAL2 = Y.DR.ACCT<1,Y.POS>
            Y.VAL3 = Y.CR.ACCT<1,Y.POS>
        END ELSE
            Y.VAL2 = Y.CR.ACCT<1,Y.POS>
            Y.VAL3 = Y.DR.ACCT<1,Y.POS>
            Y.VAL4 = NEGS(Y.VAL4)
        END
        Y.ORDERING.BANK.VAL = Y.PREF.EV:Y.ID.PROGRAM

        IF Y.VAL2 NE 'CUST.ACCT' THEN
            IF Y.VAL3 NE 'CUST.ACCT' THEN
                Y.ACCT.DET = Y.VAL2
                GOSUB ACCT.INFORMATION
                GOSUB ACCT.ENTRIES1

                Y.ACCT.DET = Y.VAL3
                GOSUB ACCT.INFORMATION
                GOSUB ACCT.ENTRIES2
            END
        END
    NEXT Y.POS

RETURN

* ===============
ACCT.INFORMATION:
* ===============

    R.ACCOUNT = ''; ACCT.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCT.DET,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    IF R.ACCOUNT THEN
        ACCT.OFF.VAL  = R.ACCOUNT<AC.ACCOUNT.OFFICER>
        PROD.CATEGORY = R.ACCOUNT<AC.CATEGORY>
        Y.CURRENCY    = R.ACCOUNT<AC.CURRENCY>
    END

RETURN

* ============
ACCT.ENTRIES1:
* ============

    R.STMT.ARR = ''
    R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = Y.VAL2
    R.STMT.ARR<AC.STE.CURRENCY> = Y.CURRENCY
    R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1 * Y.VAL4
    R.STMT.ARR<AC.STE.CRF.TYPE> = "DEBIT"
    R.STMT.ARR<AC.STE.TRANSACTION.CODE> = Y.TXN.DR
    GOSUB BASIC.ACC.ENTRY
    MULTI.STMT<-1> = LOWER(R.STMT.ARR)

RETURN

* ============
ACCT.ENTRIES2:
* ============

    R.STMT.ARR = ''
    R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = Y.VAL3
    R.STMT.ARR<AC.STE.CURRENCY> = Y.CURRENCY
    R.STMT.ARR<AC.STE.AMOUNT.LCY> = Y.VAL4
    R.STMT.ARR<AC.STE.CRF.TYPE> = "CREDIT"
    R.STMT.ARR<AC.STE.TRANSACTION.CODE> = Y.TXN.CR
    GOSUB BASIC.ACC.ENTRY
    MULTI.STMT<-1> = LOWER(R.STMT.ARR)

RETURN

* ==============
BASIC.ACC.ENTRY:
* ==============
*Common Call for raising Entries

    R.STMT.ARR<AC.STE.COMPANY.CODE> = ID.COMPANY
    R.STMT.ARR<AC.STE.ACCOUNT.OFFICER> = ACCT.OFF.VAL
    R.STMT.ARR<AC.STE.PRODUCT.CATEGORY> = PROD.CATEGORY
    R.STMT.ARR<AC.STE.NARRATIVE> = Y.ORDERING.BANK.VAL
    R.STMT.ARR<AC.STE.VALUE.DATE> = Y.TO.DAY
    R.STMT.ARR<AC.STE.POSITION.TYPE> = "TR"
    R.STMT.ARR<AC.STE.OUR.REFERENCE> = ID.NEW
    R.STMT.ARR<AC.STE.TRANS.REFERENCE> = ID.NEW
    R.STMT.ARR<AC.STE.SYSTEM.ID> = "AC"
    R.STMT.ARR<AC.STE.BOOKING.DATE> = Y.TO.DAY
    R.STMT.ARR<AC.STE.EXPOSURE.DATE> = Y.TO.DAY
    R.STMT.ARR<AC.STE.CURRENCY.MARKET> = 1
    R.STMT.ARR<AC.STE.DEPARTMENT.CODE> = 1
    R.STMT.ARR<AC.STE.PROCESSING.DATE> = Y.TO.DAY
    R.STMT.ARR<AC.STE.ORIG.CCY.MARKET> = 1

RETURN

* =============
GET.PROGRAM.ID:
* =============
*Extract the Program Id from the processing @id

    Y.NUM.CAR = LEN(Y.MOV.ID)
    Y.END.POS = Y.NUM.CAR - 3
    Y.SUB.CHAR = SUBSTRINGS(Y.MOV.ID,4,Y.END.POS)
    Y.POS.DATE = LEN(Y.SUB.CHAR) - 8
    Y.ID.PROGRAM = SUBSTRINGS(Y.SUB.CHAR,1,Y.POS.DATE)

RETURN

* =========
INITIALISE:
* =========
*initialise Variables

    PROCESS.GOAHEAD = 1
    Y.TO.DAY        = TODAY
    MULTI.STMT      = ''

RETURN

END
