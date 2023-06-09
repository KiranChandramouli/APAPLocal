* @ValidationCode : Mjo4MjE0OTcxODI6Q3AxMjUyOjE2ODQyMjI4MTA4Njc6SVRTUzotMTotMTo0NTc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 457
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.IVR.V.ACCSTABALDR
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Program   Name    :LAPAP.IVR.V.ACCSTABALDR based on REDO.IVR.V.ACCSTABALDR by RMONDRAGON
*---------------------------------------------------------------------------------
*DESCRIPTION       :It is the input routine to validate the credit and debit accounts
*                   for balance and status.
* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference             Description
* 03-DIC-2018      MEMARTINEZ        CN009521               Initial Copy
* 21-APR-2023      Conversion tool   R22 Auto conversion    INCLUDE to INSERT, VM to @VM , FM to @FM,BP is removed in Insert File
* 21-APR-2023      Narmadha V        R22 Manual Conversion    No Changes
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.POSTING.RESTRICT
    $INSERT I_F.EB.LOOKUP ;*R22 Auto conversion - END

    GOSUB INIT
    GOSUB PROCESS

RETURN

*----
INIT:
*----

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.POSTING.RESTRICT = 'F.POSTING.RESTRICT'
    F.POSTING.RESTRICT = ''
    CALL OPF(FN.POSTING.RESTRICT,F.POSTING.RESTRICT)

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    LREF.APP = 'ACCOUNT'
    LREF.FIELDS = 'L.AC.STATUS1':@VM:'L.AC.STATUS2':@VM:'L.AC.NOTIFY.1'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    L.AC.STATUS1.POS=LREF.POS<1,1>
    L.AC.STATUS2.POS=LREF.POS<1,2>
    L.AC.NOTIFY.POS=LREF.POS<1,3>
    Y.END.DATE.VAL = ''
    Y.FROM.DATE.VAL1 = ''
    Y.FROM.DATE.INIT = ''

*-------
PROCESS:
*-------

    Y.VAR.ACC.NO = COMI

    CALL F.READ(FN.ACCOUNT,Y.VAR.ACC.NO,R.ACCOUNT,F.ACCOUNT,ERR)
    IF R.ACCOUNT THEN
        Y.CUS.DEBIT = R.ACCOUNT<AC.CUSTOMER>
        GOSUB CHECK.STATUS
    END

RETURN

*------------
CHECK.STATUS:
*------------

    Y.ACC.STATUS1 = R.ACCOUNT<AC.LOCAL.REF><1,L.AC.STATUS1.POS>

    IF Y.ACC.STATUS1 NE 'ACTIVE' AND Y.ACC.STATUS1 NE '' THEN
        Y.ACC.NOTIF = 'L.AC.STATUS1*':Y.ACC.STATUS1
        GOSUB GET.RES.DESC
        ETEXT = 'EB-INACT.ACCOUNT':@FM:Y.ACC.N.DESC
        CALL STORE.END.ERROR
        RETURN
    END

    Y.ACC.STATUS2 = R.ACCOUNT<AC.LOCAL.REF><1,L.AC.STATUS2.POS>

    IF Y.ACC.STATUS2 EQ 'DECEASED' THEN
        Y.ACC.NOTIF = 'L.AC.STATUS2*DECEASED'
        GOSUB GET.RES.DESC
        ETEXT = 'EB-INACT.ACCOUNT':@FM:Y.ACC.N.DESC
        CALL STORE.END.ERROR
        RETURN
    END

    Y.PR.ID = R.ACCOUNT<AC.POSTING.RESTRICT>

    IF Y.PR.ID EQ '1' OR Y.PR.ID EQ '3' THEN
        GOSUB DISPLAY.ERR.IF
    END

    Y.ACC.NOTIF = R.ACCOUNT<AC.LOCAL.REF><1,L.AC.NOTIFY.POS>

    IF Y.ACC.NOTIF EQ 'NOTIFY.MGMT.MONEY.LAUNDRY.PREV' OR Y.ACC.NOTIF EQ 'NOTIFY.OFFICER' THEN
        Y.ACC.NOTIF = 'L.AC.NOTIFY.1*':Y.ACC.NOTIF
        GOSUB GET.RES.DESC
        ETEXT = 'EB-REDO.IVR.PR.BLOCK':@FM:Y.ACC.N.DESC
        CALL STORE.END.ERROR
        RETURN
    END

    Y.ACCT.OVER = R.ACCOUNT<AC.OVERRIDE>

    IF Y.ACCT.OVER NE '' THEN
        GOSUB GET.NOTIF
        IF Y.CNT.OVR GE 1 THEN
            ETEXT = 'EB-REDO.IVR.V.OVERRIDEACCT'
            CALL STORE.END.ERROR
            RETURN
        END
        RETURN
    END

RETURN

*---------
GET.NOTIF:
*---------

    Y.CNT.OVR = 0
    Y.CNT.OVR += COUNT(Y.ACCT.OVER,'REDO.AC.CHECK.ACTIVE')
    Y.CNT.OVR += COUNT(Y.ACCT.OVER,'REDO.SEGURIDAD.PRODUCTOS')
    Y.CNT.OVR += COUNT(Y.ACCT.OVER,'REDO.TELLER')
    Y.CNT.OVR += COUNT(Y.ACCT.OVER,'REDO.VALIDAR.ID')

RETURN

*------------
GET.RES.DESC:
*------------

    R.EBL = ''; EBL.ERR = ''
    CALL F.READ(FN.EB.LOOKUP,Y.ACC.NOTIF,R.EBL,F.EB.LOOKUP,EBL.ERR)
    IF R.EBL THEN
        Y.ACC.N.DESC = R.EBL<EB.LU.DESCRIPTION>
    END

RETURN

*--------------
DISPLAY.ERR.IF:
*--------------

    R.PR = ''; PR.ERR = ''
    CALL CACHE.READ(FN.POSTING.RESTRICT, Y.PR.ID, R.PR, PR.ERR) ;*R22 Auto conversion
    IF R.PR THEN
        Y.PR.DESC = R.PR<AC.POS.DESCRIPTION>
        ETEXT = 'EB-REDO.IVR.PR.BLOCK':@FM:Y.PR.DESC
        CALL STORE.END.ERROR
        RETURN
    END

RETURN

END
