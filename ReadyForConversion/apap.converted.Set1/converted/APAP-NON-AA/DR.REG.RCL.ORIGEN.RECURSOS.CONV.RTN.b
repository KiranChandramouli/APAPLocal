*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RCL.ORIGEN.RECURSOS.CONV.RTN
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON

    R.AA.ARRANGEMENT = RCL$COMM.LOAN(1)
** Get SECTOR
** IF SEC.VAL EQ '03.01.99' THEN
    ArrangementID = COMI
    effectiveDate = ''
    idPropertyClass = 'ACCOUNT'
    idProperty = ''
    returnIds = ''
    returnConditions = ''
    returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.ARR.ACCOUNT = RAISE(returnConditions)
*    IF R.AA.ARR.ACCOUNT<1> EQ 'LENDING-TAKEOVER-ARRANGEMENT' OR R.AA.ARR.ACCOUNT<1> EQ 'LENDING-NEW-ARRANGEMENT' THEN
    SOURCE.OF.FUNDS = R.AA.ARR.ACCOUNT<AA.AC.LOCAL.REF,ORIGEN.RECURSOS.POS>
    IF SOURCE.OF.FUNDS EQ '01' THEN
        SOURCE.OF.FUNDS.VAL = '01'
    END ELSE
        SOURCE.OF.FUNDS.VAL = '02'
    END
*    END
*END ELSE
* SOURCE.OF.FUNDS.VAL = ''
*END
*
    COMI = SOURCE.OF.FUNDS.VAL
*
RETURN
END
