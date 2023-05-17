SUBROUTINE REDO.S.GET.SYS.DATE
*-------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.GET.SYS.DATE
* Reference Number :ODR-2010-04-0424
*-------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the date and Convert the d
*                   dd mon yy (e.g. 01 JAN 09)
*LINKED WITH       :
* ------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN

PROCESS:
    TOD.DAY=TODAY
    TOD.DAY=ICONV(TOD.DAY,"D2")
    O.DATA=OCONV(TOD.DAY,"D2")

RETURN
END
