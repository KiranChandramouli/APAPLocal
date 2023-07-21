$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.CHQ.REP.WRITE
*-----------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Marimuthu S
*Program   Name    :REDO.INP.CHQ.REP.WRITE
*----------------------------------------------------------------------------------
*DESCRIPTION       : This input routine will be attached to the version to get the
*                    details of cheque and repaymnet amount. These details will be written
*                    to the local table REDO.FT.TT.TXN.ID
*
*---------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who             Reference            Description
* 10-SEP-2010       MARIMUTHU S       PACS00078861         Initial Creation
*14-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,SM TO @SM,TNO TO C$T24.SESSION.NO
*14-07-2023    VICTORIA S          R22 MANUAL CONVERSION   VARIABLE NAME MODIFIED
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.LOAN.FT.TT.TXN

MAIN:

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PGM.END

OPENFILES:

    FN.REDO.LOAN.FT.TT.TXN = 'F.REDO.LOAN.FT.TT.TXN'
    F.REDO.LOAN.FT.TT.TXN = ''
    CALL OPF(FN.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN)

    Y.FIELDS = 'CERT.CHEQUE.NO'
    CALL MULTI.GET.LOC.REF(APPLICATION,Y.FIELDS,LOC.REF)
    Y.CHQ.POS = LOC.REF<1,1>

RETURN

PROCESS:

    Y.FUN = V$FUNCTION

    IF V$FUNCTION EQ 'R' THEN
        RETURN
    END

    Y.CHEQ.NO = R.NEW(FT.LOCAL.REF)<1,Y.CHQ.POS>
    IF NOT(Y.CHEQ.NO) THEN
        RETURN
    END
    Y.CHEQ.NO = CHANGE(Y.CHEQ.NO,@SM,@VM) ;*R22 AUTO CONVERSION
    Y.CNT = DCOUNT(Y.CHEQ.NO,@VM) ;*R22 AUTO CONVERSION
    FLG = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
*R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CHEQUE.NO,FLG> = Y.CHEQ.NO<1,FLG>
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CHEQUE.REF,FLG> = Y.CHEQ.NO<1,FLG> ;*R22 MANUAL CONVERSION
        Y.CNT -= 1
    REPEAT

    IF R.NEW(FT.DEBIT.AMOUNT) EQ '' THEN
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.TOTAL.AMOUNT> = R.NEW(FT.CREDIT.AMOUNT)
    END ELSE
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.TOTAL.AMOUNT> = R.NEW(FT.DEBIT.AMOUNT)
    END
*R22 MANUAL CONVERSION START
*R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.NEW.TXN.ID> = ID.NEW
    R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.FT.TRANSACTION.ID> = ID.NEW
*R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.VERSION.NAME> = APPLICATION:PGM.VERSION ;* *R22 MANUAL CONVERSION : VERSION.NAME Field not available in table
*R22 MANUAL CONVERSION END

    CON.DATE = OCONV(DATE(),"D-")
    DATE.TIME = CON.DATE[9,2]:CON.DATE[1,2]:CON.DATE[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
    R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.DATE.TIME>= DATE.TIME
    R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSION
    R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSION
    R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CURR.NO> = 1
    R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CO.CODE>=ID.COMPANY
    CALL F.WRITE(FN.REDO.LOAN.FT.TT.TXN,ID.NEW,R.REDO.LOAN.FT.TT.TXN)

RETURN

PGM.END:

END
