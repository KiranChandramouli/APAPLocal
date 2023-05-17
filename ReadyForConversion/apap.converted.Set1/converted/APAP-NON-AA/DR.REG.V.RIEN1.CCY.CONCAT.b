*
*--------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
SUBROUTINE DR.REG.V.RIEN1.CCY.CONCAT
*--------------------------------------------------------------------------------------------
* Subroutine Type : VERSION
* Attached to     : CURRENCY VERSIONS
* Attached as     : AUTHORISATION.ROUTINE
* Primary Purpose : Capture the SELL.RATE and update into concat table.
* Incoming:
* ---------
*
* * Outgoing:
* ---------
*
* Error Variables:
* ----------------
*
* *---------------------------------------------------------------------------------------------
* Development:
* ------------
* 5/Jul/13 - Gangadhar.S.V.
*            gangadhar@temenos.com
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CURRENCY
    $INSERT I_F.DR.REG.RIEN1.CONCAT
*----------------------------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    IF ID.NEW NE LCCY THEN
        GOSUB PROCESS
    END

RETURN
*-----------------------------------------------------------------------------------------------
PROCESS:

    CCY.POS = ''
    CCY.MKT = R.NEW(EB.CUR.CURRENCY.MARKET)
    LOCATE '1' IN CCY.MKT<1,1> SETTING CCY.POS THEN
        SELL.RATE.VAL = R.NEW(EB.CUR.SELL.RATE)<1,CCY.POS>
    END
    OLD.CCY.POS = ''
    OLD.CCY.MKT = R.OLD(EB.CUR.CURRENCY.MARKET)
    LOCATE '1' IN OLD.CCY.MKT<1,1> SETTING OLD.CCY.POS THEN
        OLD.SELL.RATE.VAL = R.OLD(EB.CUR.SELL.RATE)<1,OLD.CCY.POS>
    END
    IF OLD.SELL.RATE.VAL NE SELL.RATE.VAL THEN
        GOSUB CALC.STDEV
        GOSUB UPDATE.CCY.CONCAT
    END

RETURN
*----------------------------------------------------------------------------------------
CALC.STDEV:
***********
*
    IF OLD.SELL.RATE.VAL AND SELL.RATE.VAL THEN
        LN.SELL = LN(SELL.RATE.VAL/OLD.SELL.RATE.VAL)
    END
*
RETURN
*----------------------------------------------------------------------------------------
UPDATE.CCY.CONCAT:
*****************
*
    R.DR.REG.RIEN1.CONCAT = ''
    DR.REG.RIEN1.CONCAT.ERR = ''
    CALL F.READ(FN.DR.REG.RIEN1.CONCAT,ID.NEW,R.DR.REG.RIEN1.CONCAT,F.DR.REG.RIEN1.CONCAT,DR.REG.RIEN1.CONCAT.ERR)
    IF R.DR.REG.RIEN1.CONCAT THEN
        CNT.SELL = DCOUNT(R.DR.REG.RIEN1.CONCAT<DR.RIEN1.CONCAT.SELL.RATE>,@VM)
*        R.DR.REG.RIEN1.CONCAT<DR.RIEN1.CONCAT.SELL.RATE,CNT.SELL> = OLD.SELL.RATE.VAL
        R.DR.REG.RIEN1.CONCAT<DR.RIEN1.CONCAT.SELL.RATE,CNT.SELL+1> = SELL.RATE.VAL
        R.DR.REG.RIEN1.CONCAT<DR.RIEN1.CONCAT.LN.SELL,CNT.SELL> = LN.SELL
    END ELSE
        R.DR.REG.RIEN1.CONCAT<DR.RIEN1.CONCAT.SELL.RATE,1> = OLD.SELL.RATE.VAL
        R.DR.REG.RIEN1.CONCAT<DR.RIEN1.CONCAT.SELL.RATE,2> = SELL.RATE.VAL
        R.DR.REG.RIEN1.CONCAT<DR.RIEN1.CONCAT.LN.SELL,1> = LN.SELL
    END
    CALL F.WRITE(FN.DR.REG.RIEN1.CONCAT,ID.NEW,R.DR.REG.RIEN1.CONCAT)
*
RETURN
*----------------------------------------------------------------------------------------
*///////////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S ///////////////////////////*
*///////////////////////////////////////////////////////////////////////////////////////*
*----------------------------------------------------------------------------------------
INITIALISE:


RETURN
*----------------------------------------------------------------------------------------
OPEN.FILES:

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    FN.DR.REG.RIEN1.CONCAT = 'F.DR.REG.RIEN1.CONCAT'
    F.DR.REG.RIEN1.CONCAT = ''
    CALL OPF(FN.DR.REG.RIEN1.CONCAT,F.DR.REG.RIEN1.CONCAT)

RETURN
*-----------------------------------------------------------------------------------------
END
