* @ValidationCode : MjotMTA4NjUxOTM4NjpDcDEyNTI6MTY5MDE2NzU0MjU2MDpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:02
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
SUBROUTINE LAPAP.CONTROL.ESTADOS.RT.LOAD

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts 

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.ST.LAPAP.CONTROL.ESTADOS
    $INSERT I_F.HOLD.CONTROL
    $INSERT I_CONTROL.ESTADOS.COMMON


    GOSUB OPENER
    GOSUB SEIS.MESES.ANTES

RETURN

OPENER:
    FN.HC = "F.HOLD.CONTROL"
    FV.HC = ''
    CALL OPF(FN.HC,FV.HC)
    FN.CE = "FBNK.ST.LAPAP.CONTROL.ESTADOS"
    FV.CE = ""
    CALL OPF(FN.CE,FV.CE)
    FN.ES = "../bnk.interface/ESTADO"
    FV.ES = ""
    CALL OPF(FN.ES,FV.ES)

RETURN

SEIS.MESES.ANTES:
    OLD.DATE = TODAY
    DAY.COUNT = "-180W"
    CALL CDT('', OLD.DATE, DAY.COUNT)
    CALL OCOMO("Fecha discriminante anterior: " : OLD.DATE)
RETURN

END

