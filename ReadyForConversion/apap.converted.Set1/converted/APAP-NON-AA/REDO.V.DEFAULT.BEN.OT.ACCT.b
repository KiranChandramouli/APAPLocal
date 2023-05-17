SUBROUTINE REDO.V.DEFAULT.BEN.OT.ACCT

*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.V.DEFAULT.BEN.OT.ACCT
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry AI.REDO.BANK.STOP.PAY.ACCT.LIST
* Linked with : Enquiry AI.REDO.BANK.STOP.PAY.ACCT.LIST as BUILD routine
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER

    GOSUB PROCESS
RETURN
*----------*
PROCESS:
*-----------*


    FN.BENEFICIARY = 'F.BENEFICIARY'
    F.BENEFICIARY  = ''
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)


    LOC.BEN.FIELD  = 'L.BEN.ACCOUNT':@FM:'L.FT.ACH.B.ACC'
    LREF.APP       ='BENEFICIARY':@FM:'FUNDS.TRANSFER'
    BEN.FT.FLD.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LOC.BEN.FIELD,BEN.FT.FLD.POS)
    BEN.ACT.POS         = BEN.FT.FLD.POS<1,1>
    FT.ACH.BEN.ACCT.POS = BEN.FT.FLD.POS<2,1>
    BEN.ID = R.NEW(FT.BENEFICIARY.ID)
    CALL CACHE.READ(FN.BENEFICIARY, BEN.ID, R.BEN, BEN.ERR)

    R.NEW(FT.LOCAL.REF)<1,FT.ACH.BEN.ACCT.POS> = R.BEN<ARC.BEN.LOCAL.REF,BEN.ACT.POS>

RETURN

END
