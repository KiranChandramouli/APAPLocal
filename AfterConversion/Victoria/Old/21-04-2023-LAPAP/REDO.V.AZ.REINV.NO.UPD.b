$PACKAGE APAP.LAPAP
SUBROUTINE REDO.V.AZ.REINV.NO.UPD
*
* Description: This INPUT routine is attached to the version- 'AZ.ACCOUNT,NOR.PRECLOSURE.AUTH',
*              'ACCOUNT.CLOSURE,REDO.NAO.AUTH' and 'ACCOUNT.CLOSURE,REDO.NAO.TELLER.AUTH'
*              to update the deposit number in the closure record.
* Dev By     : V.P.Ashokkumar
******************************************************************************
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
*DATE           WHO                 REFERENCE               DESCRIPTION
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*21-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE ;*R22 AUTO CONVERSION END

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    LOC.REF.APP = 'ACCOUNT.CLOSURE':@FM:'ACCOUNT' ;*R22 AUTO CONVERSION
    LOC.REF.FIELD = 'L.AC.AZ.ACC.REF':@FM:'L.AC.AZ.ACC.REF' ;*R22 AUTO CONVERSION
    YLOC.REF = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,YLOC.REF)
    POS.AZ.ACC.REF.CLOSE    = YLOC.REF<1,1>
    POS.AZ.ACC.REF          = YLOC.REF<2,1>
RETURN

PROCESS:
********
    ACC.ERR = ''; R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF NOT(R.ACCOUNT) THEN
        RETURN
    END

    R.NEW(AC.ACL.LOCAL.REF)<1,POS.AZ.ACC.REF.CLOSE> = R.ACCOUNT<AC.LOCAL.REF,POS.AZ.ACC.REF>
RETURN
END
