$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.SPREAD
*-----------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S PRADEEP
*Program   Name    :REDO.E.CONV.SPREAD
*-----------------------------------------------------------------------------------

*DESCRIPTION       :This Program is used for convert to Amount format
*LINKED WITH       :REDO.APAP.ENQ.MM.PLCMNT.FIXD.LST
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
    Y.VAR = FMT(Y.VAR,"19R,2")
    O.DATA=Y.VAR
RETURN
END
