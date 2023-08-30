* @ValidationCode : MjotMTI2MDY4OTExOkNwMTI1MjoxNjgxNzA3NTcyMjcyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 10:29:32
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
SUBROUTINE REDO.B.UPDATE.DETAILS.ACH.SELECT
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.B.UPDATE.DETAILS.ACH.SELECT
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : This is .select routine will fetch the interest payment details using core routine
* E.STMT.ENQ.BY.CONCAT
* In parameter  :
* out parameter :
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 13-01-2011      MARIMUTHU s     ODR-2009-10-0795  Initial Creation
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - FM TO @FM
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.PAY.MODE.PARAM
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.DATES
    $INSERT I_REDO.B.UPDATE.DETAILS.ACH.COMMON
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    CALL CACHE.READ(FN.REDO.H.PAY.MODE.PARAM,'SYSTEM',R.REDO.H.PAY.MODE.PARAM,F.REDO.H.PAY.MODE.PARAM)
    Y.PAYMNT.MODE = R.REDO.H.PAY.MODE.PARAM<REDO.H.PAY.PAYMENT.MODE>
    LOCATE 'Transfer.via.ACH' IN Y.PAYMNT.MODE<1,1> SETTING POS THEN
        Y.ACCT.NO = R.REDO.H.PAY.MODE.PARAM<REDO.H.PAY.ACCOUNT.NO,POS>
    END

    IF Y.ACCT.NO THEN
        CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT THEN
            Y.LAST.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
            D.FIELDS = 'ACCOUNT':@FM:'BOOKING.DATE'
            D.LOGICAL.OPERANDS = 1:@FM:4
            D.RANGE.AND.VALUE = Y.ACCT.NO:@FM:Y.LAST.DAY
            Y.VALUE.LIST = ''
            CALL E.STMT.ENQ.BY.CONCAT(Y.VALUE.LIST)
            CALL BATCH.BUILD.LIST('',Y.VALUE.LIST)
        END
    END
RETURN
*-----------------------------------------------------------------------------
END
