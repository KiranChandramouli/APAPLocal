* @ValidationCode : MjotMzYxMTYxNTQ6Q3AxMjUyOjE2ODI0MTIzNDU5ODg6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:45
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
SUBROUTINE REDO.V.DEFAULT.ACH
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.V.DEFAULT.ACH
* ODR NUMBER    : ODR-2009-10-0795
*---------------------------------------------------------------------------------------------------
* Description   : This routine will be attached to FT version to default the credit and debit ac nos
* In parameter  : none
* out parameter : none
*---------------------------------------------------------------------------------------------------
* Modification History :
*---------------------------------------------------------------------------------------------------
*   DATE             WHO                   REFERENCE                       DESCRIPTION
* 13-01-2011      MARIMUTHU s           ODR-2009-10-0795                 Initial Creation
*11-04-2023       Conversion Tool        R22 Auto Code conversion          FM TO @FM ,VM TO @VM
*11-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------------------------------

*---------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.PAY.MODE.PARAM
$INSERT I_F.FUNDS.TRANSFER
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
GOSUB INIT
GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
FN.REDO.H.PAY.MODE.PARAM = 'F.REDO.H.PAY.MODE.PARAM'
F.REDO.H.PAY.MODE.PARAM = ''

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*CALL CACHE.READ(FN.REDO.H.PAY.MODE.PARAM,'SYSTEM',R.REDO.H.PAY.MODE.PARAM,F.REDO.H.PAY.MODE.PARAM)
IDVAR.1 = 'SYSTEM' ;* R22 AUTO CONVERSION
CALL CACHE.READ(FN.REDO.H.PAY.MODE.PARAM,IDVAR.1,R.REDO.H.PAY.MODE.PARAM,F.REDO.H.PAY.MODE.PARAM);* R22 AUTO CONVERSION
Y.PAYMNT.MODE = R.REDO.H.PAY.MODE.PARAM<REDO.H.PAY.PAYMENT.MODE>
Y.PAYMNT.MODE = CHANGE(Y.PAYMNT.MODE,@VM,@FM)
LOCATE 'Transfer.via.ACH' IN Y.PAYMNT.MODE SETTING POS THEN
Y.DEB.ACCT.NO = R.REDO.H.PAY.MODE.PARAM<REDO.H.PAY.ACCOUNT.NO,POS>
END

R.NEW(FT.DEBIT.ACCT.NO) = Y.DEB.ACCT.NO

RETURN
*-----------------------------------------------------------------------------
END
