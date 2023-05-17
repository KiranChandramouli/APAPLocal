*
*-----------------------------------------------------------------------------
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
