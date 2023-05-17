SUBROUTINE REDO.E.CONV.SPREAD
*-----------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S PRADEEP
*Program   Name    :REDO.E.CONV.SPREAD
*-----------------------------------------------------------------------------------

*DESCRIPTION       :This Program is used for convert to Amount format
*LINKED WITH       :REDO.APAP.ENQ.MM.PLCMNT.FIXD.LST
* -----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    Y.VAR = O.DATA
    Y.VAR = FMT(Y.VAR,"19R,2")
    O.DATA=Y.VAR
RETURN
END
