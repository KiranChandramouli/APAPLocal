$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.CC.MASK
*-----------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S PRADEEP
*Program   Name    :REDO.E.CONV.CC.MASK
*-----------------------------------------------------------------------------------

*DESCRIPTION       :This Program is used for convert | TO *
*LINKED WITH       :REDO.NOF.GEN.CHQ.AGENCY
* -----------------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    Y.VAR = O.DATA
    CHANGE "|" TO "*" IN Y.VAR
    O.DATA=Y.VAR

RETURN
END
