$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.CUS.NAME(Y.INP.DEAL)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - Include to Insert 
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System

*--PARA ABRIR EL ACHIVO FBNK.CUSTOMER
    CALL REDO.CUST.IDENTITY.REF(Y.INP.DEAL, Y.ALT.ID, Y.CUS.NAME)

    Y.NAME.1         = Y.CUS.NAME[1,35]
    Y.NAME.2         = Y.CUS.NAME[36,LEN(Y.CUS.NAME)]

    Y.INP.DEAL = Y.NAME.1 : " " : Y.NAME.2

RETURN

END
