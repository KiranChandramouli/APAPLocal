* @ValidationCode : Mjo3MDI1MDA1NzQ6Q3AxMjUyOjE2ODI0MzAwNDQzMTQ6SVRTUzotMTotMToxNjI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 19:10:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 162
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.V.POS.TXN.AUTH.CODE
*
* Description: The Input routine to validate the authorisation code length for the POS transactions.
*              Attached to the version - 'TELLER,REDO.APAP.CC.LCY.CASHWDL'
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
*DATE           WHO                 REFERENCE               DESCRIPTION
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED, FM TO @FM,VM TO @VM
*21-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.CUSTOMER ;*R22 AUTO CONVERSION END

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    L.TT.POS.AUTHNM.POS = '';  L.TT.CR.CARD.NO.POS = ''; Y.CARD.NO = ''; Y.CLIENT.ID = ''
    Y.TXN.AMT = ''; YLOC.POSN = ''; YUNIQUE.ID = ''; YFIELD.NME = ''
    YFIELD.NME = "L.TT.POS.AUTHNM":@VM:"L.TT.CR.CARD.NO":@VM:"L.TT.CLIENT.COD":@VM:"L.TT.DOC.NUM":@VM:"L.TT.DOC.DESC":@FM:"L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.NOUNICO":@VM:"L.CU.ACTANAC":@VM:"L.CU.PASS.NAT" ;*R22 AUTO CONVERSION
    CALL MULTI.GET.LOC.REF('TELLER':@FM:'CUSTOMER',YFIELD.NME,YLOC.POSN) ;*R22 AUTO CONVERSION
    L.TT.POS.AUTHNM.POS = YLOC.POSN<1,1>
    L.TT.CR.CARD.NO.POS = YLOC.POSN<1,2>
    L.TT.CLIENT.COD.POS = YLOC.POSN<1,3>
    L.TT.DOC.NUM.POS = YLOC.POSN<1,4>
    L.TT.DOC.DESC.POS = YLOC.POSN<1,5>
    L.CU.CIDENT.POS = YLOC.POSN<2,1>
    L.CU.RNC.POS = YLOC.POSN<2,2>
    L.CU.NOUNICO.POS = YLOC.POSN<2,3>
    L.CU.ACTANAC.POS = YLOC.POSN<2,4>
    L.CU.PASS.NAT.POS = YLOC.POSN<2,5>

    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN

PROCESS:
********
    Y.CLIENT.ID = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.CLIENT.COD.POS>
    GOSUB GET.CLIENT.DET
    Y.CARD.NO = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.CR.CARD.NO.POS>
    GOSUB ERROR.MSG3
    YUNIQUE.ID = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.POS.AUTHNM.POS>
    GOSUB ERROR.MSG1
    Y.TXN.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
    GOSUB ERROR.MSG2
RETURN

ERROR.MSG1:
**********
    IF LEN(YUNIQUE.ID) NE 6 THEN
        AF = TT.TE.LOCAL.REF
        AV = L.TT.POS.AUTHNM.POS
        ETEXT = 'TT-LENGTH.SHOULD.BE.6'
        CALL STORE.END.ERROR
        RETURN
    END
RETURN

ERROR.MSG2:
***********
    IF Y.TXN.AMT LE 0 OR NOT(Y.TXN.AMT) THEN
        AF = TT.TE.AMOUNT.LOCAL.1
        ETEXT = 'TT-AMOUNT.SHOULD.NOT.BE.ZERO'
        CALL STORE.END.ERROR
        RETURN
    END
RETURN

ERROR.MSG3:
***********
    IF Y.CARD.NO EQ '0' OR LEN(Y.CARD.NO) NE '16' THEN
        AF = TT.TE.LOCAL.REF
        AV = L.TT.CR.CARD.NO.POS
        ETEXT = 'EB-WRONG.CARD.NO'
        CALL STORE.END.ERROR
        RETURN
    END
RETURN

GET.CLIENT.DET:
***************
    IF NOT(Y.CLIENT.ID) THEN
        RETURN
    END
    ERR.CUST = ''; R.CUSTOMER = ''; L.CU.CIDENT.VAL = ''; L.CU.RNC.VAL = ''
    L.CU.PASS.NAT.VAL = ''; L.CU.ACTANAC.VAL = ''; L.CU.NOUNICO.VAL = ''
    CALL F.READ(FN.CUSTOMER,Y.CLIENT.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUST)
    L.CU.CIDENT.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
    L.CU.RNC.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    L.CU.PASS.NAT.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.PASS.NAT.POS>
    L.CU.ACTANAC.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.ACTANAC.POS>
    L.CU.NOUNICO.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.NOUNICO.POS>
    IF L.CU.CIDENT.VAL AND  L.CU.CIDENT.VAL NE R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.NUM.POS> THEN
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.NUM.POS> = L.CU.CIDENT.VAL
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.DESC.POS> = "CEDULA"
    END
    IF L.CU.RNC.VAL AND L.CU.RNC.VAL NE R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.NUM.POS> THEN
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.NUM.POS> = L.CU.RNC.VAL
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.DESC.POS> = "RNC"
        RETURN
    END
    IF L.CU.NOUNICO.VAL AND L.CU.NOUNICO.VAL NE R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.NUM.POS> THEN
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.NUM.POS> = L.CU.NOUNICO.VAL
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.DESC.POS> = "CEDULA"
        RETURN
    END
    IF L.CU.ACTANAC.VAL AND L.CU.ACTANAC.VAL NE R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.NUM.POS> THEN
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.NUM.POS> = L.CU.ACTANAC.VAL
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.DESC.POS> = "CEDULA"
        RETURN
    END
    IF L.CU.PASS.NAT.VAL AND L.CU.PASS.NAT.VAL NE R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.NUM.POS> THEN
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.NUM.POS> = L.CU.PASS.NAT.VAL
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.DOC.DESC.POS> = "PASAPORTE"
        RETURN
    END
RETURN
END