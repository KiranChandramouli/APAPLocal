* @ValidationCode : Mjo1ODI3NTUxMzY6Q3AxMjUyOjE2ODc4NDIxNzU3ODg6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Jun 2023 10:32:55
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.UPD.FUL.CHQ.REV(CK.ID)
*-----------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Marimuthu S
*Program   Name    :REDO.UPD.FUL.CHQ.REV
*----------------------------------------------------------------------------------
*DESCRIPTION       :This routine will be internally from REDO.INP.PR.REMAIN.AMT.REPAY, will
*                   update the local table REDO.FT.TT.TXN.ID
*
*---------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who             Reference            Description
* 10-SEP-2010       MARIMUTHU S       PACS00126000        Initial Creation
* 16-JAN-2012       MARIMUTHU S       PACS00170057
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM, SM TO @SM
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     T TO C$T24.SESSION.
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION  VARIABLE NAME MODIFIED
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LOAN.FT.TT.TXN
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.H.AA.DIS.CHG
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY

MAIN:
 
    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:

    FN.REDO.LOAN.FT.TT.TXN = 'F.REDO.LOAN.FT.TT.TXN'
    F.REDO.LOAN.FT.TT.TXN = ''
    CALL OPF(FN.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.H.AA.DIS.CHG = 'F.REDO.H.AA.DIS.CHG'
    F.REDO.H.AA.DIS.CHG = ''


    CALL F.READ(FN.REDO.LOAN.FT.TT.TXN,CK.ID,R.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN,FT.TT.ERR)
    Y.TOT.AMT = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.TOTAL.AMOUNT>
*   Y.CHQ = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CHEQUE.NO>
    Y.CHQ=""
    Y.CHQ = CHANGE(Y.CHQ,@SM,@VM) ;*R22 AUTO CONVERSION
    Y.CNT = DCOUNT(Y.CHQ,@VM) ;*R22 AUTO CONVERSION
    FLG = ''

    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
*Y.CHQ.STATUS = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CHEQUE.STATUS,FLG> *;R22 MANUAL CONVERSION
        Y.CHQ.STATUS=""
        IF Y.CHQ.STATUS EQ 'RETURN' THEN
*        Y.RES.AMT = Y.RES.AMT + R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.REQ.TXN.AMT,FLG> *;R22 MANUAL CONVERSION
            Y.RES.AMT=""
*          R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CHEQUE.STATUS,FLG> = 'PROCESSED' ;*Because of commented 'I_F.REDO.LOAN.FT.TT.TXN' insert file, Comment this variable 'LN.FT.TT.CHEQUE.STATUS,FLG'
        END ELSE
            IF Y.CHQ.STATUS NE 'PROCESSED' THEN
                Y.PROCESS = 'SET'
            END
        END
        Y.CNT -= 1
    REPEAT
    Y.FIN.AMT = Y.TOT.AMT - Y.RES.AMT

    GOSUB UPDATE.LOC.TABLE

RETURN

UPDATE.LOC.TABLE:

    IF Y.PROCESS NE 'SET' THEN
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.TOTAL.AMOUNT> = Y.FIN.AMT
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.STATUS> = 'PROCESSED'
*       R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.NEW.TXN.ID> = ID.NEW  ;*Because of commented 'I_F.REDO.LOAN.FT.TT.TXN' insert file, Comment this variable 'LN.FT.TT.NEW.TXN.ID'
        CON.DATE = OCONV(DATE(),"D-")
        DATE.TIME = CON.DATE[9,2]:CON.DATE[1,2]:CON.DATE[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.DATE.TIME>= DATE.TIME
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSION
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSION
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CURR.NO> = 1
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CO.CODE>=ID.COMPANY
        CALL F.WRITE(FN.REDO.LOAN.FT.TT.TXN,CK.ID,R.REDO.LOAN.FT.TT.TXN)
    END ELSE
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.TOTAL.AMOUNT> = Y.FIN.AMT
*        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.NEW.TXN.ID> = ID.NEW ;*Because of commented 'I_F.REDO.LOAN.FT.TT.TXN' insert file, Comment this variable 'LN.FT.TT.NEW.TXN.ID'
        CON.DATE = OCONV(DATE(),"D-")
        DATE.TIME = CON.DATE[9,2]:CON.DATE[1,2]:CON.DATE[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.DATE.TIME>= DATE.TIME
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSION
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSION
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CURR.NO> = 1
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CO.CODE>=ID.COMPANY
        CALL F.WRITE(FN.REDO.LOAN.FT.TT.TXN,CK.ID,R.REDO.LOAN.FT.TT.TXN)
    END

RETURN

PGM.END:
END
