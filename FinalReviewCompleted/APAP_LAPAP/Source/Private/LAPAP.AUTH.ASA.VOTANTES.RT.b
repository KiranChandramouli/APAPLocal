* @ValidationCode : MjotMjI4OTY3OTgxOkNwMTI1MjoxNjkwMTY3NTM5OTg4OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.AUTH.ASA.VOTANTES.RT

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts 

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT I_F.ST.L.APAP.ASAMBLEA.VOTANTE
    $INSERT I_F.ST.L.APAP.ASAMBLEA.PARAM

    FN.PA = "FBNK.ST.L.APAP.ASAMBLEA.PARTIC"
    FV.PA = ""
    FN.VOT = "FBNK.ST.L.APAP.ASAMBLEA.VOTANTE"
    FV.VOT = ""
    FN.PRM = "FBNK.ST.L.APAP.ASAMBLEA.PARAM"
    FV.PRM = ""

    CALL OPF(FN.PA,FV.PA)
    CALL OPF(FN.VOT,FV.VOT)
    CALL OPF(FN.PRM,FV.PRM)

    Y.CUENTAS = R.NEW(ST.L.AV.CUENTAS)
    Y.QNT = DCOUNT(Y.CUENTAS,@VM)

    FOR A = 1 TO Y.QNT STEP 1
        Y.CUENTA.ACTUAL = Y.CUENTAS<1,A>
        GOSUB MARCAR.CUENTA
    NEXT A

RETURN

MARCAR.CUENTA:
    CALL F.READ(FN.PA, Y.CUENTA.ACTUAL, R.PA, FV.PA, PA.ERR)
    R.PA<ST.L.APA.CUENTA.PARTICIPO> = "SI"
    R.PA<ST.L.APA.CLIENTE.PARTICIPO> = R.NEW(ST.L.AV.CODIGO.CLIENTE)
    CALL F.READ(FN.PRM, "4", R.PRM4, FV.PRM, PRM1.ERR)
    Y.PA.FECHA.ASAMBLEA = R.PRM4<ST.L.A95.VALOR>
    Y.ANO = Y.PA.FECHA.ASAMBLEA[1,4]
    Y.ANO.ACT = Y.ANO - 1
    GOSUB MANDAR.OFS
RETURN

MANDAR.OFS:
    Y.TRANS.ID = Y.CUENTA.ACTUAL : "-" : Y.ANO.ACT
    Y.APP.NAME = "ST.L.APAP.ASAMBLEA.PARTIC"
    Y.VER.NAME = Y.APP.NAME :",INP"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = "0"
    FINAL.OFS = ""

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.PA,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"ASAMBLEA.OFS",'')

RETURN
END
