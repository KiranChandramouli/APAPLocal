$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.CERITOS.FX.JUV.RT.SELECT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CARD.RENEWAL
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.LY.POINTS
    $INSERT I_LAPAP.CERITOS.FX.JUV.COMMON
   $USING EB.Service

    GOSUB DO.SELECT
RETURN

DO.SELECT:
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.ACC : " WITH CATEGORY EQ 6024"

    CALL OCOMO("COMANDO SELECCION: " : SEL.CMD)
    IF Y.CAN.RUN EQ 'SI' THEN
        CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)
*        CALL BATCH.BUILD.LIST('',SEL.REC)
EB.Service.BatchBuildList('',SEL.REC);* R22 UTILITY AUTO CONVERSION
    END ELSE
        CALL OCOMO("PROCESO YA EJECUTADO PARA EL PERIODO, VER LOG ID: " : Y.RUN.ID)
        Y.EMPTY = ''
*        CALL BATCH.BUILD.LIST('',Y.EMPTY)
EB.Service.BatchBuildList('',Y.EMPTY);* R22 UTILITY AUTO CONVERSION
    END
RETURN



END
