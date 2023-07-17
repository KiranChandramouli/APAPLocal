* @ValidationCode : MjoxNTMxMTE2ODE2OlVURi04OjE2ODkzMjk5Mjk4Njc6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 14 Jul 2023 15:48:49
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.PROCES.RN.RT.POST
*--------------------------------------------------------------------------------------------------
* Description           : Rutina POST para el proceso de actualizacion RN o RT
* Developed On          : 23-10-2021
* Developed By          : APAP
* Development Reference : ET-5416
*--------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion    BP is removed in insert file
* 14-07-2023    Narmadha V             R22 Manual onversion   No Changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto Conversion -START
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
*   $INSERT I_F.AA.OVERDUE
    $INSERT I_LAPAP.PROCES.RN.RT.COMMON
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.REDO.CAMPAIGN.TYPES ;*R22 Auto Conversion-END

    GOSUB PROCESO.PRINCIPAL
RETURN

PROCESO.PRINCIPAL:

    FN.LAPAP.CONCATE.RN.RT = 'F.LAPAP.RT.RN'
    FV.LAPAP.CONCATE.RN.RT = ''
    CALL OPF (FN.LAPAP.CONCATE.RN.RT,FV.LAPAP.CONCATE.RN.RT)

    FN.CHK.DIR = "DMFILES";
    F.CHK.DIR = '';
    CALL OPF (FN.CHK.DIR,F.CHK.DIR)
    Y.FILE.NAME = "INFILE.CONDICION.RN.RT.txt";

    CALL OCOMO("Generando archivo infile: INFILE.CONDICION.RN.RT.txt")
    SEL.CMD = " SELECT " : FN.LAPAP.CONCATE.RN.RT
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)

    LOOP
        REMOVE Y.ID.RECORD FROM SEL.LIST SETTING REGISTRO.POS
    WHILE Y.ID.RECORD  DO
        CALL F.READ (FN.LAPAP.CONCATE.RN.RT,Y.ID.RECORD,R.LAPAP.CONCATE.RN.RT,FV.LAPAP.CONCATE.RN.RT,ERROR.FV.LAPAP.CONCATE.RN.RT)
        Y.ARREGLO<-1> = R.LAPAP.CONCATE.RN.RT
    REPEAT

    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,Y.FILE.NAME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,Y.FILE.NAME
    END
    WRITE Y.ARREGLO ON F.CHK.DIR, Y.FILE.NAME ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR)
    END


RETURN



END
