* @ValidationCode : MjotMTY0MjAyNjMzNDpDcDEyNTI6MTY4NDIyMjgxMzA3MjpJVFNTOi0xOi0xOjQ4NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 485
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.NEW.CONDITION.RT.POST

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE������������� WHO��������������� REFERENCE���������������� DESCRIPTION

* 21-APR-2023���� Conversion tool��� R22 Auto conversion������ BP is removed in Insert File
* 21-APR-2023    Narmadha V           R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------

*==============================================================================
*==============================================================================

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_TSA.COMMON
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.AA.OVERDUE
    $INSERT I_BATCH.FILES ;*R22 Auto conversion - END
    Y.ACTIVIDAD = "LENDING-UPDATE-APAP.OVERDUE"
    Y.PROPERTY = "APAP.OVERDUE"
    Y.ARCHIVO.CARGA = "LOAD.CONDITION.txt"
    Y.FILE.LOAD.NAME = "AA.LIST.UPD"
    Y.CAMPO.COND = "L.LOAN.COND"
    Y.CAMPO.COMENT = "L.LOAN.COMMENT1"
    Y.FILE.FINAL = "AA.LIST.UPD"

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*==========*
OPEN.FILES:
*==========*
    FN.EB.LOOKUP = "F.EB.LOOKUP" ; FV.EB.LOOKUP = ""
    CALL OPF(FN.EB.LOOKUP,FV.EB.LOOKUP)

    FN.CHK.DIR = "DMFILES" ; F.CHK.DIR = ""
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    FN.CONCATE.WRITE = "F.LAPAP.CONCATE.CONDIC"
    FV.CONCATE.WRITE = ""
    CALL OPF (FN.CONCATE.WRITE,FV.CONCATE.WRITE)
RETURN

*==========*
PROCESS:  *Se cuentan los multivalores del campo L.LOAN.COND, para sumarle 1 y que de esta manera se agregue la nueva condicion.
*==========*

    CRT "Generación del archivo plano : ":Y.FILE.FINAL
    SEL.CMD = "SELECT ":FN.CONCATE.WRITE
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)

    LOOP
        REMOVE Y.REGISTRO FROM SEL.LIST SETTING LI.POS
    WHILE Y.REGISTRO DO
        CALL F.READ(FN.CONCATE.WRITE,Y.REGISTRO,R.CONCATE.WRITE,FV.CONCATE.WRITE,ERR.CONCATE.WRITE)
        CRT "Ëscribiendo el contrato :":Y.REGISTRO
        Y.ARREGLO<-1> = R.CONCATE.WRITE

    REPEAT

    Y.FILE.NAME = Y.FILE.FINAL
    WRITE Y.ARREGLO ON F.CHK.DIR, Y.FILE.NAME ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR)
    END
    CRT "Generación del archivo plano creado de forma correcta: ":Y.FILE.FINAL
RETURN

END
