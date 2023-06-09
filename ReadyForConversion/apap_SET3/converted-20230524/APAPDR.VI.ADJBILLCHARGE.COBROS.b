SUBROUTINE APAPDR.VI.ADJBILLCHARGE.COBROS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY

    Y.ARR.ID = c_aalocArrId
    Y.ACT.EFF.DATE = c_aalocActivityEffDate
    R.ACCOUNT.DETAILS = c_aalocAccountDetails
    YAPPLN = 'AA.PRD.DES.CHARGE'
    YFIELDS = 'ChargesAmounts'
    YFIELD.POS = ''
    CALL MULTI.GET.LOC.REF(YAPPLN,YFIELDS,YFIELDS.POS)
    Y.CHARGE.AMT.POS = YFIELDS.POS<1,1>
    Idpropertyclass = ""
    Idproperty = "GESTIONCOBROS"
    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARR.ID, Idpropertyclass, Idproperty, Y.ACT.EFF.DATE, Returnids, Returnconditions, Returnerror)
    R.CHARGE = RAISE(Returnconditions)
    Y.CHARGE.AMT = R.CHARGE<AA.CHG.LOCAL.REF><1,Y.CHARGE.AMT.POS>
    IF c_aalocActivityStatus EQ "AUTH" THEN
        R.APP.RECORD<AA.ARR.ACT.ARRANGEMENT> = Y.ARR.ID
        R.APP.RECORD<AA.ARR.ACT.ACTIVITY> = "GESTIONCOBROS.CHARGE.ADJUSTMENT"
        R.APP.RECORD<AA.ARR.ACT.EFFECTIVE.DATE> = ''
*         R.APP.RECORD<AA.ARR.ACT.PROPERTY> = 'MANT.SALD.CUOTA'
*         R.APP.RECORD<AA.ARR.ACT.FIELD.NAME> = "NEW.PROP.AMT:1:3"
*         R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE> = Y.CHARGE.AMT
        APP.NAME = 'AA.ARRANGEMENT.ACTIVITY'
        OFS.FUNCTION='I'
        PROCESS='PROCESS'
        OFS.SOURCE.ID='LOAN.ACC.STATUS'
        OFSVERSION='AA.ARRANGEMENT.ACTIVITY,'
        GTSMODE=''
        NO.OF.AUTH='0'
        TRANSACTION.ID= ''

        OFS.STRING=''

        CALL OFS.BUILD.RECORD(APP.NAME,OFS.FUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.APP.RECORD,OFS.MESSAGE)

        OFS.MSG.ID = ''
        CALL OFS.POST.MESSAGE(OFS.MESSAGE,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
    END
RETURN

END
