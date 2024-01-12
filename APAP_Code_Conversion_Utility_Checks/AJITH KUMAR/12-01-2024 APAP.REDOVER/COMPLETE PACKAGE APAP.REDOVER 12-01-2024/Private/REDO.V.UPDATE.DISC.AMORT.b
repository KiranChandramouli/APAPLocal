* @ValidationCode : MjotMTEwMDI2NTc5MzpDcDEyNTI6MTY4MjQxMjM1NTQ0MjpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.UPDATE.DISC.AMORT
*-------------------------------------------------------------------------
* DESCRIPTION : This routine is attached to version SEC.TRADE,REDO.BUY.OWN.BOOK as
*                an authorisation routine and will update the local table REDO.APAP.L.SC.DISC.AMORT
*-------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Arundev KR
* PROGRAM NAME : REDO.V.UPDATE.DISC.AMORT
*-------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author                      Reference                  Description
* 18-Feb-2013      Arundev KR               CR008 RTC-553577            Initial creation
*13-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.REDO.APAP.L.SC.DISC.AMORT
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.SC.TRADING.POSITION

    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*-------------------------------------------------------------------------
INITIALISE:
*-------------------------------------------------------------------------

RETURN

*-------------------------------------------------------------------------
OPENFILES:
*-------------------------------------------------------------------------

    FN.REDO.APAP.L.SC.DISC.AMORT = 'F.REDO.APAP.L.SC.DISC.AMORT'
    F.REDO.APAP.L.SC.DISC.AMORT = ''
    CALL OPF(FN.REDO.APAP.L.SC.DISC.AMORT,F.REDO.APAP.L.SC.DISC.AMORT)

    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER = ''
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)

    FN.SC.TRADING.POSITION = 'F.SC.TRADING.POSITION'
    F.SC.TRADING.POSITION = ''
    CALL OPF(FN.SC.TRADING.POSITION,F.SC.TRADING.POSITION)

RETURN

*-------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------

    GOSUB READ.SECURITY.MASTER
    GOSUB READ.SC.TRADING.POSITION

    IF BOND.SHARE EQ 'B' THEN
        GOSUB SC.BOND.DISC.AMORT
    END

RETURN

*-------------------------------------------------------------------------
SC.BOND.DISC.AMORT:
*-------------------------------------------------------------------------

    DISC.AMORT.ID = SC.TRADING.POSITION.ID
    R.DISC.AMORT = ''
    DISC.AMORT.ERR = ''
*    CALL F.READ(FN.REDO.APAP.L.SC.DISC.AMORT,DISC.AMORT.ID,R.DISC.AMORT,F.REDO.APAP.L.SC.DISC.AMORT,DISC.AMORT.ERR)
    CALL F.READU(FN.REDO.APAP.L.SC.DISC.AMORT,DISC.AMORT.ID,R.DISC.AMORT,F.REDO.APAP.L.SC.DISC.AMORT,DISC.AMORT.ERR,'');* R22 UTILITY AUTO CONVERSION

    IF R.DISC.AMORT THEN
        GOSUB UPDATE.REDO.APAP.L.SC.DISC.AMORT
    END ELSE
        GOSUB CREATE.REDO.APAP.L.SC.DISC.AMORT
    END

    CALL F.WRITE(FN.REDO.APAP.L.SC.DISC.AMORT,DISC.AMORT.ID,R.DISC.AMORT)

RETURN

*-------------------------------------------------------------------------
READ.SECURITY.MASTER:
*-------------------------------------------------------------------------

    SECURITY.MASTER.ID = R.NEW(SC.SBS.SECURITY.CODE)
    R.SECURITY.MASTER = ''
    SECURITY.MASTER.ERR = ''
    CALL F.READ(FN.SECURITY.MASTER,SECURITY.MASTER.ID,R.SECURITY.MASTER,F.SECURITY.MASTER,SECURITY.MASTER.ERR)
    PAR.VALUE  = R.SECURITY.MASTER<SC.SCM.PAR.VALUE>
    BOND.SHARE = R.SECURITY.MASTER<SC.SCM.BOND.OR.SHARE>
    VALUE.DATE = R.SECURITY.MASTER<SC.SCM.ISSUE.DATE>
    MAT.DATE = R.SECURITY.MASTER<SC.SCM.MATURITY.DATE>

