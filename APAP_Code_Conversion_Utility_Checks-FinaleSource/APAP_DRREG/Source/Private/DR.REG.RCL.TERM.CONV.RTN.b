* @ValidationCode : MjoxOTY1NTI5ODIwOkNwMTI1MjoxNzAyOTYzOTg4MTg5OjMzM3N1Oi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 11:03:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*14/12/2023       Suresh                      R22 Manual Conversion      Call routine Modified

*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RCL.TERM.CONV.RTN
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.TERM.AMOUNT
    
    
    $USING AA.Framework ;*R22 Manual Conversion

    ArrangementID = COMI
    effectiveDate = ''
    idPropertyClass = 'TERM.AMOUNT'
    idProperty = ''
    returnIds = ''
    returnConditions = ''
    returnError = ''

*   CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError) ;*R22 Manual Conversion
    R.AA.TERM.AMOUNT = RAISE(returnConditions)
*    ACTIVITY = R.AA.TERM.AMOUNT<1>      ;* Activity id as per file layout
*    IF ACTIVITY EQ 'LENDING-DISBURSE-COMMITMENT' OR ACTIVITY EQ 'LENDING-TAKEOVER-ARRANGEMENT' THEN
    TERM = R.AA.TERM.AMOUNT<AA.AMT.TERM>
    LEN.TERM = LEN(TERM)
    D.PART = LEN.TERM - 1
    IF TERM[D.PART,1] EQ 'D' THEN
        TERM.IN.DAYS = TERM[1,D.PART]
    END ELSE
        MAT.DATE = R.AA.TERM.AMOUNT<AA.AMT.MATURITY.DATE>
        ID.COM3 = FIELD(R.AA.TERM.AMOUNT<AA.AMT.ID.COMP.3>,'.',1)
        IF MAT.DATE AND ID.COM3 THEN
            Y.REGION = ''
            Y.DAYS   = 'C'
            CALL CDD(Y.REGION, MAT.DATE, ID.COM3, Y.DAYS)
            TERM.IN.DAYS = ABS(Y.DAYS)
        END ELSE
            TERM.IN.DAYS = ''
        END
    END
*    END
*
    COMI = TERM.IN.DAYS
*
RETURN
END
