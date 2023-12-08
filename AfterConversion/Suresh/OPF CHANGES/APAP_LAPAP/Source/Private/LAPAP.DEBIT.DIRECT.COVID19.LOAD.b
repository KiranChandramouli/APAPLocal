$PACKAGE APAP.LAPAP
* @ValidationCode : MjotNDU1MDUwMTczOkNwMTI1MjoxNzAyMDMyMDY1MjkyOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 08 Dec 2023 16:11:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

* Limpieza de DEBIT.DIRECT - 2da Fase - Proyecto COVID19
* Fecha: 31/03/2020
* Autor: Oliver Fermin
*----------------------------------------

SUBROUTINE LAPAP.DEBIT.DIRECT.COVID19.LOAD
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-JULY-2023      Harsha                R22 Auto Conversion  - VM to @VM
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts
* 08-12-2023         Suresh               Manual R22 conversion - OPF TO OPEN
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_LAPAP.DEBIT.DIRECT.COVID19.COMO

    GOSUB OPEN.FILES

RETURN


OPEN.FILES:
**********

    FN.LAPAP.DEBIT.DIRECT.COVID19 = "F.LAPAP.DEBIT.DIRECT.COVID19"
    F.LAPAP.DEBIT.DIRECT.COVID19 = ""
    CALL OPF(FN.LAPAP.DEBIT.DIRECT.COVID19,F.LAPAP.DEBIT.DIRECT.COVID19)

    FN.AA="F.AA.ARRANGEMENT"
    F.AA=''
    CALL OPF(FN.AA,F.AA)

    FN.AA.SCHEDULE="F.AA.ARR.PAYMENT.SCHEDULE"
    F.AA.SCHEDULE=''
    CALL OPF(FN.AA.SCHEDULE,F.AA.SCHEDULE)

    FN.CHK.DIR = "&SAVEDLISTS&";
    F.CHK.DIR = ""
*   CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    OPEN FN.CHK.DIR TO F.CHK.DIR ELSE   ;*R22 Manual Conversion
    END   ;*R22 Manual Conversion
    FN.CHK.DIR1 = "DMFILES"
    F.CHK.DIR1 = ""
    CALL OPF(FN.CHK.DIR1,F.CHK.DIR1)

*---Parametros
    Y.ARCHIVO.NOMBRE.ARCHIVO.IN   = "CARGA.DEB.DIRECTO.COVID19.txt"
    Y.ARCHIVO.VALIDACION.OUT      = "PR.DEBIT.DIRECT.COVID19.VALIDACION.txt"
    Y.ARCHIVO.NOMBRE.DMT.OUT      = "PR.DEBIT.DIRECT.COVID19.txt"
    Y.PARM.PAY.METHOD             = "Manual"
    Y.PARAM.DEBT.AC               = ""

    LOC.REF.APPL = ''
    LOC.REF.APPL<1>   = "AA.PRD.DES.PAYMENT.SCHEDULE"
    LOC.REF.FIELDS<1> = "L.AA.DEBT.AC":@VM:"L.AA.PAY.METHD"
    LOC.REF.POS = ''

    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    L.AA.DEBT.AC.POS   = LOC.REF.POS<1,1>
    L.AA.PAY.METHD.POS  = LOC.REF.POS<1,2>

RETURN

END
