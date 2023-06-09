* @ValidationCode : MjotMzQ5ODU3MTM3OkNwMTI1MjoxNjg2MDQ2NTA1MzI4OnZpY3RvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Jun 2023 15:45:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.CASTIGADOS.RUEDA.POST

*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 18.05.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, T24.BP removed
* 18.05.2023       Shanmugapriya M       R22            Manual Conversion   -space removed
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON                 ;** R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.DATES                 ;** R22 Auto conversion - END

    GOSUB MAIN.PROCESS

RETURN

MAIN.PROCESS:
*************

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

OPEN.FILES:
**********

    Y.GRUPO1 = "";
    Y.EXCLUIDOS = "";

    FN.LAPAP.CASTIGADOS.RUEDA = "F.LAPAP.CASTIGADOS.RUEDA";
    F.LAPAP.CASTIGADOS.RUEDA = "";
    CALL OPF (FN.LAPAP.CASTIGADOS.RUEDA,F.LAPAP.CASTIGADOS.RUEDA)

***directorio de salidad
    FN.CHK.DIR1 = "DMFILES";
    F.CHK.DIR1 = "";
    CALL OPF(FN.CHK.DIR1,F.CHK.DIR1)

RETURN

PROCESS:
********

    SEL.CMD  = ''; NO.OF.RECS = ''; F.CHK.DIR = "" ; SEL.LIST= '';
    SEL.CMD = " SELECT " :FN.LAPAP.CASTIGADOS.RUEDA;
*CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SE L.ERR)
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)    ;* R22 Manual conversion

    LOOP
        REMOVE Y.ID.RECORD FROM SEL.LIST SETTING REGISTRO.POS
    WHILE Y.ID.RECORD  DO
        CALL F.READ(FN.LAPAP.CASTIGADOS.RUEDA,Y.ID.RECORD,R.LAPAP.CASTIGADOS.RUEDA,F.LAPAP.CASTIGADOS.RUEDA,ERROR.MIGR)
        Y.ID = Y.ID.RECORD
        Y.ID = CHANGE(Y.ID,'*',@FM)
        BEGIN CASE
            CASE Y.ID<2> EQ 'GRUPO1'
                Y.GRUPO1<-1> = R.LAPAP.CASTIGADOS.RUEDA
            CASE Y.ID<2> EQ 'EXCLUIDO'
                Y.EXCLUIDOS<-1> = R.LAPAP.CASTIGADOS.RUEDA
            CASE 1
                Y.VALOR = "NO REGISTRO"
        END CASE
    REPEAT

    IF Y.EXCLUIDOS NE '' THEN
        Y.FILE.NAME = 'CARGA0.CASTIGADO.EXCLUIDOS.txt';
        Y.ARREGLO = Y.EXCLUIDOS
        GOSUB CHECK.ARCHIVO.FILES
    END

    Y.FILE.NAME = 'CARGA1.AJUS.CASTIGADOS.RTC.txt';
    Y.ARREGLO = Y.GRUPO1
    GOSUB CHECK.ARCHIVO.FILES

RETURN

CHECK.ARCHIVO.FILES:
*******************

    R.FIL = ''; READ.FIL.ERR = '';
    CALL F.READ(FN.CHK.DIR1,Y.FILE.NAME,R.FIL,F.CHK.DIR1,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR1,Y.FILE.NAME
    END

    WRITE Y.ARREGLO ON F.CHK.DIR1, Y.FILE.NAME ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR1)
    END

RETURN

END
