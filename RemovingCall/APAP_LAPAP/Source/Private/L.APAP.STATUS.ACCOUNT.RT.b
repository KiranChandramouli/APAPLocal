$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.STATUS.ACCOUNT.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM and T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.LOOKUP

    Y.ACCT = O.DATA
    Y.ESTATUS.FINAL = ''

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.EB.LOOKUP='F.EB.LOOKUP'
    F.EB.LOOKUP=''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    LREF.APP = 'ACCOUNT'
    LREF.FIELDS = 'L.AC.STATUS1':@VM:'L.AC.STATUS2'
    LREF.POS=''

    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    L.AC.STATUS1.POS=LREF.POS<1,1>
    L.AC.STATUS2.POS=LREF.POS<1,2>
    Y.STATUS1.DESC = ''
    Y.STATUS2.DESC = ''
    EB.LOOKUP.ID = ''
    EB.LOOKUP.VAL = ''

    CALL F.READ(FN.ACCOUNT,Y.ACCT,R.ACCOUNT,F.ACCOUNT,AC.ERR)

    IF R.ACCOUNT THEN
        Y.STATUS1 = R.ACCOUNT<AC.LOCAL.REF><1,L.AC.STATUS1.POS>
        Y.STATUS2 = R.ACCOUNT<AC.LOCAL.REF><1,L.AC.STATUS2.POS>

        IF Y.STATUS1 THEN
            EB.LOOKUP.ID = 'L.AC.STATUS1':'*':Y.STATUS1
            GOSUB GET.EB.LOOKUP
            Y.STATUS1.DESC = EB.LOOKUP.VAL
        END

        IF Y.STATUS2 THEN
            EB.LOOKUP.ID = 'L.AC.STATUS2':'*':Y.STATUS2
            GOSUB GET.EB.LOOKUP
            Y.STATUS2.DESC = EB.LOOKUP.VAL
        END

        Y.ESTATUS.FINAL = Y.STATUS1.DESC : '/' : Y.STATUS2.DESC

    END

    O.DATA = Y.ESTATUS.FINAL

RETURN

**************
GET.EB.LOOKUP:
**************
    R.EB.LOOKUP = ''; EB.LOOKUP.ERR = ''; YORG.LKID = ''
    CALL F.READ(FN.EB.LOOKUP,EB.LOOKUP.ID,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
    IF R.EB.LOOKUP THEN
        EB.LOOKUP.VAL = R.EB.LOOKUP<EB.LU.DESCRIPTION,2>
    END ELSE
        EB.LOOKUP.VAL = ''
    END

RETURN

END
