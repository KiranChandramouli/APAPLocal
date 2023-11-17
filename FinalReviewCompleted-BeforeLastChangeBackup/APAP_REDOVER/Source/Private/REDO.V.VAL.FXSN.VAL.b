* @ValidationCode : Mjo5MDI5NDkyMDQ6Q3AxMjUyOjE2ODI0MTIzNjE1MzM6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:01
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
SUBROUTINE REDO.V.VAL.FXSN.VAL
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Chandra Prakash T
* Program Name  : REDO.V.VAL.FXSN.VAL
* ODR NUMBER    : ODR-2010-01-0213
*----------------------------------------------------------------------------------
* Description   : This VALIDATION routine will do a check the involvment of local currency in debit / credit side of the transaction, else it
*                 will raise an error message
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 08-Jul-2010      Chandra Prakash T  ODR-2010-01-0213  Initial creation
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*17-04-2023       Conversion Tool        R22 Auto Code conversion          LCCY.USED + 1 TO +=1
*17-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER

    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

    ERR.FLAG = 0
    BUY.FLAG = 0
    SELL.FLAG = 0
    LCCY.USED = 0

    BEGIN CASE
        CASE APPLICATION EQ 'FOREX'
            IF R.NEW(FX.CURRENCY.BOUGHT) EQ LCCY THEN
                LCCY.USED = 1
            END
            IF R.NEW(FX.CURRENCY.SOLD) EQ LCCY THEN
                LCCY.USED += 1
            END
            IF LCCY.USED NE 1 THEN
                ERR.FLAG = 1
            END
        CASE APPLICATION EQ 'FUNDS.TRANSFER'
            IF R.NEW(FT.DEBIT.CURRENCY) EQ LCCY THEN
                LCCY.USED = 1
            END
            IF R.NEW(FT.CREDIT.CURRENCY) EQ LCCY THEN
                LCCY.USED += 1
            END
            IF LCCY.USED NE 1 THEN
                ERR.FLAG = 1
            END
        CASE APPLICATION EQ 'TELLER'
            IF R.NEW(TT.TE.CURRENCY.1) EQ LCCY THEN
                LCCY.USED = 1
            END
            IF R.NEW(TT.TE.CURRENCY.2) EQ LCCY THEN
                LCCY.USED += 1
            END
            IF LCCY.USED NE 1 THEN
                ERR.FLAG = 1
            END
    END CASE

    IF ERR.FLAG EQ 1 THEN
        ETEXT = "EB-FXSN.ONLY.LCY.ALLOWED"
        CALL STORE.END.ERROR
    END

RETURN
END
