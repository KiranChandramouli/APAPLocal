SUBROUTINE REDO.GET.CHRG.AMT(Y.CCY,Y.FT.CHRG.TYPE,Y.AMT)
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :H GANESH
*  Program   Name    :REDO.GET.CHRG.AMT
***********************************************************************************
*Description: This routine is to calculate the charge amount from FT type



*****************************************************************************
*linked with: NA
*In parameter: Y.CCY ,Y.FT.CHRG.TYPE
*Out parameter: Y.AMT
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*03.12.2010   H GANESH       ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CURRENCY
    $INSERT I_F.FT.CHARGE.TYPE




    GOSUB INIT
    GOSUB PROCESS
RETURN

*---------------------------------------------------
INIT:
*---------------------------------------------------

    FN.FT.CHARGE.TYPE='F.FT.CHARGE.TYPE'
    F.FT.CHARGE.TYPE=''
    CALL OPF(FN.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE)


RETURN

*---------------------------------------------------
PROCESS:
*---------------------------------------------------

    CALL CACHE.READ(FN.FT.CHARGE.TYPE, Y.FT.CHRG.TYPE, R.FT.CHARGE.TYPE, FT.ERR)
    LOCATE Y.CCY IN R.FT.CHARGE.TYPE<FT5.CURRENCY,1> SETTING POS.CHG THEN
        Y.AMT=R.FT.CHARGE.TYPE<FT5.FLAT.AMT,POS.CHG>
    END
RETURN

END
