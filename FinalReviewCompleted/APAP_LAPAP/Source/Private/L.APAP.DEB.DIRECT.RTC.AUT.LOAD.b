* @ValidationCode : MjozNTQyNzIzNjE6Q3AxMjUyOjE2OTAxNjc1Mjk2MDU6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:49
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
SUBROUTINE L.APAP.DEB.DIRECT.RTC.AUT.LOAD
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed in INSERTFILE
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_L.APAP.DEB.DIRECT.RTC.AUT.COMMON


    GOSUB OPEN.FILES

RETURN

OPEN.FILES:
**********
    Y.ARCHIVO.CARGA = "INFILE.DEBITO.DIRECTO.txt";
    FN.LAPAP.CONCATE.DEB.DIR = "F.LAPAP.CONCATE.DEB.DIR";
    F.LAPAP.CONCATE.DEB.DIR = "";
    CALL OPF (FN.LAPAP.CONCATE.DEB.DIR,F.LAPAP.CONCATE.DEB.DIR)
    FN.CHK.DIR1 = "DMFILES";
    F.CHK.DIR1 = "";
    CALL OPF(FN.CHK.DIR1,F.CHK.DIR1)
    FN.ACCOUNT = "F.ACCOUNT";
    F.ACCOUNT = "";
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
    F.AA.ARRANGEMENT = "";
    CALL OPF (FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    GOSUB GET.LOCAL.REFS

RETURN

GET.LOCAL.REFS:
    L.AC.AV.BAL.POS = '';
    CALL GET.LOC.REF('ACCOUNT','L.AC.AV.BAL',L.AC.AV.BAL.POS)
RETURN

END