RETURN

*-------------------------------------------------------------------------
READ.SC.TRADING.POSITION:
*-------------------------------------------------------------------------

    SC.TRADING.POSITION.ID = R.NEW(SC.SBS.CUST.SEC.ACC):'.':SECURITY.MASTER.ID
    R.SC.TRADING.POSITION = ''
    SC.TRADING.POSITION.ERR = ''
    CALL F.READ(FN.SC.TRADING.POSITION,SC.TRADING.POSITION.ID,R.SC.TRADING.POSITION,F.SC.TRADING.POSITION,SC.TRADING.POSITION.ERR)
    AVG.PRICE = R.SC.TRADING.POSITION<SC.TRP.CUR.AVG.PRICE>

RETURN

*-------------------------------------------------------------------------
UPDATE.REDO.APAP.L.SC.DISC.AMORT:
*-------------------------------------------------------------------------

    GOSUB CALC.DISC.NOMINAL
    IF TRANS.CODE EQ 'BUY' THEN
        R.DISC.AMORT<DISC.AMRT.NOMINAL> = DISC.NOMINAL
    END ELSE
        IF TRANS.CODE EQ 'SEL' THEN
            R.DISC.AMORT<DISC.AMRT.NOMINAL> -= DISC.NOMINAL
        END
    END

    GOSUB CALC.DISC.DAYS.TO.MAT
    R.DISC.AMORT<DISC.AMRT.DAYS.TO.MAT> = DISC.DAYS.TO.MAT

    GOSUB CALC.DISC.LIN.ACCR.AMT
    R.DISC.AMORT<DISC.AMRT.LIN.ACCR.AMT> = DISC.LIN.ACCR.AMT

RETURN

*-------------------------------------------------------------------------
CREATE.REDO.APAP.L.SC.DISC.AMORT:
*-------------------------------------------------------------------------

    R.DISC.AMORT<DISC.AMRT.DISC.ACC.DATE>   = ''
    R.DISC.AMORT<DISC.AMRT.EFF.DISC.RATE>   = ''
    R.DISC.AMORT<DISC.AMRT.EFF.DISC.AMT>    = ''
    R.DISC.AMORT<DISC.AMRT.EFF.DISC.TODATE> = ''

    GOSUB CALC.DISC.NOMINAL
    IF TRANS.CODE EQ 'BUY' THEN
        R.DISC.AMORT<DISC.AMRT.NOMINAL> = DISC.NOMINAL
    END ELSE
        IF TRANS.CODE EQ 'SEL' THEN
            R.DISC.AMORT<DISC.AMRT.NOMINAL> = (-1) * DISC.NOMINAL
        END
    END

    GOSUB CALC.DISC.DAYS.TO.MAT
    R.DISC.AMORT<DISC.AMRT.DAYS.TO.MAT> = DISC.DAYS.TO.MAT

    GOSUB CALC.DISC.LIN.ACCR.AMT
    R.DISC.AMORT<DISC.AMRT.LIN.ACCR.AMT> = DISC.LIN.ACCR.AMT

RETURN

*-------------------------------------------------------------------------
CALC.DISC.NOMINAL:
*-------------------------------------------------------------------------

    DISC.NOMINAL = R.NEW(SC.SBS.CUST.NO.NOM)
    TRANS.CODE = R.NEW(SC.SBS.CUST.TRANS.CODE)

RETURN

*-------------------------------------------------------------------------
CALC.DISC.DAYS.TO.MAT:
*-------------------------------------------------------------------------

    REGION.CODE = ''
    DISC.DAYS.TO.MAT = 'C'
    VALUE.DATE = R.NEW(SC.SBS.VALUE.DATE)
    MAT.DATE = R.NEW(SC.SBS.MATURITY.DATE)
    CALL CDD(REGION.CODE,VALUE.DATE,MAT.DATE,DISC.DAYS.TO.MAT)

RETURN

*-------------------------------------------------------------------------
CALC.DISC.LIN.ACCR.AMT:
*-------------------------------------------------------------------------

    DISC.LIN.ACCR.AMT = R.NEW(SC.SBS.DISCOUNT.AMOUNT)

RETURN

*-------------------------------------------------------------------------
END
