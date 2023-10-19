* @ValidationCode : MjoxODU5NzEyMjM6Q3AxMjUyOjE2ODI0MTIzMzk3OTM6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:39
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
SUBROUTINE REDO.V.AUTH.PROFIT.LOSS
*-----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* This is Version control routine for FOREX
* It is attached to before auth field
* As per the POOL.RATE field in the Forex, PROFIT.LOSS local field is updated
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                 Reference
* 09-AUG-10    Kishore.SP            INITIALVERSION
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*10-04-2023       Conversion Tool        R22 Auto Code conversion          VM TO @VM
*10-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------------
 
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_F.CURRENCY
    $INSERT I_REDO.FX.OVR.COMMON
*-----------------------------------------------------------------------------
*
    GOSUB INTIALISE
    GOSUB CHECK.VALUE
*
RETURN
*-----------------------------------------------------------------------------
INTIALISE:
*----------
* Open the needed file and get the local field positions
*
    FN.FOREX = 'F.FOREX'
    F.FOREX  = ''
    CALL OPF(FN.FOREX,F.FOREX)
*
    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)
*
    LOC.REF.APPL="FOREX"
    LOC.REF.FIELDS="L.FX.POOL.RATE":@VM:"L.FX.PRFT.LOSS"
    LOC.REF.POS=" "
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.PL.RT.POS   =  LOC.REF.POS<1,1>
    Y.PR.LS.POS   =  LOC.REF.POS<1,2>
*
RETURN
*-----------------------------------------------------------------------------
CHECK.VALUE:
*-----------
* If the POOL.RATE field is NULL then return
*
    Y.POOL.RATE = R.NEW(FX.LOCAL.REF)<1,Y.PL.RT.POS>
    IF Y.POOL.RATE NE '' THEN
        Y.AMT.BOUGHT   = R.NEW(FX.AMOUNT.BOUGHT)
        Y.AMT.SOLD     = R.NEW(FX.AMOUNT.SOLD)
        Y.BUY.CCY      = R.NEW(FX.CURRENCY.BOUGHT)
        Y.SELL.CCY     = R.NEW(FX.CURRENCY.SOLD)
        GOSUB CAL.TRAN.AMT
    END
RETURN
*-----------------------------------------------------------------------------
CAL.TRAN.AMT:
*------------
* checking if any one of the BUY or SELL currency is a foreign currency
* calculation od TRANS AMOUNT and value is updated in PROFIT.LOSS field
* Y.TRANS.BAMT, it is used to format the value as amount
*
    IF Y.BUY.CCY NE LCCY THEN
        Y.TRANS.BUY.AMOUNT = (Y.AMT.BOUGHT * Y.POOL.RATE) - Y.AMT.SOLD
        Y.TRANS.BAMT  =  FMT(Y.TRANS.BUY.AMOUNT,"L2")
        R.NEW(FX.LOCAL.REF)<1,Y.PR.LS.POS> = Y.TRANS.BAMT
        GOSUB OVR.BUY.VALUE
    END
*
    IF Y.SELL.CCY NE LCCY THEN
        Y.TRANS.SELL.AMT = (Y.AMT.SOLD * Y.POOL.RATE) - Y.AMT.BOUGHT
        Y.TRANS.SELL.AMOUNT = Y.TRANS.SELL.AMT * -1
        Y.TRANS.SAMT  =  FMT(Y.TRANS.SELL.AMOUNT,"L2")
        R.NEW(FX.LOCAL.REF)<1,Y.PR.LS.POS> = Y.TRANS.SAMT
        GOSUB OVR.SELL.VALUE
    END
*
RETURN
*-----------------------------------------------------------------------------
OVR.BUY.VALUE:
*-------------
* If the calcalated value is less than ZERO then it is loss
* An override message is thrown
*
    IF Y.TRANS.BAMT LT '0' THEN
        IF V$FUNCTION EQ 'I' THEN
            TEXT = 'REDO-BUY.RATE.GT.POOL.RATE'
            CALL STORE.OVERRIDE(CURR.NO)
            Y.FX.OVERRIDE.DET<-1> = 'REDO-BUY.RATE.GT.POOL.RATE'
        END
    END
RETURN
*-----------------------------------------------------------------------------
OVR.SELL.VALUE:
*-------------
* If the calcalated value is less than ZERO then it is loss
* An override message is thrown
*
    IF Y.TRANS.SAMT LT '0' THEN
        IF V$FUNCTION EQ 'I' THEN
            TEXT = 'REDO-SELL.RATE.GT.POOL.RATE'
            CALL STORE.OVERRIDE(CURR.NO)
            Y.FX.OVERRIDE.DET<-1> = 'REDO-SELL.RATE.GT.POOL.RATE'
        END
    END
*
RETURN
*-----------------------------------------------------------------------------
END
