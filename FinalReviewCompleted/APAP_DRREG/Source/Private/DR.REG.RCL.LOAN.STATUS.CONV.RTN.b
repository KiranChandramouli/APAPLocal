* @ValidationCode : MjoxNzk5NDQ2NjQ1OkNwMTI1MjoxNjg0ODU2ODcyNzE4OklUU1M6LTE6LTE6LTQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -4
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
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RCL.LOAN.STATUS.CONV.RTN
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.OVERDUE

    $INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON

    ArrangementID = COMI
    effectiveDate = ''
    idPropertyClass = 'OVERDUE'
    idProperty = ''
    returnIds = ''
    returnConditions = ''
    returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
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
