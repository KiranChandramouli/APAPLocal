$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.V.CLOPERIOD.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.IC.LAPAP.CLO.CHARGE.PARAM
*----------------------------------------------------------------------------------------------
*Company   Name    : Asociacion Popular de Ahorros y Prestamos
*Developed By      : J.Q.
*Program   Name    : LAPAP.V.CLOPERIOD.RT
*Reference         : CTO-9
*Date              : 2022-06-03
*----------------------------------------------------------------------------------------------

*DESCRIPTION       : THIS PROGRAM IS USED TO VALIDATE CLOSURE CHARGE PERIOD IN VERSIONS OF
*                    IC.LAPAP.CLO.CHARGE.PARAM
* ---------------------------------------------------------------------------------------------
    Y.CURR.CLO.PERIOD = COMI
    Y.CLO.PERIOD = R.NEW(IC.LAP86.CLO.PERIOD)
    Y.CNT = DCOUNT(Y.CLO.PERIOD,@VM)


END
