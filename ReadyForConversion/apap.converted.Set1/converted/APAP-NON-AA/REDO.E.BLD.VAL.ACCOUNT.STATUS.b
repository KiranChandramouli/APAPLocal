PROGRAM REDO.E.BLD.VAL.ACCOUNT.STATUS

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : H GANESH
* Program Name  : REDO.E.BLD.VAL.ACCOUNT.STATUS'
*-------------------------------------------------------------------------
* Description: This routine is a build routine attached to all enquiries
* which have account no as selection field to restrict unauthorised access
*----------------------------------------------------------
* Linked with: All enquiries with Customer no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 01-09-10          ODR-2010-08-0031              Routine to validate Account

*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.BENEFICIARY
    $INSERT I_EB.EXTERNAL.COMMON

    GOSUB OPENFILES
    GOSUB MULTI.GET.LOCREF
    GOSUB PROCESS

RETURN

*---------
OPENFILES:
*---------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.BENEFICIARY = 'F.BENEFICIARY'
    F.BENEFICIARY  = ''
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)

RETURN

******************
MULTI.GET.LOCREF:
******************
    LREF.POS = ''
    LREF.APP='ACCOUNT'
    LREF.FIELDS='L.AC.STATUS1':@VM:'L.AC.AV.BAL':@VM:'L.AC.NOTIFY.1':@VM:'L.AC.STATUS2'
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    ACCT.STATUS.POS=LREF.POS<1,1>
    ACCT.OUT.BAL.POS=LREF.POS<1,2>
    NOTIFY.POS = LREF.POS<1,3>
    ACCT.STATUS2.POS = LREF.POS<1,4>
RETURN
*-----------------------------------------
PROCESS:
*-----------------------------------------
* Main enquiry process is carried on here
*-----------------------------------------

    SEL.CMD="SELECT ":FN.BENEFICIARY: " WITH  OWNING.CUSTOMER EQ ":EXT.SMS.CUSTOMERS
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.BENF)
    LOOP
        REMOVE BEN.ID FROM SEL.LIST SETTING ACCT.POS
    WHILE BEN.ID:ACCT.POS
        CALL CACHE.READ(FN.BENEFICIARY, BEN.ID, R.BENEFICIARY, BENEFICIARY.ERR)
        IF NOT(BENEFICIARY.ERR) THEN

            Y.BEN.ACCT.NO = R.BENEFICIARY<ARC.BEN.BEN.ACCT.NO>

            CALL F.READ(FN.ACCOUNT,Y.BEN.ACCT.NO,R.ACC,F.ACCOUNT,ACCOUNT.ERR)




            ENQ.DATA<4,-1>= BEN.ID

        END
    REPEAT

RETURN
END
