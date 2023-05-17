SUBROUTINE REDO.S.FETCH.SYSTEM.DATE(SYS.DATE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.FETCH.SYS.DATE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the date and Convert the date into
*                   dd mon yy (e.g. 01 JAN 09)
*LINKED WITH       :
*Modification History
* Date             Resource          Reference           Description
* 1 Jul 2011       Kavitha           PACS00060198        PACS00060198  fix
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB PROCESS
RETURN

PROCESS:
    TOD.DAY=TODAY
*    TOD.DAY=ICONV(TOD.DAY,"D2")
*   SYS.DATE=OCONV(TOD.DAY,"D4/")
    SYS.DATE = TOD.DAY[7,2]:"/":TOD.DAY[5,2]:"/":TOD.DAY[1,4]

RETURN
END
