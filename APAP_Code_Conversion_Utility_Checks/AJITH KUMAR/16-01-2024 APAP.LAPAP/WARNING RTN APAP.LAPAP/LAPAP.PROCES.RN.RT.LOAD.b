* @ValidationCode : MjoxMzI3MTEzNDMxOlVURi04OjE2ODk3NDk2NTYzNDY6SVRTUzotMTotMTozOTA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:16
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 390
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.PROCES.RN.RT.LOAD
*--------------------------------------------------------------------------------------------------
* Description           : Rutina LOAD para el proceso de actualizacion RN o RT
* Developed On          : 23-10-2021
* Developed By          : APAP
* Development Reference : ET-5416
*--------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 14-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion -START
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
   $USING EB.LocalReferences
*   $INSERT I_F.AA.OVERDUE
    $INSERT I_LAPAP.PROCES.RN.RT.COMMON
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.REDO.CAMPAIGN.TYPES ;*R22 Auto Conversion - END


    GOSUB TABLAS
    GOSUB GET.CAMPOS.LOCALES
RETURN
TABLAS:

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    FV.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF (FN.AA.ARRANGEMENT.ACTIVITY,FV.AA.ARRANGEMENT.ACTIVITY)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    FV.AA.ARRANGEMENT = ''
    CALL OPF (FN.AA.ARRANGEMENT,FV.AA.ARRANGEMENT)

    FN.LAPAP.CONCATE.RN.RT = 'F.LAPAP.RT.RN'
    FV.LAPAP.CONCATE.RN.RT = ''
    CALL OPF (FN.LAPAP.CONCATE.RN.RT,FV.LAPAP.CONCATE.RN.RT)
    FN.REDO.CAMPAIGN.TYPES = 'F.REDO.CAMPAIGN.TYPES';
    FV.REDO.CAMPAIGN.TYPES = '';
    CALL OPF (FN.REDO.CAMPAIGN.TYPES,FV.REDO.CAMPAIGN.TYPES)
    Y.ACTIVIDAD = 'LENDING-DISBURSE-COMMITMENT';

RETURN

GET.CAMPOS.LOCALES:
    L.LOAN.STATUS.1.POS = ''; L.STATUS.CHG.DT.POS = ''; L.LOAN.COND.POS = ''; L.RESTRUCT.TYPE.POS = ''; L.AA.CAMP.TY.POS = '';
*    CALL GET.LOC.REF ("AA.PRD.DES.OVERDUE", "L.LOAN.STATUS.1",L.LOAN.STATUS.1.POS)
EB.LocalReferences.GetLocRef ("AA.PRD.DES.OVERDUE", "L.LOAN.STATUS.1",L.LOAN.STATUS.1.POS);* R22 UTILITY AUTO CONVERSION
*    CALL GET.LOC.REF ("AA.PRD.DES.OVERDUE", "L.STATUS.CHG.DT",L.STATUS.CHG.DT.POS)
EB.LocalReferences.GetLocRef ("AA.PRD.DES.OVERDUE", "L.STATUS.CHG.DT",L.STATUS.CHG.DT.POS);* R22 UTILITY AUTO CONVERSION
*    CALL GET.LOC.REF ("AA.PRD.DES.OVERDUE", "L.LOAN.COND",L.LOAN.COND.POS)
EB.LocalReferences.GetLocRef ("AA.PRD.DES.OVERDUE", "L.LOAN.COND",L.LOAN.COND.POS);* R22 UTILITY AUTO CONVERSION
*    CALL GET.LOC.REF ("AA.PRD.DES.OVERDUE", "L.RESTRUCT.TYPE",L.RESTRUCT.TYPE.POS)
EB.LocalReferences.GetLocRef ("AA.PRD.DES.OVERDUE", "L.RESTRUCT.TYPE",L.RESTRUCT.TYPE.POS);* R22 UTILITY AUTO CONVERSION
*    CALL GET.LOC.REF ("AA.PRD.DES.CUSTOMER", "L.AA.CAMP.TY",L.AA.CAMP.TY.POS)
EB.LocalReferences.GetLocRef ("AA.PRD.DES.CUSTOMER", "L.AA.CAMP.TY",L.AA.CAMP.TY.POS);* R22 UTILITY AUTO CONVERSION
*    CALL GET.LOC.REF ("REDO.CAMPAIGN.TYPES", "L.LOAN.COND",L.LOAN.COND.T.POS)
EB.LocalReferences.GetLocRef ("REDO.CAMPAIGN.TYPES", "L.LOAN.COND",L.LOAN.COND.T.POS);* R22 UTILITY AUTO CONVERSION


RETURN

END
