$PACKAGE APAP.DRREG
* @ValidationCode : MjoxNTU3MTA2MTQ4OkNwMTI1MjoxNzAyNTU1NDU2Njk1OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Dec 2023 17:34:16
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
SUBROUTINE DR.REG.RCL.LOAN.STATUS.CONV.RTN
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.OVERDUE

    $INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON

    $USING AA.Framework ;*R22 Manual Conversion

    ArrangementID = COMI
    effectiveDate = ''
    idPropertyClass = 'OVERDUE'
    idProperty = ''
    returnIds = ''
    returnConditions = ''
    returnError = ''
*   CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError) ;*R22 Manual Conversion
    R.AA.OVERDUE = RAISE(returnConditions)
    LOAN.STATUS = R.AA.OVERDUE<AA.OD.LOCAL.REF,L.LOAN.STATUS.1.POS>
    IF LOAN.STATUS EQ 'JudicialCollection' OR LOAN.STATUS EQ 'Restructured' THEN
        BEGIN CASE
            CASE LOAN.STATUS EQ 'JudicialCollection'
                LOAN.STATUS.VAL = '125'
            CASE LOAN.STATUS EQ 'Restructured'
                LOAN.STATUS.VAL = '124'
        END CASE
    END ELSE
*        REC.ID = COMI
*        CALL F.READ(FN.AA.ACCOUNT.DETAILS,REC.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,AA.ACCOUNT.DETAILS.ERR)
        R.AA.ACCOUNT.DETAILS = RCL$COMM.LOAN(3)
        AGE.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS>
        BEGIN CASE
            CASE AGE.STATUS EQ 'DE1'
                LOAN.STATUS.VAL = '121'
            CASE AGE.STATUS EQ 'DE2'
                LOAN.STATUS.VAL = '121'
            CASE AGE.STATUS EQ ''
                LOAN.STATUS.VAL = '121'
            CASE AGE.STATUS EQ 'DEL'
                LOAN.STATUS.VAL = '122'
            CASE AGE.STATUS EQ 'NAB'
                LOAN.STATUS.VAL = '123'
        END CASE
    END
*
    COMI = LOAN.STATUS.VAL
*
RETURN
END
