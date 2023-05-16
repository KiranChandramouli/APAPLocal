* @ValidationCode : Mjo1OTMxODY0Nzk6Q3AxMjUyOjE2ODIzMzU5NDM2Mzc6SVRTUzotMTotMTo1NDg6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 548
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1 , F.READ TO CACHE.READ
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.V.ACC.CREDIT.MOB
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.POSTING.RESTRICT
    $INSERT I_F.EB.LOOKUP ;* AUTO R22 CODE CONVERSION END

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
    Y.OTHER.CUS = ''

RETURN

*-------
PROCESS:
*-------

    Y.VAR.ACC.NO = R.NEW(FT.DEBIT.ACCT.NO)

    CALL F.READ(FN.ACCOUNT,Y.VAR.ACC.NO,R.ACCOUNT,F.ACCOUNT,ERR)
    IF R.ACCOUNT THEN
        IF R.ACCOUNT<AC.JOINT.HOLDER> NE '' THEN
            DR.CUS.SET = R.ACCOUNT<AC.CUSTOMER>:@VM:R.ACCOUNT<AC.JOINT.HOLDER>
        END ELSE
            DR.CUS.SET = R.ACCOUNT<AC.CUSTOMER>
        END
    END

    Y.VAR.ACC.NO = ''
    R.ACCOUNT = ''
    ERR = ''

    Y.VAR.ACC.NO = COMI

    CALL F.READ(FN.ACCOUNT,Y.VAR.ACC.NO,R.ACCOUNT,F.ACCOUNT,ERR)
    IF R.ACCOUNT THEN
        IF Y.VAR.ACC.NO[1,2] NE 'PL' THEN
            GOSUB CHECK.STATUS
            IF R.ACCOUNT<AC.JOINT.HOLDER> NE '' THEN
                CR.CUS.SET = R.ACCOUNT<AC.CUSTOMER>:@VM:R.ACCOUNT<AC.JOINT.HOLDER>
            END ELSE
                CR.CUS.SET = R.ACCOUNT<AC.CUSTOMER>
            END
        END
    END

    GOSUB CHECK.CUS.RELATED

    IF PGM.VERSION EQ ',REDO.IVR.APAPCTAS' THEN
        IF IF.CUS.REL EQ '' THEN
            ETEXT = 'EB-REDO.NOT.SAME.BEN'
            CALL STORE.END.ERROR
            RETURN
        END
    END

    IF PGM.VERSION EQ ',REDO.IVR.APAPCTASBEN' THEN
        IF IF.CUS.REL EQ 'Y' THEN
            ETEXT = 'EB-REDO.NOT.SAME.BEN2'
            CALL STORE.END.ERROR
            RETURN
        END
    END

RETURN

*-----------------
CHECK.CUS.RELATED:
*-----------------

    IF.CUS.REL = ''

    Y.TOT.DR.CUS.SET = DCOUNT(DR.CUS.SET,@VM)
    Y.TOT.CR.CUS.SET = DCOUNT(CR.CUS.SET,@VM)

    Y.CNT.DR.CUS = 1
    LOOP
    WHILE Y.CNT.DR.CUS LE Y.TOT.DR.CUS.SET
        Y.DR.CUS = FIELD(DR.CUS.SET,@VM,Y.CNT.DR.CUS)
        Y.CNT.CR.CUS = 1
        LOOP
        WHILE Y.CNT.CR.CUS LE Y.TOT.CR.CUS.SET
            Y.CR.CUS = FIELD(CR.CUS.SET,@VM,Y.CNT.CR.CUS)
            IF Y.DR.CUS EQ Y.CR.CUS THEN
                IF.CUS.REL = 'Y'
                Y.CNT.CR.CUS = Y.TOT.CR.CUS.SET
                Y.CNT.DR.CUS = Y.TOT.DR.CUS.SET
            END
            Y.CNT.CR.CUS += 1 ;* AUTO R22 CODE CONVERSION
        REPEAT
        Y.CNT.DR.CUS += 1 ;* AUTO R22 CODE CONVERSION
    REPEAT

RETURN

*------------
CHECK.STATUS:
*------------

    Y.ACC.STATUS1 = R.ACCOUNT<AC.LOCAL.REF><1,L.AC.STATUS1.POS>

    IF Y.ACC.STATUS1 NE 'ACTIVE' THEN
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

    IF Y.PR.ID EQ '2' OR Y.PR.ID EQ '3' OR Y.PR.ID EQ '6'  THEN
        GOSUB DISPLAY.ERR.IF
    END

    Y.ACC.NOTIF = R.ACCOUNT<AC.LOCAL.REF><1,L.AC.NOTIFY.POS>

    IF Y.ACC.NOTIF EQ 'NOTIFY.MGMT.MONEY.LAUNDRY.PREV' OR Y.ACC.NOTIF EQ 'NOTIFY.OFFICER' OR Y.ACC.NOTIF EQ 'SEGURIDAD.DE.PRODUCTOS' THEN
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
    END

RETURN

*---------
GET.NOTIF:
*---------

    Y.CNT.OVR = 0
    Y.CNT.OVR += COUNT(Y.ACCT.OVER,'REDO.AC.CHECK.ACTIVE')
    Y.CNT.OVR += COUNT(Y.ACCT.OVER,'REDO.SEGURIDAD.PRODUCTOS')
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
    CALL CACHE.READ(FN.POSTING.RESTRICT, Y.PR.ID, R.PR, PR.ERR) ;*AUTO R22 CODE CONVERSION
    IF R.PR THEN
        Y.PR.DESC = R.PR<AC.POS.DESCRIPTION>
        ETEXT = 'EB-REDO.IVR.PR.BLOCK':@FM:Y.PR.DESC
        CALL STORE.END.ERROR
        RETURN
    END

RETURN

END
