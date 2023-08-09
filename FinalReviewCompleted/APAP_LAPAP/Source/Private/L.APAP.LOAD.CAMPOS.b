* @ValidationCode : MjotMzEwMzQwOTpDcDEyNTI6MTY5MDE2NzUzMzAyNTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:53
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
SUBROUTINE L.APAP.LOAD.CAMPOS
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       FM TO @FM, VM to @VM, SM to @SM, BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON                                ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ST.L.APAP.COVI.PRELACIONIII         ;*R22 Auto conversion - End

    GOSUB ABRIR.TABLA
    GOSUB GET.INFO
RETURN
ABRIR.TABLA:
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    FV.AA.ARRANGEMENT = ''
    CALL OPF (FN.AA.ARRANGEMENT,FV.AA.ARRANGEMENT)
RETURN

GET.INFO:
    Y.AA = ID.NEW

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA,R.AA.ARRANGEMENT,FV.AA.ARRANGEMENT,ERROR.ARR.ARRANGEMENT)
    Y.CONTRATO = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    Y.CONTRATO = CHANGE(Y.CONTRATO,@SM,@FM)
    Y.CONTRATO = CHANGE(Y.CONTRATO,@VM,@FM)
    Y.CONTRATO = Y.CONTRATO<1>
    Y.FECHA = TODAY
    Y.HORA = OCONV(TIME(), "MTS")
    R.NEW(ST.L.A76.ARRANGEMENT) = Y.AA
    R.NEW(ST.L.A76.CONTRATO) = Y.CONTRATO
    R.NEW(ST.L.A76.FECHA) = Y.FECHA
    R.NEW(ST.L.A76.HORA) = Y.HORA
RETURN

END
