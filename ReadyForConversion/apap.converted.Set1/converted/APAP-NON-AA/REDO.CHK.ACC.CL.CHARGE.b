SUBROUTINE REDO.CHK.ACC.CL.CHARGE

*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at check Record Routine for the account closure versions.
* It is used to update the Charge code value based on product and also update the az account number.
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.CHK.ACC.CL.CHARGE
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE          WHO                 REFERENCE       DESCRIPTION
* 23-11-2011    Sudharsanan S       PACS00164625    Initial Creation.
* 14-03-2013    Sudharsanan S       PACS00253711    Override to be displayed for the Deposit liq acct closure
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.CUSTOMER
    $INSERT I_F.ACCOUNT.CLOSURE

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
*-------------------------------------------------------------------------------
    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LOC.REF.APP = 'ACCOUNT.CLOSURE':@FM:'ACCOUNT'
    LOC.REF.FIELD = 'L.ACL.WAIVE.CHG':@VM:'L.AC.AZ.ACC.REF':@VM:'L.AC.CAN.REASON':@VM:'L.AC.OTH.REASON':@FM:'L.AC.AZ.ACC.REF'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)
    POS.WAIVE.CHG.CLOSE     = LOC.REF.POS<1,1>
    POS.AZ.ACC.REF.CLOSE    = LOC.REF.POS<1,2>
    POS.CAN.REASON          = LOC.REF.POS<1,3>
    POS.OTH.REASON          = LOC.REF.POS<1,4>
    POS.AZ.ACC.REF          = LOC.REF.POS<2,1>
RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------
* This is the main para used to check the category and update the charge related fields
    VAR.ACC.ID = ID.NEW
    CALL F.READ(FN.ACCOUNT,VAR.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    VAR.AZ.ACC.REF = R.ACCOUNT<AC.LOCAL.REF,POS.AZ.ACC.REF>
    IF VAR.AZ.ACC.REF THEN
        R.NEW(AC.ACL.CLO.CHARGE.TYPE) = ''
        R.NEW(AC.ACL.CLO.CHARGE.AMT) = ''
        R.NEW(AC.ACL.LOCAL.REF)<1,POS.WAIVE.CHG.CLOSE> = ''
        T(AC.ACL.CLO.CHARGE.TYPE)<3> = 'NOINPUT'
        T(AC.ACL.CLO.CHARGE.AMT)<3> = 'NOINPUT'
        T.LOCREF<POS.WAIVE.CHG.CLOSE,7> = 'NOINPUT'
        T.LOCREF<POS.CAN.REASON,7> = 'NOINPUT'
        T.LOCREF<POS.OTH.REASON,7> = 'NOINPUT'
        R.NEW(AC.ACL.LOCAL.REF)<1,POS.AZ.ACC.REF.CLOSE> = VAR.AZ.ACC.REF

* Fix for PACS00253711 [Override to be displayed for the Deposit liq acct closure]

        IF OFS$OPERATION EQ 'PROCESS' THEN
            TEXT='AZ.ACC.CLOSE':@FM:VAR.ACC.ID:@VM:VAR.AZ.ACC.REF
            CURR.NO=DCOUNT(R.NEW(AC.ACL.OVERRIDE),@VM)+1
            CALL STORE.OVERRIDE(CURR.NO)

        END

* End of Fix

    END
RETURN
*---------------------------------------------------------------------------------------------------------------
END
